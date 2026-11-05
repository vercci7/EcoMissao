import 'package:flutter/material.dart';
import '../services/mission_store.dart';
import '../services/profile_store.dart';

class HomeScreen extends StatelessWidget {
  final MissionStore store;
  final ProfileStore? profile;
  final bool? isDark;
  final VoidCallback? onToggleTheme;

  const HomeScreen({
    super.key,
    required this.store,
    this.profile,
    this.isDark,
    this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Missões Ecológicas'),
            actions: [
              if (onToggleTheme != null)
                IconButton(
                  icon: Icon(
                    (isDark ?? false) ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: onToggleTheme,
                  tooltip: 'Alternar Tema',
                ),
            ],
          ),
          body: ListView.builder(
            itemCount: store.missions.length,
            itemBuilder: (context, index) {
              final mission = store.missions[index];
              return CheckboxListTile(
                title: Text(mission.title),
                subtitle: Text('${mission.description}\n+${mission.points} pts'),
                isThreeLine: true,
                value: mission.isCompleted,
                onChanged: (_) => store.toggleMission(mission.id),
              );
            },
          ),
        );
      },
    );
  }
}
