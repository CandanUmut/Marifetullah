import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/names_provider.dart';
import '../providers/research_provider.dart';
import '../providers/streak_provider.dart';
import 'names_list_page.dart';
import 'progress_page.dart';
import 'research_list_page.dart';
import 'settings_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  bool _localeListenerAttached = false;

  @override
  void initState() {
    super.initState();
    _pages = const [
      NamesListPage(),
      ResearchListPage(),
      ProgressPage(),
      SettingsPage(),
    ];

    final localeProvider = context.read<LocaleProvider>();
    final namesProvider = context.read<NamesProvider>();
    final researchProvider = context.read<ResearchProvider>();
    final streakProvider = context.read<StreakProvider>();

    localeProvider.loadLanguage().then((_) {
      final lang = localeProvider.language;
      namesProvider.load(lang);
      researchProvider.load(lang);
    });
    streakProvider.load();
  }

  void _onLanguageChanged(String lang) {
    final namesProvider = context.read<NamesProvider>();
    final researchProvider = context.read<ResearchProvider>();
    namesProvider.load(lang);
    researchProvider.load(lang);
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.book_outlined),
            selectedIcon: const Icon(Icons.book),
            label: localeProvider.language == 'tr' ? 'Esmâ' : 'Names',
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: localeProvider.language == 'tr' ? 'Araştırma' : 'Research',
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: localeProvider.language == 'tr' ? 'İlerleme' : 'Progress',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: localeProvider.language == 'tr' ? 'Ayarlar' : 'Settings',
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_localeListenerAttached) {
      context.read<LocaleProvider>().addListener(_handleLocaleChange);
      _localeListenerAttached = true;
    }
  }

  void _handleLocaleChange() {
    final localeProvider = context.read<LocaleProvider>();
    _onLanguageChanged(localeProvider.language);
  }

  @override
  void dispose() {
    if (_localeListenerAttached) {
      context.read<LocaleProvider>().removeListener(_handleLocaleChange);
    }
    super.dispose();
  }
}
