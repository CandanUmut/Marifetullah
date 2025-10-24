import 'package:flutter/foundation.dart';

import '../services/storage_service.dart';
import '../utils/date_utils.dart';

class StreakProvider extends ChangeNotifier {
  StreakProvider(this._storageService);

  final StorageService _storageService;

  int _streak = 0;
  String? _lastDate;
  bool _initialized = false;

  int get streak => _streak;
  bool get initialized => _initialized;

  Future<void> load() async {
    final log = await _storageService.getStreakLog();
    _lastDate = log['lastDate'] as String?;
    _streak = (log['streak'] as int?) ?? 0;
    _initialized = true;
    notifyListeners();
  }

  Future<void> markReviewedToday() async {
    final today = StreakDateUtils.toDateString(DateTime.now());
    if (_lastDate == today) {
      return;
    }
    if (_lastDate != null && StreakDateUtils.isNextDay(_lastDate!, today)) {
      _streak += 1;
    } else {
      _streak = 1;
    }
    _lastDate = today;
    await _storageService.setStreakLog({'lastDate': _lastDate, 'streak': _streak});
    notifyListeners();
  }

  Future<void> reset() async {
    _streak = 0;
    _lastDate = null;
    await _storageService.setStreakLog({});
    notifyListeners();
  }
}
