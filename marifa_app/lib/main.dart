import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_shell.dart';
import 'providers/locale_provider.dart';
import 'providers/names_provider.dart';
import 'providers/research_provider.dart';
import 'providers/streak_provider.dart';
import 'services/data_service.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MarifaApp());
}

class MarifaApp extends StatelessWidget {
  const MarifaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => StorageService()),
        Provider(create: (_) => DataService()),
        ChangeNotifierProvider(
          create: (context) => StreakProvider(context.read<StorageService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => LocaleProvider(context.read<StorageService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => NamesProvider(
            context.read<DataService>(),
            context.read<StorageService>(),
            context.read<StreakProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ResearchProvider(context.read<DataService>()),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'Marifa App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: ThemeMode.system,
            supportedLocales: const [Locale('en'), Locale('tr')],
            locale: Locale(localeProvider.language),
            home: const HomeShell(),
          );
        },
      ),
    );
  }
}
