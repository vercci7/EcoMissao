import 'package:flutter/foundation.dart';

class Mission {
  final String id;
  final String title;
  final String description;
  final int points;
  bool isCompleted;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.isCompleted = false,
  });
}

class MissionStore extends ChangeNotifier {
  final List<Mission> _missions = [
    Mission(
      id: '1',
      title: 'Separar o lixo reciclável',
      description: 'Separe papéis, plásticos e metais do lixo orgânico.',
      points: 50,
    ),
    Mission(
      id: '2',
      title: 'Reduzir o tempo no banho',
      description: 'Tome um banho de no máximo 5 minutos para economizar água.',
      points: 30,
    ),
    Mission(
      id: '3',
      title: 'Desligar luzes desnecessárias',
      description: 'Apague as luzes dos cômodos que não estiver usando.',
      points: 20,
    ),
  ];

  List<Mission> get missions => List.unmodifiable(_missions);

  int get totalPoints => _missions
      .where((m) => m.isCompleted)
      .fold(0, (sum, m) => sum + m.points);

  int get completedCount => _missions.where((m) => m.isCompleted).length;

  Future<void> load() async {
    // Método de carregamento exigido pelo main.dart
    notifyListeners();
  }

  void toggleMission(String id) {
    final index = _missions.indexWhere((m) => m.id == id);
    if (index != -1) {
      _missions[index].isCompleted = !_missions[index].isCompleted;
      notifyListeners();
    }
  }
}
