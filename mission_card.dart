import 'package:flutter/material.dart';

import '../main.dart';
import '../models/mission.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({
    super.key,
    required this.mission,
    required this.onComplete,
    required this.onRemove,
  });

  final Mission mission;
  final VoidCallback onComplete;
  final VoidCallback onRemove;

  IconData get categoryIcon {
    switch (mission.category) {
      case 'Água':
        return Icons.water_drop_outlined;
      case 'Energia':
        return Icons.bolt_outlined;
      case 'Reciclagem':
        return Icons.recycling;
      case 'Alimentação':
        return Icons.restaurant_outlined;
      case 'Consumo':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.eco_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = mission.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: completed ? const Color(0xFFD7EBDD) : const Color(0xFFE9EFEA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: completed ? ecoPaleGreen : const Color(0xFFF1F7F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(categoryIcon, color: ecoGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: completed ? Colors.black54 : const Color(0xFF20372A),
                    decoration:
                        completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${mission.category}  •  ${mission.points} pontos',
                  style: const TextStyle(
                    color: Color(0xFF718078),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          if (completed)
            const Icon(Icons.check_circle, color: ecoGreen)
          else
            IconButton(
              tooltip: 'Concluir missão',
              onPressed: onComplete,
              icon: const Icon(Icons.check_circle_outline, color: ecoGreen),
            ),
          PopupMenuButton<String>(
            tooltip: 'Opções',
            onSelected: (value) {
              if (value == 'remove') onRemove();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Remover missão'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
