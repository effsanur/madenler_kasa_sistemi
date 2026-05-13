import 'package:flutter/material.dart';
import 'package:madenler_kasa_sistemi/app/state.dart';

class AnasayfaView extends StatefulWidget {
  const AnasayfaView({super.key});

  @override
  State<AnasayfaView> createState() => _AnasayfaViewState();
}

class _AnasayfaViewState extends State<AnasayfaView> {
  static final List<MadenItem> _madenler = [
    MadenItem(
      name: 'Altın',
      unitPrice: 1234,
      priceUnitLabel: 'TL/g',
      unit: 'g',
      quantity: 1,
      purity: '99.9%',
    ),
    MadenItem(
      name: 'Gümüş',
      unitPrice: 28,
      priceUnitLabel: 'TL/g',
      unit: 'g',
      quantity: 1,
      purity: '99.5%',
    ),
    MadenItem(
      name: 'Platin',
      unitPrice: 950,
      priceUnitLabel: 'TL/g',
      unit: 'g',
      quantity: 1,
      purity: '99.8%',
    ),
    MadenItem(
      name: 'İnci',
      unitPrice: 1500,
      priceUnitLabel: 'TL/adet',
      unit: 'adet',
      quantity: 1,
      purity: 'Doğal',
    ),
    MadenItem(
      name: 'Elmas',
      unitPrice: 3000,
      priceUnitLabel: 'TL/karat',
      unit: 'karat',
      quantity: 1,
      purity: 'VS1',
    ),
    MadenItem(
      name: 'Yakut',
      unitPrice: 2200,
      priceUnitLabel: 'TL/karat',
      unit: 'karat',
      quantity: 1,
      purity: 'AAA',
    ),
  ];

  String _searchQuery = '';
  final Map<String, bool> _expanded = {};
  final Map<String, TextEditingController> _quantityControllers = {};

  @override
  void initState() {
    super.initState();
    for (var item in _madenler) {
      _expanded[item.name] = false;
      _quantityControllers[item.name] = TextEditingController(text: item.quantity.toStringAsFixed(0));
    }
  }

  @override
  void dispose() {
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double _parseQuantity(MadenItem item) {
    final controller = _quantityControllers[item.name];
    if (controller == null) return 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Builder(
                builder: (context) {
                  final filteredMadenler = _madenler.where((item) {
                    if (_searchQuery.trim().isEmpty) return true;
                    return item.name.toLowerCase().contains(_searchQuery.trim().toLowerCase());
                  }).toList();

                  return ListView.separated(
                    itemCount: filteredMadenler.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filteredMadenler[index];
                      final totalText = _totalFor(item);
                      final isExpanded = _expanded[item.name] ?? false;

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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildMadenInfoRow(item),
                                  if (isExpanded) ...[
                                    const SizedBox(height: 14),
                                    TextField(
                                      controller: _quantityControllers[item.name],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
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
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
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
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Lütfen geçerli bir miktar girin.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        addToKasa(
                                          item.copyWith(quantity: quantity),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${item.name} kasaya eklendi.',
                                            ),
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
