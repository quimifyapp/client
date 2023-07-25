import 'dart:math';

import 'package:flutter/material.dart';

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
    const double maxWidth = 400;
    final double shortestSide = MediaQuery.of(context).size.width;
    final double padding = max(20, (shortestSide - maxWidth) / 2);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      titlePadding: EdgeInsets.zero,
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
          )
        ],
      ),
      contentPadding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      content: SingleChildScrollView(
        child: Wrap(
          runSpacing: 15,
          children: content,
        ),
      ),
      actionsPadding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 15,
        right: 15,
      ),
      actions: actions,
    );
  }
}
