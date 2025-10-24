import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/name_entry.dart';
import '../providers/locale_provider.dart';
import '../providers/names_provider.dart';
import 'name_detail_page.dart';

class NamesListPage extends StatelessWidget {
  const NamesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final namesProvider = context.watch<NamesProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(localeProvider.language == 'tr' ? 'Esmâü’l-Hüsna' : 'Beautiful Names'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: namesProvider.updateSearch,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: localeProvider.language == 'tr'
                    ? 'İsim veya anlam ara'
                    : 'Search by name or meaning',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: namesProvider.loading
                ? const Center(child: CircularProgressIndicator())
                : _NamesGrid(names: namesProvider.names),
          ),
        ],
      ),
    );
  }
}

class _NamesGrid extends StatelessWidget {
  const _NamesGrid({required this.names});

  final List<NameEntry> names;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final crossAxisCount = isWide ? (constraints.maxWidth ~/ 250).clamp(2, 4) : 1;
        if (!isWide) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) => _NameCard(entry: names[index]),
          );
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 4 / 3,
          ),
          itemCount: names.length,
          itemBuilder: (context, index) => _NameCard(entry: names[index]),
        );
      },
    );
  }
}

class _NameCard extends StatelessWidget {
  const _NameCard({required this.entry});

  final NameEntry entry;

  @override
  Widget build(BuildContext context) {
    final namesProvider = context.read<NamesProvider>();
    final localeProvider = context.read<LocaleProvider>();
    final reviewed = namesProvider.isReviewed(entry.index);

    return Semantics(
      label: '${entry.name} ${entry.meaning}',
      button: true,
      child: Card(
        margin: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NameDetailPage(entry: entry),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.arabic,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Icon(
                      reviewed ? Icons.check_circle : Icons.circle_outlined,
                      color: reviewed ? Theme.of(context).colorScheme.primary : null,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  entry.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(entry.meaning, maxLines: 2, overflow: TextOverflow.ellipsis),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    localeProvider.language == 'tr' ? 'Detaylar' : 'Details',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
