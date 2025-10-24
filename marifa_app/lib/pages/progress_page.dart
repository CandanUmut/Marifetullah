import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/names_provider.dart';
import '../providers/streak_provider.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final namesProvider = context.watch<NamesProvider>();
    final streakProvider = context.watch<StreakProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    final completion = namesProvider.completion;
    final reviewedCount = namesProvider.reviewedCount;
    final total = namesProvider.allNames.length;

    final percentText = '${(completion * 100).toStringAsFixed(0)}%';
    final progressLabel = localeProvider.language == 'tr' ? 'Tamamlanan İsimler' : 'Names Reviewed';
    final streakLabel = localeProvider.language == 'tr' ? 'Günlük Seri' : 'Daily Streak';

    return Scaffold(
      appBar: AppBar(
        title: Text(localeProvider.language == 'tr' ? 'İlerleme' : 'Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: completion,
                    strokeWidth: 12,
                    semanticsLabel: percentText,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  Text(percentText, style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('$progressLabel: $reviewedCount / $total'),
            const SizedBox(height: 16),
            Text('$streakLabel: ${streakProvider.streak}'),
            const Spacer(),
            Text(
              localeProvider.language == 'tr'
                  ? 'Günlük en az bir ismi düşünerek seriyi devam ettir.'
                  : 'Keep the streak by reflecting on at least one Name daily.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
