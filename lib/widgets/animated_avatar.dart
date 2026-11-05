import 'package:flutter/material.dart';

class AnimatedAvatar extends StatelessWidget {
  const AnimatedAvatar({
    super.key,
    required this.avatar,
    this.size = 64,
  });

  final String avatar;
  final double size;

  static const List<String> avatars = [
    '🐼', '🦊', '🐸', '🐢',
    '🐻', '🐰', '🦁', '🐨',
  ];

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Text(
              avatar,
              style: TextStyle(fontSize: size * 0.53),
            ),
          ),
        );
      },
    );
  }
}
