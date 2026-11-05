import 'package:flutter/material.dart';

import 'models/mission.dart';
import 'screens/home_screen.dart';
import 'screens/progress_screen.dart';
import 'services/mission_store.dart';

const Color ecoGreen = Color(0xFF218653);
const Color ecoDarkGreen = Color(0xFF145C3A);
const Color ecoPaleGreen = Color(0xFFEAF6EF);
const Color ecoBackground = Color(0xFFF7FAF7);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregamos os dados antes de abrir a interface para evitar mostrar
  // uma lista vazia enquanto as informações salvas ainda estão sendo lidas.
  final store = MissionStore();
  await store.load();

  runApp(EcoMissaoApp(store: store));
}

class EcoMissaoApp extends StatelessWidget {
  const EcoMissaoApp({super.key, required this.store});

  final MissionStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoMissão',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ecoBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ecoGreen,
          primary: ecoGreen,
          secondary: const Color(0xFF8CCB9F),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ecoBackground,
          foregroundColor: ecoDarkGreen,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF3F7F3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: MainShell(store: store),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.store});

  final MissionStore store;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // A navegação inferior alterna entre as duas únicas telas do aplicativo.
    final pages = [
      HomeScreen(store: widget.store),
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
