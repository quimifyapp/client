import 'package:cliente/api/api.dart';
import 'package:cliente/pages/widgets/objects/quimify_icon_button.dart';
import 'package:cliente/pages/widgets/popups/quimify_dialog.dart';
import 'package:cliente/pages/widgets/objects/quimify_button.dart';
import 'package:cliente/pages/widgets/appearance/quimify_gradient.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuimifyMessageDialog extends StatefulWidget {
  const QuimifyMessageDialog({
    super.key,
    required this.title,
    this.details,
    this.closable = true,
  })  : linkName = null,
        link = null,
        reportLabel = null,
        _hasLink = false,
        _hasReportButton = false;

  const QuimifyMessageDialog.link({
    super.key,
    required this.title,
    this.details,
    required this.linkName,
    required this.link,
    this.closable = true,
  })  : reportLabel = null,
        _hasLink = true,
        _hasReportButton = false;

  const QuimifyMessageDialog.report({
    super.key,
    required this.title,
    this.details,
    required this.reportLabel,
  })  : linkName = null,
        link = null,
        closable = true,
        _hasLink = false,
        _hasReportButton = true;

  const QuimifyMessageDialog.locked({super.key})
      : title = 'Falta muy poco',
        details = 'Esta función pronto estará lista.',
        reportLabel = null,
        closable = true,
        linkName = null,
        link = null,
        _hasLink = false,
        _hasReportButton = false;

  final String title;
  final String? details;
  final String? linkName, link, reportLabel;
  final bool closable;

  final bool _hasLink, _hasReportButton;

  Future<void> show(BuildContext context) async =>
      await showQuimifyDialog(this, closable, context);

  @override
  State<QuimifyMessageDialog> createState() => _QuimifyMessageDialogState();
}

class _QuimifyMessageDialogState extends State<QuimifyMessageDialog> {
  late TextEditingController _textController;
  late bool _reportButtonPressed;

  @override
  void initState() {
    _textController = TextEditingController();
    _reportButtonPressed = false;
    super.initState();
  }

  void _exit(BuildContext context) => Navigator.of(context).pop();

  void _openLink(BuildContext context) {
    launchUrl(
      Uri.parse(widget.link!),
      mode: LaunchMode.externalApplication,
    );

    if (widget.closable) {
      _exit(context);
    }
  }

  Future<void> _report(String details) async {
    await Api().sendReport(label: widget.reportLabel!, details: details);
  }

  void _exitWithThanks() {
    _exit(context);
    const QuimifyMessageDialog(
      title: 'Muchas gracias',
      details: 'Con tu ayuda podremos mejorar.',
    ).show(context);
  }

  void _onPressed() {
    if (widget._hasLink) {
      _openLink(context);
      _exit(context);
    } else if (_reportButtonPressed) {
      _report(_textController.text);
      _exitWithThanks();
    } else {
      _exit(context);
    }
  }

  void _onSubmitted(String text) {
    _report(text);
    _exitWithThanks();
  }

  void _reportButton() {
    setState(() => _reportButtonPressed = true);
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;

    if (widget.details != null && widget.details!.isNotEmpty) {
      content = Text(
        widget.details!,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
        ),
        strutStyle: const StrutStyle(height: 1.5),
      );
    }

    return WillPopScope(
      onWillPop: () => Future.value(widget.closable),
      child: QuimifyDialog(
        title: _reportButtonPressed ? 'Reportar error' : widget.title,
        content: content,
        actions: [
          if (_reportButtonPressed)
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
                  onSubmitted: _onSubmitted,
                ),
              ),
            ),
          Row(
            children: [
              if (widget._hasReportButton && !_reportButtonPressed)
                Row(
                  children: [
                    QuimifyIconButton.square(
                      height: 50,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      onPressed: _reportButton,
                      icon: Image.asset(
                        'assets/images/icons/report.png',
                        width: 20,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              Expanded(
                child: QuimifyButton.gradient(
                  height: 50,
                  gradient: quimifyGradient,
                  onPressed: _onPressed,
                  child: Text(
                    widget._hasLink
                        ? widget.linkName!
                        : _reportButtonPressed
                            ? 'Enviar'
                            : 'Entendido',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
