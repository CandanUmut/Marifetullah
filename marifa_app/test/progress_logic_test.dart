import 'package:flutter_test/flutter_test.dart';

import 'package:marifa_app/models/name_entry.dart';
import 'package:marifa_app/providers/names_provider.dart';
import 'package:marifa_app/providers/streak_provider.dart';
import 'package:marifa_app/services/data_service.dart';
import 'package:marifa_app/services/storage_service.dart';
import 'package:marifa_app/utils/date_utils.dart';

class _FakeDataService extends DataService {
  @override
  Future<List<NameEntry>> loadNames(String lang) async {
    return [
      NameEntry(
        index: 1,
        arabic: 'ٱلرَّحْمَٰنُ',
        name: lang == 'tr' ? 'Er-Rahmân' : 'Ar-Rahman',
        meaning: 'Merciful',
        tefekkur: 'Reflect on mercy.',
        practice: 'Show mercy.',
      ),
      NameEntry(
        index: 2,
        arabic: 'ٱلرَّحِيمُ',
        name: lang == 'tr' ? 'Er-Rahîm' : 'Ar-Rahim',
        meaning: 'Compassionate',
        tefekkur: 'Ponder compassion.',
        practice: 'Be compassionate.',
      ),
    ];
  }
}

class _FakeStorageService extends StorageService {
  Set<int> _reviewed = <int>{};
  Map<String, dynamic> _streak = <String, dynamic>{};

  @override
  Future<Set<int>> getReviewedNames() async => _reviewed;

  @override
  Future<void> setReviewedNames(Set<int> indices) async {
    _reviewed = indices.toSet();
  }

  @override
  Future<Map<String, dynamic>> getStreakLog() async => _streak;

  @override
  Future<void> setStreakLog(Map<String, dynamic> log) async {
    _streak = Map<String, dynamic>.from(log);
  }

  @override
  Future<void> resetProgress() async {
    _reviewed.clear();
    _streak.clear();
  }
}

void main() {
  test('NamesProvider progress and streak integration', () async {
    final storage = _FakeStorageService();
    final dataService = _FakeDataService();
    final streakProvider = StreakProvider(storage);

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await storage.setStreakLog({
      'lastDate': StreakDateUtils.toDateString(yesterday),
      'streak': 2,
    });
    await streakProvider.load();

    final namesProvider = NamesProvider(dataService, storage, streakProvider);
    await namesProvider.load('en');

    expect(namesProvider.reviewedCount, 0);
    expect(namesProvider.completion, 0);

    await namesProvider.toggleReviewed(1);
    expect(namesProvider.reviewedCount, 1);
    expect(namesProvider.completion, closeTo(0.5, 0.001));
    expect(streakProvider.streak, 3);
  });
}
