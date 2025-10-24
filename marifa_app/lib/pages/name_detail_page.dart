import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/name_entry.dart';
import '../providers/locale_provider.dart';
import '../providers/names_provider.dart';

class NameDetailPage extends StatelessWidget {
  const NameDetailPage({super.key, required this.entry});

  final NameEntry entry;

  @override
  Widget build(BuildContext context) {
    final namesProvider = context.watch<NamesProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final reviewed = namesProvider.isReviewed(entry.index);

    return Scaffold(
      appBar: AppBar(
        title: Text(localeProvider.language == 'tr' ? 'İsim Detayı' : 'Name Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  entry.arabic,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  entry.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                localeProvider.language == 'tr' ? 'Anlam' : 'Meaning',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(entry.meaning),
              const SizedBox(height: 16),
              Text(
                localeProvider.language == 'tr' ? 'Tefekkür' : 'Reflection',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(entry.tefekkur),
              const SizedBox(height: 16),
              Text(
                localeProvider.language == 'tr' ? 'Günlük Pratik' : 'Daily Practice',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(entry.practice),
              const SizedBox(height: 24),
              Center(
                child: FilledButton.icon(
                  onPressed: () {
                    namesProvider.toggleReviewed(entry.index);
                  },
                  icon: Icon(reviewed ? Icons.check_circle : Icons.circle_outlined),
                  label: Text(reviewed
                      ? (localeProvider.language == 'tr' ? 'İşaretlendi' : 'Marked Reviewed')
                      : (localeProvider.language == 'tr' ? 'İşaretle' : 'Mark Reviewed')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
