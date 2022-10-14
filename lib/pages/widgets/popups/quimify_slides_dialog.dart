import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';

class QuimifySlidesDialog extends StatefulWidget {
  const QuimifySlidesDialog({Key? key, required this.titleToContent}) : super(key: key);

  final Map<String, Widget> titleToContent;

  @override
  State<QuimifySlidesDialog> createState() => _QuimifySlidesDialogState();
}

class _QuimifySlidesDialogState extends State<QuimifySlidesDialog> {
  late int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: widget.titleToContent.keys.elementAt(_currentSlide),
      content: widget.titleToContent.values.elementAt(_currentSlide),
      actions: [
        _currentSlide == widget.titleToContent.length - 1
            ? QuimifyDialogButton(
                onPressed: () => Navigator.pop(context),
                text: 'Entendido',
              )
            : QuimifyDialogButton(
                onPressed: () => setState(() => _currentSlide++),
                text: 'Siguiente  ➔',
              ),
      ],
    );
  }
}
