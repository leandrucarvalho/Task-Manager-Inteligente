import 'package:flutter/material.dart';

SnackBar successSnackBar(BuildContext context, String message) {
  final scheme = Theme.of(context).colorScheme;

  return SnackBar(
    content: Row(
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutBack,
          tween: Tween(begin: 0.8, end: 1.0),
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          child: Icon(Icons.check_circle, color: scheme.surface),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(message)),
      ],
    ),
  );
}

