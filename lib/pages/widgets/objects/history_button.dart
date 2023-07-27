import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_page.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({
    Key? key,
    this.width,
    required this.height,
    this.iconSize = 24,
    required this.historyPageBuilder,
  }) : super(key: key);

  final double? width;
  final double height;
  final double iconSize;
  final HistoryPage Function() historyPageBuilder;

  @override
  Widget build(BuildContext context) {
    return QuimifyIconButton.square(
      height: height,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => historyPageBuilder(),
        ),
      ),
      icon: Icon(
        Icons.history,
        color: Theme.of(context).colorScheme.primary,
        size: iconSize,
      ),
    );
  }
}
