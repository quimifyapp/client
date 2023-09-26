import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

// TODO fix split screen not centered (test empty project)

showQuimifyDialog({
  required BuildContext context,
  required Widget dialog,
  bool closable = true,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: closable,
    barrierColor: Theme.of(context).colorScheme.shadow,
    builder: (BuildContext context) => dialog,
  );
}

class QuimifyDialog extends StatelessWidget {
  const QuimifyDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.closable = true,
  });

  final String title;
  final List<Widget> content;
  final List<Widget> actions;
  final bool closable;

  _closeButtonPressed(BuildContext context) {
    if (closable) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO use new responsive utils
    final double screenWidth = MediaQuery.of(context).size.width;

    const double padding = 20;
    const double contentPadding = 20;

    const double maxWidth = 400;
    const totalPadding = 2 * (padding + contentPadding);

    final double contentDesiredWidth = screenWidth - totalPadding;
    const double contentMaxWidth = maxWidth - totalPadding;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      titlePadding: const EdgeInsets.only(bottom: 20),
      title: Column(
        children: [
          if (closable)
            Row(
              children: [
                const Spacer(),
                IconButton(
                  padding: const EdgeInsets.only(
                    top: 15,
                    right: 15,
                  ),
                  alignment: Alignment.topRight,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => _closeButtonPressed(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 17,
                  ),
                ),
              ],
            ),
          if (!closable) const SizedBox(height: 35),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 22,
              height: 0.6,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.only(
        left: contentPadding,
        right: contentPadding,
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: contentMaxWidth,
          minWidth: min(contentDesiredWidth, contentMaxWidth), // I.E.: tablet
        ),
        child: SingleChildScrollView(
          child: SignedSpacingColumn(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(padding),
      actions: actions,
    );
  }
}
