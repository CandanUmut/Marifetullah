import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/research_provider.dart';
import 'research_detail_page.dart';

class ResearchListPage extends StatelessWidget {
  const ResearchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final researchProvider = context.watch<ResearchProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(localeProvider.language == 'tr' ? 'Araştırma' : 'Research'),
      ),
      body: researchProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: researchProvider.sections.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final section = researchProvider.sections[index];
                return ListTile(
                  title: Text(section.title),
                  subtitle: Text(section.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ResearchDetailPage(section: section),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
