import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/report/report_sent_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/text.dart';

class ReportDialog extends StatelessWidget {
  ReportDialog({
    Key? key,
    required this.details,
    required this.reportContext,
    required this.reportDetails,
  }) : super(key: key);

  final String? details;
  final String reportContext;
  final String reportDetails;

  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  show(BuildContext context) async =>
      await showQuimifyDialog(context: context, dialog: this);

  _sendReport(String? userMessage) async {
    Api().sendReportWithRetry(
      context: reportContext,
      details: reportDetails,
      userMessage: userMessage,
    );
  }

  _exitWithThanks(String userMessage, BuildContext context) {
    Navigator.of(context).pop();

    ReportSentDialog(
      userMessage: userMessage,
    ).show(context);
  }

  _submittedText(String text, BuildContext context) {
    _exitWithThanks(text, context);
    _sendReport(text);
  }

  _pressedButton(BuildContext context) =>
      _submittedText(_textController.text, context);

  _tappedOutsideText() {
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
      onTap: _tappedOutsideText,
      child: QuimifyDialog(
        title: 'Reportar error',
        content: [
          if (details != null && details!.isNotEmpty)
            Center(
              child: DialogContentText(richText: details!),
            ),
        ],
        actions: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: QuimifyColors.background(context),
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
                cursorColor: QuimifyColors.primary(context),
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  // So vertical center works:
                  isCollapsed: true,
                  labelText: 'Detalles (opcional)',
                  labelStyle: TextStyle(
                    color: QuimifyColors.secondary(context),
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
          DialogButton(
            onPressed: () => _pressedButton(context),
            text: 'Enviar',
          ),
        ],
      ),
    );
  }
}
