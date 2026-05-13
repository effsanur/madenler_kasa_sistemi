import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> addLog(String message) async {
  final prefs = await SharedPreferences.getInstance();
  final logs = prefs.getStringList('app_logs') ?? [];
  final timestamp = DateTime.now().toIso8601String();
  logs.insert(0, '$timestamp|$message');
  await prefs.setStringList('app_logs', logs);
}

Future<List<String>> getLogs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('app_logs') ?? [];
}

class MadenItem {
  final String name;
  final double unitPrice;
  final String priceUnitLabel;
  final String unit;
  final double quantity;
  final String purity;

  MadenItem({
    required this.name,
    required this.unitPrice,
    required this.priceUnitLabel,
    required this.unit,
    required this.quantity,
    required this.purity,
  });

  static String _formatNumber(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }

  String get unitPriceDisplay => '${_formatNumber(unitPrice)} $priceUnitLabel';

  String get weightDisplay => '${_formatNumber(quantity)} $unit';

  String get totalPriceDisplay => '${_formatNumber(unitPrice * quantity)} TL';

  MadenItem copyWith({double? quantity}) {
    return MadenItem(
      name: name,
      unitPrice: unitPrice,
      priceUnitLabel: priceUnitLabel,
      unit: unit,
      quantity: quantity ?? this.quantity,
      purity: purity,
    );
  }
}

final ValueNotifier<List<MadenItem>> kasaItems = ValueNotifier<List<MadenItem>>(
  [],
);

void addToKasa(MadenItem item) {
  kasaItems.value = [...kasaItems.value, item];
}

void removeFromKasa(MadenItem item) {
  final currentList = List<MadenItem>.from(kasaItems.value);
  currentList.remove(item);
  kasaItems.value = currentList;
}
