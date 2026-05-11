import 'package:flutter/material.dart';
import 'package:madenler_kasa_sistemi/app/state.dart';

class KasaView extends StatelessWidget {
  const KasaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      child: ValueListenableBuilder<List<MadenItem>>(
        valueListenable: kasaItems,
        builder: (context, items, child) {
          if (items.isEmpty) {
            return const Center(
              child: Text('Kasa boş. Ana sayfadan ürün ekleyin.'),
            );
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Birim Fiyatı: ${item.unitPriceDisplay}'),
                      Text('Miktar: ${item.weightDisplay}'),
                      Text('Toplam: ${item.totalPriceDisplay}'),
                      Text('Saflık: ${item.purity}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
