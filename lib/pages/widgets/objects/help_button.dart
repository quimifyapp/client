import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({
    Key? key,
    required this.dialog,
  }) : super(key: key);

  final Widget dialog;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: QuimifyColors.primary(context),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // To remove padding:
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => showQuimifyDialog(context: context, dialog: dialog),
      icon: const Icon(Icons.help_outline, size: 26),
    );
  }
}
