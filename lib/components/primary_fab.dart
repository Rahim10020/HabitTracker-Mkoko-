import 'package:flutter/material.dart';

class PrimaryFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const PrimaryFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      onPressed: onPressed,
      child: const Icon(Icons.add_rounded, color: Colors.white),
    );
  }
}
