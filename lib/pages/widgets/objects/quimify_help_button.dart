import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({Key? key, required this.dialog}) : super(key: key);

  final Widget dialog;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline, size: 26),
      color: Theme.of(context).colorScheme.primary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // To remove padding:
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => showQuimifyDialog(context: context, dialog: dialog),
    );
  }
}
