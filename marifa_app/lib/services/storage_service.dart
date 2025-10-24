import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _instance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<String?> getLanguage() async {
    final prefs = await _instance();
    return prefs.getString(PrefKeys.language);
  }

  Future<void> setLanguage(String lang) async {
    final prefs = await _instance();
    await prefs.setString(PrefKeys.language, lang);
  }

  Future<Set<int>> getReviewedNames() async {
    final prefs = await _instance();
    final stored = prefs.getStringList(PrefKeys.reviewedNames) ?? <String>[];
    return stored.map(int.parse).toSet();
  }

  Future<void> setReviewedNames(Set<int> indices) async {
    final prefs = await _instance();
    await prefs.setStringList(
      PrefKeys.reviewedNames,
      indices.map((i) => i.toString()).toList(),
    );
  }

  Future<Map<String, dynamic>> getStreakLog() async {
    final prefs = await _instance();
    final data = prefs.getString(PrefKeys.streakLog);
    if (data == null) {
      return <String, dynamic>{};
    }
    return json.decode(data) as Map<String, dynamic>;
  }

  Future<void> setStreakLog(Map<String, dynamic> log) async {
    final prefs = await _instance();
    await prefs.setString(PrefKeys.streakLog, json.encode(log));
  }

  Future<void> resetProgress() async {
    final prefs = await _instance();
    await prefs.remove(PrefKeys.reviewedNames);
    await prefs.remove(PrefKeys.streakLog);
  }
}
