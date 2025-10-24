import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:marifa_app/models/name_entry.dart';

void main() {
  test('NameEntry parses correctly from JSON', () {
    const sample = '''{
      "index": 5,
      "arabic": "ٱلْقُدُّوسُ",
      "name_en": "Al-Quddus",
      "name_tr": "El-Kuddûs",
      "meaning_en": "The Absolutely Pure",
      "meaning_tr": "Mutlak pak",
      "tefekkur_en": "Reflect on transcendence.",
      "tefekkur_tr": "Tenzihi tefekkür et.",
      "practice_en": "Guard your heart.",
      "practice_tr": "Kalbini koru."
    }''';

    final Map<String, dynamic> jsonMap = json.decode(sample) as Map<String, dynamic>;
    final entryEn = NameEntry.fromJson(jsonMap, 'en');
    final entryTr = NameEntry.fromJson(jsonMap, 'tr');

    expect(entryEn.name, 'Al-Quddus');
    expect(entryEn.meaning, 'The Absolutely Pure');
    expect(entryTr.name, 'El-Kuddûs');
    expect(entryTr.practice, 'Kalbini koru.');
  });
}
