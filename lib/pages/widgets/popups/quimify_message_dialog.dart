import 'package:cliente/pages/widgets/objects/quimify_icon_button.dart';
import 'package:cliente/pages/widgets/popups/quimify_dialog.dart';
import 'package:cliente/pages/widgets/objects/quimify_button.dart';
import 'package:cliente/pages/widgets/appearance/quimify_gradient.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuimifyMessageDialog extends StatelessWidget {
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

  void _exit(BuildContext context) => Navigator.of(context).pop();

  void _openLink(BuildContext context) {
    launchUrl(
      Uri.parse(link!),
      mode: LaunchMode.externalApplication,
    );

    if (closable) {
      _exit(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(closable),
      child: QuimifyDialog(
        title: title,
        content: (details != null && details!.isNotEmpty)
            ? Text(
                details!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                strutStyle: const StrutStyle(height: 1.5),
              )
            : null,
        action: _hasLink
            ? QuimifyButton.gradient(
                height: 50,
                gradient: quimifyGradient,
                child: Text(
                  linkName!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => _openLink(context),
              )
            : Row(
                children: [
                  if (_hasReportButton)
                    Row(
                      children: [
                        QuimifyIconButton.square(
                          height: 50,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          onPressed: () {},
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
                      child: Text(
                        'Entendido',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () => _exit(context),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
