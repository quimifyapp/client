import 'package:cliente/pages/widgets/quimify_button.dart';
import 'package:cliente/pages/widgets/quimify_gradient.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogPopup extends StatelessWidget {
  const DialogPopup.message({
    super.key,
    required this.title,
    this.details,
  })  : _hasLink = false,
        _hasReportButton = false,
        _hasCloseButton = false,
        closable = true,
        linkName = null,
        link = null;

  const DialogPopup.linkedMessage({
    super.key,
    required this.title,
    required this.details,
    required this.linkName,
    required this.link,
  })  : _hasLink = true,
        _hasReportButton = false,
        _hasCloseButton = true,
        closable = true;

  const DialogPopup.reportableMessage({
    super.key,
    required this.title,
    this.details,
  })  : _hasLink = false,
        _hasReportButton = true,
        _hasCloseButton = false,
        closable = true,
        linkName = null,
        link = null;

  const DialogPopup.update(
      {super.key,
      required this.details,
      required this.closable,
      required this.link})
      : _hasLink = true,
        _hasReportButton = false,
        _hasCloseButton = closable,
        title = 'Actualización ${closable ? 'disponible' : 'necesaria'}',
        linkName = 'Actualizar';

  final String title;
  final String? details, linkName, link;
  final bool closable, _hasLink, _hasReportButton, _hasCloseButton;

  void _openLink() {
    launchUrl(Uri.parse(link!), mode: LaunchMode.externalApplication);
  }

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: closable,
      barrierColor: Theme.of(context).colorScheme.shadow,
      anchorPoint: const Offset(0, 0),
      // Centered
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(closable),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(25),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        titlePadding: _hasCloseButton ? EdgeInsets.zero : null,
        title: Column(
          children: [
            if (_hasCloseButton)
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                    padding:
                        const EdgeInsets.only(top: 17, right: 17, bottom: 10),
                  ),
                ],
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 22,
              ),
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
        content: (details != null && details!.isNotEmpty)
            ? Text(
                details!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : null,
        actionsPadding: const EdgeInsets.only(
          bottom: 20,
          left: 15,
          right: 15,
        ),
        actions: [
          Column(
            children: [
              if (_hasLink)
                QuimifyButton.gradient(
                  gradient: quimifyGradient,
                  child: Text(
                    linkName!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () => _openLink(),
                ),
              if (!_hasLink)
                Row(
                  children: [
                    if (_hasReportButton)
                      Row(
                        children: [
                          QuimifyButton(
                            width: 50,
                            color: Theme.of(context).colorScheme.error,
                            onPressed: () {},
                            child: Image.asset(
                              'assets/images/icons/report.png',
                              color: Theme.of(context).colorScheme.onError,
                              width: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    Expanded(
                      child: QuimifyButton.gradient(
                        gradient: quimifyGradient,
                        child: Text(
                          'Entendido',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: 17,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
            ],
          )
        ],
      ),
    );
  }
}
