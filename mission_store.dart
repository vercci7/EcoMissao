import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mission.dart';

class MissionStore extends ChangeNotifier {
  static const String _missionsKey = 'ecomissao_missions_v1';
  static const String _datesKey = 'ecomissao_completed_dates_v1';

  final List<Mission> _missions = [];
  final Set<String> _completedDates = {};

  List<Mission> get missions => List.unmodifiable(_missions);

  int get totalPoints => _missions
      .where((mission) => mission.isCompleted)
      .fold(0, (total, mission) => total + mission.points);

  int get completedCount =>
      _missions.where((mission) => mission.isCompleted).length;

  int get pendingCount =>
      _missions.where((mission) => !mission.isCompleted).length;

  int get totalCount => _missions.length;

  int get completedTodayCount {
    final today = _dateKey(DateTime.now());
    return _missions
        .where((mission) =>
            mission.isCompleted &&
            mission.completedAt != null &&
            _dateKey(mission.completedAt!) == today)
        .length;
  }

  int get currentStreak {
    if (_completedDates.isEmpty) return 0;

    final today = _dateKey(DateTime.now());
    final yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));

    // Se ainda não houve missão hoje, a sequência continua válida até ontem.
    DateTime cursor;
    if (_completedDates.contains(today)) {
      cursor = DateTime.now();
    } else if (_completedDates.contains(yesterday)) {
      cursor = DateTime.now().subtract(const Duration(days: 1));
    } else {
      return 0;
    }

    var streak = 0;
    while (_completedDates.contains(_dateKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int get level {
    if (totalPoints >= 1000) return 5;
    if (totalPoints >= 600) return 4;
    if (totalPoints >= 300) return 3;
    if (totalPoints >= 100) return 2;
    return 1;
  }

  String get levelName {
    switch (level) {
      case 5:
        return 'Mestre Sustentável';
      case 4:
        return 'Guardião Verde';
      case 3:
        return 'Protetor Ambiental';
      case 2:
        return 'Amigo da Natureza';
      default:
        return 'Iniciante Verde';
    }
  }

  int get nextLevelPoints {
    switch (level) {
      case 1:
        return 100;
      case 2:
        return 300;
      case 3:
        return 600;
      case 4:
        return 1000;
      default:
        return 1000;
    }
  }

  int get currentLevelBase {
    switch (level) {
      case 2:
        return 100;
      case 3:
        return 300;
      case 4:
        return 600;
      case 5:
        return 1000;
      default:
        return 0;
    }
  }

  double get levelProgress {
    if (level == 5) return 1;
    final range = nextLevelPoints - currentLevelBase;
    return ((totalPoints - currentLevelBase) / range).clamp(0.0, 1.0).toDouble();
  }

  int get daysWithActivity => _completedDates.length;

  bool get hasCompletedToday =>
      _completedDates.contains(_dateKey(DateTime.now()));

  List<Mission> get completedHistory {
    final result = _missions.where((m) => m.isCompleted).toList();
    result.sort((a, b) =>
        (b.completedAt ?? b.createdAt).compareTo(a.completedAt ?? a.createdAt));
    return result;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMissions = prefs.getString(_missionsKey);
    final savedDates = prefs.getStringList(_datesKey);

    if (savedMissions == null) {
      _missions.addAll(_starterMissions());
      await _save();
    } else {
      try {
        final decoded = jsonDecode(savedMissions) as List<dynamic>;
        _missions
          ..clear()
          ..addAll(decoded.map(
            (item) => Mission.fromJson(item as Map<String, dynamic>),
          ));
      } catch (_) {
        // Se o conteúdo salvo estiver inválido, iniciamos com missões padrão.
        _missions
          ..clear()
          ..addAll(_starterMissions());
        await _save();
      }
    }

    _completedDates
      ..clear()
      ..addAll(savedDates ?? []);
    notifyListeners();
  }

  Future<void> addMission({
    required String title,
    required String category,
    required int points,
  }) async {
    final mission = Mission(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      category: category,
      points: points,
      createdAt: DateTime.now(),
      isCustom: true,
    );
    _missions.insert(0, mission);
    await _saveAndNotify();
  }

  Future<void> completeMission(String id) async {
    final index = _missions.indexWhere((mission) => mission.id == id);
    if (index == -1 || _missions[index].isCompleted) return;

    final now = DateTime.now();
    _missions[index] = _missions[index].copyWith(
      isCompleted: true,
      completedAt: now,
    );
    _completedDates.add(_dateKey(now));
    await _saveAndNotify();
  }

  Future<void> removeMission(String id) async {
    _missions.removeWhere((mission) => mission.id == id);
    await _saveAndNotify();
  }

  Future<void> _saveAndNotify() async {
    await _save();
    notifyListeners();
  }

  // Aqui transformamos as missões em JSON e gravamos no armazenamento local.
  // Assim, a lista não desaparece quando o aplicativo é fechado.
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_missions.map((mission) => mission.toJson()).toList());
    await prefs.setString(_missionsKey, encoded);
    await prefs.setStringList(_datesKey, _completedDates.toList());
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  List<Mission> _starterMissions() {
    final now = DateTime.now();
    return [
      Mission(
        id: 'starter_water',
        title: 'Tomar um banho mais curto',
        category: 'Água',
        points: 20,
        createdAt: now,
      ),
      Mission(
        id: 'starter_recycle',
        title: 'Separar o lixo reciclável',
        category: 'Reciclagem',
        points: 30,
        createdAt: now,
      ),
      Mission(
        id: 'starter_energy',
        title: 'Apagar luzes desnecessárias',
        category: 'Energia',
        points: 15,
        createdAt: now,
      ),
      Mission(
        id: 'starter_plastic',
        title: 'Evitar copos descartáveis',
        category: 'Consumo',
        points: 20,
        createdAt: now,
      ),
      Mission(
        id: 'starter_food',
        title: 'Reaproveitar um alimento',
        category: 'Alimentação',
        points: 25,
        createdAt: now,
      ),
    ];
  }
}
