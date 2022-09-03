import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'button.dart';
import 'constants.dart';

class DialogPopup extends StatelessWidget {
  const DialogPopup({
    super.key,
    required this.title,
    this.details,
  })  : linkName = null,
        link = null,
        _hasLink = false,
        _hasReportButton = false,
        hasCloseButton = false,
        closable = true;

  const DialogPopup.report({
    super.key,
    required this.title,
    this.details,
  })  : linkName = null,
        link = null,
        _hasLink = false,
        _hasReportButton = true,
        hasCloseButton = false,
        closable = true;

  const DialogPopup.link(
      {super.key,
      required this.title,
      required this.details,
      required this.linkName,
      required this.link,
      required this.hasCloseButton,
      required this.closable})
      : _hasLink = true,
        _hasReportButton = false;

  final String title;
  final String? details, linkName, link;
  final bool hasCloseButton, closable;

  final bool _hasLink;
  final bool _hasReportButton;

  Future<void> _launchUrl() async {
    await launchUrl(Uri.parse(link!), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(closable),
      child: AlertDialog(
        title: Column(
          children: [
            if (hasCloseButton)
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
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
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
        titlePadding: hasCloseButton ? EdgeInsets.zero : null,
        content: (details != null && details!.isNotEmpty)
            ? Text(
                details!,
                textAlign: TextAlign.center,
              )
            : null,
        contentPadding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsPadding: const EdgeInsets.only(
          bottom: 20,
          left: 15,
          right: 15,
        ),
        actions: [
          Column(
            children: [
              if (_hasLink)
                Column(
                  children: [
                    Button.gradient(
                      gradient: quimifyGradient,
                      child: Text(
                        linkName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () => _launchUrl(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              if (!_hasLink)
                Row(
                  children: [
                    if (_hasReportButton)
                      Row(
                        children: [
                          Button(
                            width: 50,
                            color: const Color.fromARGB(255, 255, 241, 241),
                            onPressed: () {},
                            child: Image.asset(
                              'assets/images/icons/report.png',
                              color: const Color.fromARGB(255, 255, 96, 96),
                              width: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    Expanded(
                      child: Button.gradient(
                        gradient: quimifyGradient,
                        child: const Text(
                          'Entendido',
                          style: TextStyle(
                            color: Colors.white,
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
