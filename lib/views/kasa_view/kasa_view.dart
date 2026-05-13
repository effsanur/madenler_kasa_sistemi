import 'package:flutter/material.dart';
import 'package:madenler_kasa_sistemi/app/state.dart';

class KasaView extends StatelessWidget {
  const KasaView({super.key});

  Widget _buildKasaMadenRow(MadenItem item) {
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              removeFromKasa(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item.name} kasadan çıkarıldı.'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildKasaMadenRow(item),
                      const SizedBox(height: 8),
                      Text('Miktar: ${item.weightDisplay}'),
                      Text('Toplam: ${item.totalPriceDisplay}'),
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
