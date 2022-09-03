import 'dart:io';

import 'package:cliente/api/results/access_result.dart';
import 'package:flutter/material.dart';

import 'widgets/dialog_popup.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

Future showDialogPopup(
    BuildContext context, bool dismissible, DialogPopup dialogPopup) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (BuildContext context) {
      return dialogPopup;
    },
  );
}

void showReportDialogPopup(BuildContext context, String title,
    [String? details]) {
  showDialogPopup(
    context,
    true,
    DialogPopup.report(
      title: title,
      details: details,
    ),
  );
}

void showLinkedMessageDialogPopup(BuildContext context, String title,
    String details, String linkName, String link) {
  showDialogPopup(
    context,
    true,
    DialogPopup.link(
      title: title,
      details: details,
      linkName: linkName,
      link: link,
      hasCloseButton: true,
      closable: true,
    ),
  );
}

void showMessageDialogPopup(BuildContext context, String title,
    [String? details]) {
  showDialogPopup(
    context,
    true,
    DialogPopup(
      title: title,
      details: details,
    ),
  );
}

void showWelcomeMessageDialogPopup(
    BuildContext context, AccessResult accessResult) {
  if (accessResult.messageLinkPresent) {
    showLinkedMessageDialogPopup(
      context,
      accessResult.messageTitle,
      accessResult.messageDetails,
      accessResult.messageLinkName,
      accessResult.messageLink,
    );
  } else {
    showMessageDialogPopup(
      context,
      accessResult.messageTitle,
      accessResult.messageDetails,
    );
  }
}

Future showAvailableUpdateDialogPopup(
    BuildContext context, AccessResult accessResult) async {
  String link = Platform.isAndroid
      ? 'https://play.google.com/store/apps/details?id=com.quimify'
      : 'https://apps.apple.com/pa/app/youtube/id544007664';

  await showDialogPopup(
    context,
    !accessResult.updateMandatory,
    DialogPopup.link(
      title: accessResult.updateMandatory
          ? 'Actualización necesaria'
          : 'Actualización disponible',
      details: accessResult.updateDetails,
      linkName: 'Actualizar',
      link: link,
      hasCloseButton: false,
      closable: !accessResult.updateMandatory,
    ),
  );
}

void showWelcomeDialogPopups(BuildContext context, AccessResult accessResult) {
  if (accessResult.updateAvailable && !kIsWeb) {
    showAvailableUpdateDialogPopup(context, accessResult)
        .then((_) => showWelcomeMessageDialogPopup(context, accessResult));
  } else {
    showWelcomeMessageDialogPopup(context, accessResult);
  }
}
