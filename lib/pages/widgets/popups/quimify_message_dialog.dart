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
  late bool _reportButtonPressed;

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

  @override
  void initState() {
    _reportButtonPressed = false;
    super.initState();
  }

  void _reportButton() {
    setState(() => _reportButtonPressed = true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(widget.closable),
      child: QuimifyDialog(
        title: widget.title,
        content: (widget.details != null && widget.details!.isNotEmpty)
            ? Text(
          widget.details!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          strutStyle: const StrutStyle(height: 1.5),
        )
            : null,
        action: Row(
          children: [
            if (widget._hasReportButton)
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
                onPressed: widget._hasLink
                    ? () => _openLink(context)
                    : () => _exit(context),
                child: Text(
                  widget._hasLink ? widget.linkName! : 'Entendido',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
