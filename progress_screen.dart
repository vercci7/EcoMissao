import 'package:flutter/material.dart';

import '../main.dart';
import '../services/mission_store.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.store});

  final MissionStore store;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final history = store.completedHistory;
        final medals = _medals();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            const Text(
              'Meu progresso',
              style: TextStyle(
                color: ecoDarkGreen,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Veja o quanto suas atitudes fazem a diferença.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    decoration: const BoxDecoration(
                      color: ecoPaleGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emoji_events, color: ecoGreen, size: 34),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    store.levelName,
                    style: const TextStyle(
                      color: ecoDarkGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Nível ${store.level}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${store.totalPoints}',
                    style: const TextStyle(
                      color: ecoGreen,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'PONTOS ACUMULADOS',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: store.levelProgress,
                      minHeight: 9,
                      backgroundColor: const Color(0xFFE8F0E9),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(ecoGreen),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    store.level == 5
                        ? 'Nível máximo alcançado!'
                        : 'Faltam ${store.nextLevelPoints - store.totalPoints} pontos para o próximo nível',
                    style: const TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.check_circle_outline,
                    value: '${store.completedCount}',
                    label: 'Concluídas',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    icon: Icons.pending_actions_outlined,
                    value: '${store.pendingCount}',
                    label: 'Pendentes',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    icon: Icons.calendar_month_outlined,
                    value: '${store.daysWithActivity}',
                    label: 'Dias ativos',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Color(0xFFE49A27),
                    size: 34,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${store.currentStreak} ${store.currentStreak == 1 ? 'dia seguido' : 'dias seguidos'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF79521A),
                          ),
                        ),
                        Text(
                          store.hasCompletedToday
                              ? 'Você já realizou uma missão hoje. Continue assim!'
                              : 'Conclua uma missão hoje para manter sua sequência.',
                          style: const TextStyle(
                            color: Color(0xFF8A7148),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Minhas medalhas',
              style: TextStyle(
                color: ecoDarkGreen,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 11),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.55,
              children: medals.map((medal) {
                return _MedalTile(
                  icon: medal.icon,
                  title: medal.title,
                  description: medal.description,
                  unlocked: medal.unlocked,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Histórico de missões',
              style: TextStyle(
                color: ecoDarkGreen,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            if (history.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Suas missões concluídas aparecerão aqui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              )
            else
              ...history.take(8).map(
                (mission) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: ecoGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          mission.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '+${mission.points}',
                        style: const TextStyle(
                          color: ecoGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<_Medal> _medals() {
    final completed = store.completedCount;
    final waterCount = store.missions
        .where((m) => m.isCompleted && m.category == 'Água')
        .length;
    final recyclingCount = store.missions
        .where((m) => m.isCompleted && m.category == 'Reciclagem')
        .length;

    return [
      _Medal(
        icon: Icons.spa,
        title: 'Primeiro passo',
        description: 'Concluir 1 missão',
        unlocked: completed >= 1,
      ),
      _Medal(
        icon: Icons.eco,
        title: 'Em evolução',
        description: 'Concluir 5 missões',
        unlocked: completed >= 5,
      ),
      _Medal(
        icon: Icons.emoji_events,
        title: 'Comprometido',
        description: 'Concluir 10 missões',
        unlocked: completed >= 10,
      ),
      _Medal(
        icon: Icons.water_drop,
        title: 'Guardião da água',
        description: '3 missões de água',
        unlocked: waterCount >= 3,
      ),
      _Medal(
        icon: Icons.recycling,
        title: 'Reciclador',
        description: '3 missões de reciclagem',
        unlocked: recyclingCount >= 3,
      ),
      _Medal(
        icon: Icons.local_fire_department,
        title: 'Constância',
        description: 'Sequência de 3 dias',
        unlocked: store.currentStreak >= 3,
      ),
    ];
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: ecoGreen, size: 21),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: ecoDarkGreen,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _MedalTile extends StatelessWidget {
  const _MedalTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFFEAF6EF) : const Color(0xFFF0F2F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: unlocked ? ecoGreen : Colors.black26,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: unlocked ? ecoDarkGreen : Colors.black45,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  unlocked ? 'Desbloqueada' : description,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle, size: 14, color: ecoGreen),
        ],
      ),
    );
  }
}

class _Medal {
  const _Medal({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;
}
