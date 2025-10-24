import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/name_entry.dart';
import '../models/research_section.dart';

class DataService {
  Future<List<NameEntry>> loadNames(String lang) async {
    final assetPath = lang == 'tr' ? 'assets/names_tr.json' : 'assets/names_en.json';
    final data = await rootBundle.loadString(assetPath);
    final List<dynamic> decoded = json.decode(data) as List<dynamic>;
    return decoded
        .map((item) => NameEntry.fromJson(item as Map<String, dynamic>, lang))
        .toList();
  }

  Future<List<ResearchSection>> loadResearch(String lang) async {
    final assetPath = lang == 'tr' ? 'assets/research_tr.json' : 'assets/research_en.json';
    final data = await rootBundle.loadString(assetPath);
    final decoded = json.decode(data) as Map<String, dynamic>;
    final sections = decoded['sections'] as List<dynamic>;
    return sections
        .map((item) => ResearchSection.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
