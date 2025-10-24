import 'package:flutter/material.dart';

import '../models/name_entry.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';
import 'streak_provider.dart';

class NamesProvider extends ChangeNotifier {
  NamesProvider(this._dataService, this._storageService, this._streakProvider);

  final DataService _dataService;
  final StorageService _storageService;
  final StreakProvider _streakProvider;

  List<NameEntry> _names = <NameEntry>[];
  List<NameEntry> _filtered = <NameEntry>[];
  Set<int> _reviewed = <int>{};
  String _searchQuery = '';
  String _language = 'en';
  bool _loading = false;

  List<NameEntry> get names => List.unmodifiable(_filtered);
  bool get loading => _loading;
  Set<int> get reviewed => _reviewed;
  double get completion => _names.isEmpty ? 0 : _reviewed.length / _names.length;

  Future<void> load(String lang) async {
    _loading = true;
    _language = lang;
    notifyListeners();
    _names = await _dataService.loadNames(lang);
    _reviewed = await _storageService.getReviewedNames();
    _applyFilter();
    _loading = false;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List<NameEntry>.from(_names);
      return;
    }
    _filtered = _names.where((entry) {
      final target = '${entry.name} ${entry.meaning}'.toLowerCase();
      return target.contains(_searchQuery);
    }).toList();
  }

  Future<void> toggleReviewed(int index) async {
    if (_reviewed.contains(index)) {
      _reviewed.remove(index);
    } else {
      _reviewed.add(index);
      await _streakProvider.markReviewedToday();
    }
    await _storageService.setReviewedNames(_reviewed);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _reviewed.clear();
    await _storageService.setReviewedNames(_reviewed);
    _applyFilter();
    notifyListeners();
  }

  String nameLabel(NameEntry entry) => entry.name;

  bool isReviewed(int index) => _reviewed.contains(index);

  int get reviewedCount => _reviewed.length;

  String get language => _language;

  List<NameEntry> get allNames => List.unmodifiable(_names);
}
