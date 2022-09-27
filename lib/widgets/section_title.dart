import 'package:cliente/widgets/help_button.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title})
      : fontWeight = FontWeight.bold;

  const SectionTitle.custom(
      {Key? key, required this.title, required this.fontWeight})
      : super(key: key);

  final String title;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
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
