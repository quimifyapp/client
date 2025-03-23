import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  const SelectionButton({
    super.key,
    required this.title,
    required this.imageUr,
    this.onTap,
  });

  final String title;
  final String imageUr;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imageUr,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
