import 'package:cliente/widgets/help_button.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title})
      : horizontalPadding = 25,
        fontSize = 18,
        fontWeight = FontWeight.bold;

  const SectionTitle.custom({
    super.key,
    required this.title,
    required this.horizontalPadding,
    required this.fontSize,
    required this.fontWeight,
  });

  final String title;
  final double horizontalPadding;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          const Spacer(),
          const HelpButton(),
        ],
      ),
    );
  }
}
