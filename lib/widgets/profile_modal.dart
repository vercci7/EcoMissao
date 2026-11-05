import 'package:flutter/material.dart';

import '../services/profile_store.dart';
import '../services/mission_store.dart';
import 'animated_avatar.dart';

class ProfileModal extends StatefulWidget {
  const ProfileModal({
    super.key,
    required this.profile,
    required this.missionStore,
  });

  final ProfileStore profile;
  final MissionStore missionStore;

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  late final TextEditingController nameController;
  late String selectedAvatar;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    selectedAvatar = widget.profile.avatar;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    await widget.profile.save(
      newName: nameController.text,
      newAvatar: selectedAvatar,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.missionStore;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          22, 18, 22, MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Meu perfil 🌱',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  AnimatedAvatar(avatar: selectedAvatar, size: 100),
                  const SizedBox(height: 10),
                  Text(
                    'Seu personagem',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Escolha seu avatar',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AnimatedAvatar.avatars.map((avatar) {
                final selected = selectedAvatar == avatar;

                return GestureDetector(
                  onTap: () => setState(() => selectedAvatar = avatar),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.withValues(alpha: 0.25),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Text(avatar, style: const TextStyle(fontSize: 31)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              maxLength: 25,
              decoration: const InputDecoration(
                labelText: 'Seu nome',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sua jornada',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatCard(
                  icon: Icons.star_rounded,
                  label: 'Pontos',
                  value: '${store.totalPoints}',
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Sequência',
                  value: '${store.currentStreak} dias',
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.emoji_events_rounded,
                  label: 'Nível',
                  value: '${store.level}',
                ),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.check),
                label: const Text('Salvar perfil'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
