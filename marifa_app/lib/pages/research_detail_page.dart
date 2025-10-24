import 'package:flutter/material.dart';

import '../models/research_section.dart';

class ResearchDetailPage extends StatelessWidget {
  const ResearchDetailPage({super.key, required this.section});

  final ResearchSection section;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(section.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(section.summary, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            ...section.bullets.map(
              (bullet) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(bullet)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
