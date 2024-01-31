import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/report/report_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/objects/report_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({
    super.key,
    required this.title,
    this.details,
    this.closable = true,
  })  : linkLabel = null,
        link = null,
        reportContext = null,
        reportDetails = null,
        _hasLink = false,
        _hasReportButton = false;

  const MessageDialog.linked({
    super.key,
    required this.title,
    this.details,
    required this.linkLabel,
    required this.link,
    this.closable = true,
  })  : reportContext = null,
        reportDetails = null,
        _hasLink = true,
        _hasReportButton = false;

  const MessageDialog.reportable({
    super.key,
    required this.title,
    required this.details,
    required this.reportContext,
    required this.reportDetails,
  })  : linkLabel = null,
        link = null,
        closable = true,
        _hasLink = false,
        _hasReportButton = true;

  final String title;
  final String? details;

  final String? linkLabel, link;
  final String? reportContext, reportDetails;

  final bool closable;

  final bool _hasLink, _hasReportButton;

  show(BuildContext context) =>
      showQuimifyDialog(context: context, closable: closable, dialog: this);

  _exit(BuildContext context) => Navigator.of(context).pop();

  _openLink(BuildContext context) =>
      launchUrl(Uri.parse(link!), mode: LaunchMode.externalApplication);

  _pressedButton(BuildContext context) {
    if (_hasLink) {
      _openLink(context);
    }

    if (closable) {
      _exit(context);
    }
  }

  _pressedReportButton(BuildContext context) {
    _exit(context);

    ReportDialog(
      details: details,
      reportContext: reportContext!,
      reportDetails: reportDetails!,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50;

    return PopScope(
      canPop: closable,
      child: QuimifyDialog(
        title: title,
        content: [
          if (details != null && details!.isNotEmpty)
            Center(
              child: DialogContentText(
                text: details!,
              ),
            ),
        ],
        actions: [
          Row(
            children: [
              if (_hasReportButton) ...[
                ReportButton(
                  height: buttonHeight,
                  size: 20,
                  onPressed: () => _pressedReportButton(context),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: DialogButton(
                  text: _hasLink ? linkLabel! : 'Entendido',
                  onPressed: () => _pressedButton(context),
                ),
              ),
            ],
          ),
        ],
        closable: closable,
      ),
    );
  }
}
