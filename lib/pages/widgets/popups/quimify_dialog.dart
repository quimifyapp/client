import 'dart:math';

import 'package:flutter/material.dart';

Future<void> showQuimifyDialog({
  required BuildContext context,
  required Widget dialog,
  bool closable = true,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: closable,
    barrierColor: Theme.of(context).colorScheme.shadow,
    anchorPoint: const Offset(0, 0),
    builder: (BuildContext context) => dialog,
  );
}

class QuimifyDialog extends StatelessWidget {
  const QuimifyDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 400;
    final double shortestSide = MediaQuery.of(context).size.width;
    final double padding = max(25, (shortestSide - maxWidth) / 2);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      titlePadding: EdgeInsets.zero,
      title: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 15, right: 15),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 17,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 22,
                height: 0.6),
          )
        ],
      ),
      contentPadding: const EdgeInsets.only(
        top: 20,
        left: 25,
        right: 25,
      ),
      content: content,
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
