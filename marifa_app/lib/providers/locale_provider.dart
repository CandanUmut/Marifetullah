import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider(this._storageService);

  final StorageService _storageService;

  String _language = 'en';
  bool _initialized = false;

  String get language => _language;
  bool get initialized => _initialized;

  Future<void> loadLanguage() async {
    final saved = await _storageService.getLanguage();
    if (saved != null) {
      _language = saved;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    if (lang == _language) return;
    _language = lang;
    await _storageService.setLanguage(lang);
    notifyListeners();
  }
}
