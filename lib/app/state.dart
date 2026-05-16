import 'dart:convert';
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unitPrice': unitPrice,
      'priceUnitLabel': priceUnitLabel,
      'unit': unit,
      'quantity': quantity,
      'purity': purity,
    };
  }

  factory MadenItem.fromJson(Map<String, dynamic> json) {
    return MadenItem(
      name: json['name'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      priceUnitLabel: json['priceUnitLabel'] as String,
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      purity: json['purity'] as String,
    );
  }
}

final ValueNotifier<List<MadenItem>> anasayfaMadenler = ValueNotifier<List<MadenItem>>([]);

Future<void> loadAnasayfaMadenler() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('anasayfa_madenler');
  if (jsonString != null) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    anasayfaMadenler.value = jsonList.map((e) => MadenItem.fromJson(e as Map<String, dynamic>)).toList();
  } else {
    // Default values if nothing saved yet
    anasayfaMadenler.value = [
      MadenItem(name: 'Altın', unitPrice: 1234, priceUnitLabel: 'TL/g', unit: 'g', quantity: 1, purity: '99.9%'),
      MadenItem(name: 'Gümüş', unitPrice: 28, priceUnitLabel: 'TL/g', unit: 'g', quantity: 1, purity: '99.5%'),
      MadenItem(name: 'Platin', unitPrice: 950, priceUnitLabel: 'TL/g', unit: 'g', quantity: 1, purity: '99.8%'),
      MadenItem(name: 'İnci', unitPrice: 1500, priceUnitLabel: 'TL/adet', unit: 'adet', quantity: 1, purity: 'Doğal'),
      MadenItem(name: 'Elmas', unitPrice: 3000, priceUnitLabel: 'TL/karat', unit: 'karat', quantity: 1, purity: 'VS1'),
      MadenItem(name: 'Yakut', unitPrice: 2200, priceUnitLabel: 'TL/karat', unit: 'karat', quantity: 1, purity: 'AAA'),
    ];
  }
}

Future<void> addAnasayfaMaden(MadenItem item) async {
  anasayfaMadenler.value = [...anasayfaMadenler.value, item];
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(anasayfaMadenler.value.map((e) => e.toJson()).toList());
  await prefs.setString('anasayfa_madenler', jsonString);
}

final ValueNotifier<List<MadenItem>> kasaItems = ValueNotifier<List<MadenItem>>([]);

void addToKasa(MadenItem item) {
  kasaItems.value = [...kasaItems.value, item];
}

void removeFromKasa(MadenItem item) {
  final currentList = List<MadenItem>.from(kasaItems.value);
  currentList.remove(item);
  kasaItems.value = currentList;
}
