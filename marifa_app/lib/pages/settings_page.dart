import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/resource_link.dart';
import '../providers/locale_provider.dart';
import '../providers/names_provider.dart';
import '../providers/streak_provider.dart';
import '../services/resource_service.dart';
import '../services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<List<ResourceLink>> _resourcesFuture;

  @override
  void initState() {
    super.initState();
    _resourcesFuture = ResourceService().loadResources();
  }

  Future<void> _resetProgress(BuildContext context) async {
    final localeProvider = context.read<LocaleProvider>();
    final namesProvider = context.read<NamesProvider>();
    final streakProvider = context.read<StreakProvider>();
    final storageService = context.read<StorageService>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(localeProvider.language == 'tr' ? 'Sıfırlama' : 'Reset Progress'),
          content: Text(
            localeProvider.language == 'tr'
                ? 'İlerleme ve seri bilgileri sıfırlansın mı?'
                : 'Do you want to reset your reviewed names and streak?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(localeProvider.language == 'tr' ? 'İptal' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(localeProvider.language == 'tr' ? 'Sıfırla' : 'Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await storageService.resetProgress();
      await namesProvider.resetProgress();
      await streakProvider.reset();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localeProvider.language == 'tr'
                ? 'İlerleme sıfırlandı.'
                : 'Progress has been reset.'),
          ),
        );
      }
    }
  }

  Future<void> _launchResource(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final language = localeProvider.language;

    return Scaffold(
      appBar: AppBar(
        title: Text(language == 'tr' ? 'Ayarlar' : 'Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(language == 'tr' ? 'Dil' : 'Language'),
            subtitle: Text(language == 'tr' ? 'Uygulama dilini seçin.' : 'Choose the app language.'),
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: language,
            onChanged: (value) {
              if (value != null) localeProvider.setLanguage(value);
            },
            title: const Text('English'),
          ),
          RadioListTile<String>(
            value: 'tr',
            groupValue: language,
            onChanged: (value) {
              if (value != null) localeProvider.setLanguage(value);
            },
            title: const Text('Türkçe'),
          ),
          const Divider(),
          ListTile(
            title: Text(language == 'tr' ? 'İlerlemeyi Sıfırla' : 'Reset Progress'),
            subtitle: Text(language == 'tr'
                ? 'İşaretli isimler ve seri bilgisi temizlenir.'
                : 'Clears reviewed names and streak info.'),
            trailing: const Icon(Icons.refresh),
            onTap: () => _resetProgress(context),
          ),
          const Divider(),
          ListTile(
            title: Text(language == 'tr' ? 'Kaynaklar' : 'Resources'),
            subtitle: Text(language == 'tr'
                ? 'PDF ve ek çalışma bağlantıları'
                : 'PDFs and supplementary readings'),
          ),
          FutureBuilder<List<ResourceLink>>(
            future: _resourcesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(language == 'tr'
                      ? 'Kaynak bulunamadı.'
                      : 'No resources available.'),
                );
              }
              return Column(
                children: snapshot.data!
                    .map(
                      (resource) => ListTile(
                        title: Text(language == 'tr' ? resource.titleTr : resource.titleEn),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => _launchResource(resource.url),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
