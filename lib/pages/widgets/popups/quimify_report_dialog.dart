import 'package:cliente/api/api.dart';
import 'package:cliente/pages/widgets/popups/quimify_dialog.dart';
import 'package:cliente/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:cliente/pages/widgets/popups/widgets/dialog_button.dart';
import 'package:cliente/pages/widgets/popups/widgets/dialog_content.dart';
import 'package:flutter/material.dart';

class QuimifyReportDialog extends StatelessWidget {
  QuimifyReportDialog({
    Key? key,
    required this.reportLabel,
    required this.details,
  }) : super(key: key);

  final String reportLabel, details;
  final TextEditingController _textController = TextEditingController();

  Future<void> show(BuildContext context) async =>
      await showQuimifyDialog(context: context, dialog: this);

  Future<void> _sendReport(String details) async =>
      await Api().sendReport(label: reportLabel, details: details);

  void _exitWithThanks(BuildContext context) {
    Navigator.of(context).pop();

    const QuimifyMessageDialog(
      title: 'Muchas gracias',
      details: 'Con tu ayuda podremos mejorar.',
    ).show(context);
  }

  void _report(String details, BuildContext context) {
    _exitWithThanks(context);
    _sendReport(details);
  }

  void _submittedText(String text, BuildContext context) =>
      _report(text, context);

  void _pressedButton(BuildContext context) =>
      _report(_textController.text, context);

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog( // TODO tap outside
      title: 'Reportar error',
      content: (details.isNotEmpty) ? DialogContent(text: details) : null,
      actions: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 15,
            left: 10,
            right: 10,
          ),
          child: Center(
            child: TextField(
              // Aspect:
              keyboardType: TextInputType.text,
              maxLines: 1,
              cursorColor: Theme.of(context).colorScheme.primary,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                // So vertical center works:
                isCollapsed: true,
                labelText: 'Detalles (opcional)',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                // So hint doesn't go up while typing:
                floatingLabelBehavior: FloatingLabelBehavior.never,
                // To remove bottom border:
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
              // Logic:
              controller: _textController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (String text) => _submittedText(text, context),
            ),
          ),
        ),
        DialogButton(
          onPressed: () => _pressedButton(context),
          text: 'Enviar',
        ),
      ],
    );
  }
}
