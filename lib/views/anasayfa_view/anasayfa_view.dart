import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madenler_kasa_sistemi/app/state.dart';

class AnasayfaView extends StatefulWidget {
  const AnasayfaView({super.key});

  @override
  State<AnasayfaView> createState() => _AnasayfaViewState();
}

class _AnasayfaViewState extends State<AnasayfaView> {
  String _searchQuery = '';
  final Map<String, bool> _expanded = {};
  final Map<String, TextEditingController> _quantityControllers = {};

  bool get _isAdmin {
    final email = FirebaseAuth.instance.currentUser?.email;
    return email == 'admin@madenler.com';
  }

  @override
  void dispose() {
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String name) {
    if (!_quantityControllers.containsKey(name)) {
      _quantityControllers[name] = TextEditingController(text: '1');
    }
    return _quantityControllers[name]!;
  }

  bool _isExpanded(String name) {
    return _expanded[name] ?? false;
  }

  double _parseQuantity(MadenItem item) {
    final controller = _getController(item.name);
    final raw = controller.text.trim().replaceAll(',', '.');
    final value = double.tryParse(raw);
    return value == null || value <= 0 ? 0 : value;
  }

  String _totalFor(MadenItem item) {
    final amount = _parseQuantity(item);
    if (amount <= 0) {
      return 'Lütfen geçerli bir değer girin.';
    }

    final total = item.unitPrice * amount;
    return '${total.toStringAsFixed(2)} TL';
  }

  Widget _buildMadenInfoRow(MadenItem item) {
    final assetName = _madenAssetName(item.name);
    if (assetName != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Birim Fiyatı: ${item.unitPriceDisplay}'),
                Text('Saflık: ${item.purity}'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            'assets/images/$assetName',
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Birim Fiyatı: ${item.unitPriceDisplay}'),
        Text('Saflık: ${item.purity}'),
      ],
    );
  }

  String? _madenAssetName(String name) {
    switch (name) {
      case 'Altın':
        return 'altin.png';
      case 'Gümüş':
        return 'gümüs.png';
      case 'Platin':
        return 'platin.png';
      case 'İnci':
        return 'inci.png';
      case 'Elmas':
        return 'elmas.png';
      case 'Yakut':
        return 'yakut.png';
      default:
        return null;
    }
  }

  void _showAddMadenDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final priceUnitLabelController = TextEditingController(text: 'TL/g');
    final unitController = TextEditingController(text: 'g');
    final purityController = TextEditingController(text: '99.9%');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Maden Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Maden Adı'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Birim Fiyatı'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceUnitLabelController,
                  decoration: const InputDecoration(labelText: 'Fiyat Birimi (Örn: TL/g)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'Miktar Birimi (Örn: g)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: purityController,
                  decoration: const InputDecoration(labelText: 'Saflık (Örn: 99.9%)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final priceRaw = priceController.text.trim().replaceAll(',', '.');
                final price = double.tryParse(priceRaw);
                final priceUnit = priceUnitLabelController.text.trim();
                final unit = unitController.text.trim();
                final purity = purityController.text.trim();

                if (name.isNotEmpty && price != null && price > 0) {
                  final newItem = MadenItem(
                    name: name,
                    unitPrice: price,
                    priceUnitLabel: priceUnit,
                    unit: unit,
                    quantity: 1, // default view quantity
                    purity: purity,
                  );
                  addAnasayfaMaden(newItem);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name başarıyla eklendi.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen geçerli bilgiler girin.')),
                  );
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: _showAddMadenDialog,
              child: const Icon(Icons.add),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                labelText: 'Maden Arama',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Öne Çıkan Madenler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ValueListenableBuilder<List<MadenItem>>(
                valueListenable: anasayfaMadenler,
                builder: (context, madenler, _) {
                  final filteredMadenler = madenler.where((item) {
                    if (_searchQuery.trim().isEmpty) return true;
                    return item.name.toLowerCase().contains(_searchQuery.trim().toLowerCase());
                  }).toList();

                  return ListView.separated(
                    itemCount: filteredMadenler.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filteredMadenler[index];
                      final totalText = _totalFor(item);
                      final isExpanded = _isExpanded(item.name);
                      final controller = _getController(item.name);

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 140),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      setState(() {
                                        _expanded[item.name] = !isExpanded;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          isExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildMadenInfoRow(item),
                                  if (isExpanded) ...[
                                    const SizedBox(height: 14),
                                    TextField(
                                      controller: controller,
                                      keyboardType: const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Alınan Ağırlık / Miktar',
                                        suffixText: item.unit,
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                    const SizedBox(height: 12),
                                    Text('Toplam Tutar: $totalText'),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add_shopping_cart),
                                      label: const Text('Kasaya Ekle'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        foregroundColor: Colors.black,
                                        minimumSize: const Size.fromHeight(44),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        final quantity = _parseQuantity(item);
                                        if (quantity <= 0) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Lütfen geçerli bir miktar girin.'),
                                            ),
                                          );
                                          return;
                                        }
                                        addToKasa(
                                          item.copyWith(quantity: quantity),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${item.name} kasaya eklendi.'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
