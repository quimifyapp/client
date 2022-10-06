import 'package:flutter/material.dart';

Future<void> showQuimifyDialog(Widget widget, bool closable, context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: closable,
    barrierColor: Theme.of(context).colorScheme.shadow,
    anchorPoint: const Offset(0, 0),
    // Centered
    builder: (BuildContext context) {
      return widget;
    },
  );
}

class QuimifyDialog extends StatelessWidget {
  const QuimifyDialog({
    super.key,
    required this.title,
    required this.content,
    required this.action,
  });

  final String title;
  final Widget? content;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(25),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titlePadding: EdgeInsets.zero,
      title: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 15, right: 15),
                onPressed: () => Navigator.of(context).pop(),
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
        bottom: 20,
        left: 25,
        right: 25,
      ),
      content: content,
      actionsPadding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
      actions: [
        action,
      ],
    );
  }
}
