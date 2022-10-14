import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/utils/text.dart';

class FunctionalGroupButton extends StatelessWidget {
  const FunctionalGroupButton(
      {Key? key,
        required this.bonds,
        required this.text,
        required this.actionText,
        this.altText,
        required this.onPressed})
      : super(key: key);

  final int bonds;
  final String text, actionText;
  final String? altText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      height: 60,
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
          Text(
            formatStructureInput(text),
            style: const TextStyle(
              letterSpacing: 1,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            actionText,
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
