import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../models/mission.dart';
import '../services/mission_store.dart';
import '../widgets/mission_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final MissionStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = 'Todas';

  List<Mission> _filteredMissions() {
    final missions = widget.store.missions;
    switch (selectedFilter) {
      case 'Pendentes':
        return missions.where((mission) => !mission.isCompleted).toList();
      case 'Concluídas':
        return missions.where((mission) => mission.isCompleted).toList();
      default:
        return missions;
    }
  }

  Future<void> _openEcoDrop() async {
    final uri = Uri.parse('https://eco-drop01.netlify.app/');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o Eco Drop. Tente novamente.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showAddMissionDialog() async {
    final titleController = TextEditingController();
    final pointsController = TextEditingController(text: '20');
    String category = 'Água';
    String? error;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nova missão'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      maxLength: 55,
                      decoration: const InputDecoration(
                        labelText: 'Nome da missão',
                        hintText: 'Ex.: Levar minha garrafa reutilizável',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      items: const [
                        'Água',
                        'Energia',
                        'Reciclagem',
                        'Alimentação',
                        'Consumo',
                        'Outra',
                      ].map((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => category = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pointsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Pontos (5 a 100)',
                      ),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        error!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final points = int.tryParse(pointsController.text.trim());

                    if (title.isEmpty) {
                      setDialogState(() => error = 'Digite o nome da missão.');
                      return;
                    }
                    if (points == null || points < 5 || points > 100) {
                      setDialogState(
                        () => error = 'Informe uma pontuação entre 5 e 100.',
                      );
                      return;
                    }

                    await widget.store.addMission(
                      title: title,
                      category: category,
                      points: points,
                    );
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    pointsController.dispose();
  }

  Future<void> _confirmRemove(Mission mission) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover missão?'),
        content: Text('Deseja remover "${mission.title}" da sua lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.store.removeMission(mission.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final missions = _filteredMissions();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: ecoPaleGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.eco, color: ecoGreen, size: 25),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EcoMissão',
                      style: TextStyle(
                        color: ecoDarkGreen,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Pequenas atitudes, grandes mudanças.',
                      style: TextStyle(color: Colors.black54, fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.wb_sunny_outlined, color: ecoGreen),
              ],
            ),
            const SizedBox(height: 22),
            _SummaryCard(store: widget.store),
            const SizedBox(height: 14),
            _EcoDropButton(onPressed: _openEcoDrop),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Suas missões',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: ecoDarkGreen,
                  ),
                ),
                Text(
                  '${widget.store.pendingCount} pendentes',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Todas', 'Pendentes', 'Concluídas'].map((filter) {
                final selected = selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: selected,
                  onSelected: (_) => setState(() => selectedFilter = filter),
                  selectedColor: const Color(0xFFDCEFE1),
                  labelStyle: TextStyle(
                    color: selected ? ecoDarkGreen : Colors.black54,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            if (missions.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.spa_outlined, size: 38, color: ecoGreen),
                    SizedBox(height: 8),
                    Text(
                      'Nenhuma missão por aqui.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Adicione uma missão ou escolha outro filtro.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ...missions.map(
                (mission) => MissionCard(
                  mission: mission,
                  onComplete: () async {
                    await widget.store.completeMission(mission.id);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('+${mission.points} pontos! Missão concluída.'),
                        backgroundColor: ecoDarkGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onRemove: () => _confirmRemove(mission),
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _showAddMissionDialog,
              icon: const Icon(Icons.add),
              label: const Text('Criar missão personalizada'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ecoGreen,
                side: const BorderSide(color: Color(0xFFB8D8C2)),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Dica: escolha pequenas atitudes que você consiga manter no dia a dia.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45, fontSize: 11),
            ),
          ],
        );
      },
    );
  }
}

class _EcoDropButton extends StatelessWidget {
  const _EcoDropButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE4F4E9),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: ecoGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.sports_esports_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jogar Eco Drop',
                      style: TextStyle(
                        color: ecoDarkGreen,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Aprenda a reciclar enquanto joga',
                      style: TextStyle(color: Colors.black54, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new_rounded, color: ecoDarkGreen),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.store});

  final MissionStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF258B58), Color(0xFF145C3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Sua jornada sustentável',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              const Icon(Icons.local_fire_department, color: Color(0xFFFFD27D)),
              Text(
                '${store.currentStreak} dias',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${store.totalPoints} pontos',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Nível ${store.level} • ${store.levelName}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: store.levelProgress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA9E4B9)),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            store.level == 5
                ? 'Você alcançou o nível máximo!'
                : '${store.nextLevelPoints - store.totalPoints} pontos para o próximo nível',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
