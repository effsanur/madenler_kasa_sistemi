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
  ];

  final List<bool> _expanded = List<bool>.filled(_madenler.length, false);
  late final List<TextEditingController> _quantityControllers = _madenler
      .map(
        (item) => TextEditingController(text: item.quantity.toStringAsFixed(0)),
      )
      .toList();

  @override
  void dispose() {
    for (final controller in _quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double _parseQuantity(int index) {
    final raw = _quantityControllers[index].text.trim().replaceAll(',', '.');
    final value = double.tryParse(raw);
    return value == null || value <= 0 ? 0 : value;
  }

  String _totalFor(int index) {
    final amount = _parseQuantity(index);
    if (amount <= 0) {
      return 'Lütfen geçerli bir değer girin.';
    }

    final total = _madenler[index].unitPrice * amount;
    return '${total.toStringAsFixed(2)} TL';
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
              child: ListView.separated(
                itemCount: _madenler.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _madenler[index];
                  final totalText = _totalFor(index);
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
                                    _expanded[index] = !_expanded[index];
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
                                      _expanded[index]
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
                              Text('Birim Fiyatı: ${item.unitPriceDisplay}'),
                              Text('Saflık: ${item.purity}'),
                              if (_expanded[index]) ...[
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _quantityControllers[index],
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
                                    minimumSize: const Size.fromHeight(44),
                                  ),
                                  onPressed: () {
                                    final quantity = _parseQuantity(index);
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
