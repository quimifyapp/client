import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/text.dart';

class GroupButton extends StatelessWidget {
  const GroupButton({
    Key? key,
    required this.bonds,
    required this.structure,
    required this.name,
    required this.onPressed,
  }) : super(key: key);

  final int bonds;
  final String structure, name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      height: 60,
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              bonds == 1
                  ? 'assets/images/icons/single-bond.png'
                  : bonds == 2
                      ? 'assets/images/icons/double-bond.png'
                      : 'assets/images/icons/triple-bond.png',
              color: Theme.of(context).colorScheme.primary,
              width: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: AutoSizeText(
              formatStructureInput(structure),
              maxLines: 1,
              maxFontSize: 16,
              minFontSize: 8,
              stepGranularity: 0.1,
              style: const TextStyle(
                letterSpacing: 1,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              color: quimifyTeal,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.add,
            color: quimifyTeal,
            size: 22,
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
