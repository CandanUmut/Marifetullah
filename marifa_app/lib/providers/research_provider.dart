import 'package:flutter/material.dart';

import '../models/research_section.dart';
import '../services/data_service.dart';

class ResearchProvider extends ChangeNotifier {
  ResearchProvider(this._dataService);

  final DataService _dataService;

  List<ResearchSection> _sections = <ResearchSection>[];
  bool _loading = false;

  List<ResearchSection> get sections => List.unmodifiable(_sections);
  bool get loading => _loading;

  Future<void> load(String lang) async {
    _loading = true;
    notifyListeners();
    _sections = await _dataService.loadResearch(lang);
    _loading = false;
    notifyListeners();
  }
}
