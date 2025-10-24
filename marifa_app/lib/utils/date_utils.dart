import 'package:intl/intl.dart';

/// Utility helpers for working with streak dates.
class StreakDateUtils {
  static final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  /// Returns a normalized string representation (local date) of [dateTime].
  static String toDateString(DateTime dateTime) {
    final local = dateTime.toLocal();
    final normalized = DateTime(local.year, local.month, local.day);
    return _formatter.format(normalized);
  }

  /// Returns true if [candidate] is exactly one day after [previous].
  static bool isNextDay(String previous, String candidate) {
    final prev = _formatter.parse(previous);
    final cand = _formatter.parse(candidate);
    final diff = cand.difference(prev).inDays;
    return diff == 1;
  }
}
