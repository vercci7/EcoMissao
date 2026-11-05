import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/progress_screen.dart';
import 'services/mission_store.dart';
import 'services/profile_store.dart';

const Color ecoGreen = Color(0xFF218653);
const Color ecoDarkGreen = Color(0xFF145C3A);
const Color ecoPaleGreen = Color(0xFFEAF6EF);
const Color ecoBackground = Color(0xFFF7FAF7);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = MissionStore();
  final profile = ProfileStore();

  await store.load();
  await profile.load();

  final prefs = await SharedPreferences.getInstance();
  final darkMode = prefs.getBool('eco_dark_mode') ?? false;

  runApp(EcoMissaoApp(
    store: store,
    profile: profile,
    initialDarkMode: darkMode,
  ));
}

class EcoMissaoApp extends StatefulWidget {
  const EcoMissaoApp({
    super.key,
    required this.store,
    required this.profile,
    required this.initialDarkMode,
  });

  final MissionStore store;
  final ProfileStore profile;
  final bool initialDarkMode;

  @override
  State<EcoMissaoApp> createState() => _EcoMissaoAppState();
}

class _EcoMissaoAppState extends State<EcoMissaoApp> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.initialDarkMode;
  }

  Future<void> toggleTheme() async {
    setState(() => isDark = !isDark);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('eco_dark_mode', isDark);
  }

  ThemeData buildTheme(bool dark) {
    final scheme = ColorScheme.fromSeed(
      seedColor: ecoGreen,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: dark ? const Color(0xFF79D6A1) : ecoGreen,
      secondary: const Color(0xFF8CCB9F),
      surface: dark ? const Color(0xFF1B2921) : Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          dark ? const Color(0xFF101A14) : ecoBackground,
      appBarTheme: AppBarTheme(
        backgroundColor:
            dark ? const Color(0xFF101A14) : ecoBackground,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: dark ? const Color(0xFF1B2921) : Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark
            ? const Color(0xFF26382D)
            : const Color(0xFFF3F7F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            dark ? const Color(0xFF1B2921) : Colors.white,
        indicatorColor: dark
            ? const Color(0xFF315D43)
            : const Color(0xFFDCEFE1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoMissão',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(false),
      darkTheme: buildTheme(true),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: MainShell(
        store: widget.store,
        profile: widget.profile,
        isDark: isDark,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.store,
    required this.profile,
    required this.isDark,
    required this.onToggleTheme,
  });

  final MissionStore store;
  final ProfileStore profile;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        store: widget.store,
        profile: widget.profile,
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
      ),
      ProgressScreen(store: widget.store),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco),
            label: 'Missões',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Meu progresso',
          ),
        ],
      ),
    );
  }
}
