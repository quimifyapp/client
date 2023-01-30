import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_thanks_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:flutter/material.dart';

class QuimifyReportDialog extends StatelessWidget {
  QuimifyReportDialog({
    Key? key,
    required this.label,
    required this.details,
  }) : super(key: key);

  final String label;
  final String? details;

  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  Future<void> show(BuildContext context) async =>
      await showQuimifyDialog(context: context, dialog: this);

  Future<void> _sendReport(String reportDetails) async =>
      await Api().sendReport(label: label, userMessage: reportDetails);

  void _exitWithThanks(String reportDetails, BuildContext context) {
    Navigator.of(context).pop();

    QuimifyThanksDialog(
      reportLabel: label,
      reportDetails: reportDetails,
    ).showIn(context);
  }

  void _submittedText(String text, BuildContext context) {
    _exitWithThanks(text, context);
    _sendReport(text);
  }

  void _pressedButton(BuildContext context) =>
      _submittedText(_textController.text, context);

  void _tapOutsideText() {
    _textFocusNode.unfocus(); // Hides keyboard

    if (isEmptyWithBlanks(_textController.text)) {
      _textController.clear(); // Clears input
    } else {
      _textController.text =
          noInitialAndFinalBlanks(_textController.text); // Clears input
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tapOutsideText,
      child: QuimifyDialog(
        title: 'Reportar error',
        content: [
          if (details != null && details!.isNotEmpty)
            Center(
              child: QuimifyDialogContentText(text: details!),
            ),
        ],
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
                focusNode: _textFocusNode,
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: (String text) => _submittedText(text, context),
              ),
            ),
          ),
          QuimifyDialogButton(
            onPressed: () => _pressedButton(context),
            text: 'Enviar',
          ),
        ],
      ),
    );
  }
}
