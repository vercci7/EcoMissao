import 'package:flutter/material.dart';
import '../services/mission_store.dart';

class ProgressScreen extends StatelessWidget {
  final MissionStore store;

  const ProgressScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Progresso')),
          body: Center(
            child: Text(
              'Pontos Totais: ${store.totalPoints}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
