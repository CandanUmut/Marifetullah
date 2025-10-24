class NameEntry {
  final int index;
  final String arabic;
  final String name;
  final String meaning;
  final String tefekkur;
  final String practice;

  NameEntry({
    required this.index,
    required this.arabic,
    required this.name,
    required this.meaning,
    required this.tefekkur,
    required this.practice,
  });

  factory NameEntry.fromJson(Map<String, dynamic> json, String lang) {
    final titleKey = lang == 'tr' ? 'name_tr' : 'name_en';
    final meaningKey = lang == 'tr' ? 'meaning_tr' : 'meaning_en';
    final tefekkurKey = lang == 'tr' ? 'tefekkur_tr' : 'tefekkur_en';
    final practiceKey = lang == 'tr' ? 'practice_tr' : 'practice_en';

    return NameEntry(
      index: json['index'] as int,
      arabic: json['arabic'] as String,
      name: json[titleKey] as String,
      meaning: json[meaningKey] as String,
      tefekkur: json[tefekkurKey] as String,
      practice: json[practiceKey] as String,
    );
  }
}
