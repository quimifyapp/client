import 'dart:io';

import 'package:cliente/api/results/access_result.dart';
import 'package:flutter/material.dart';

import '../widgets/dialog_popup.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

void showDialogPopup(
    BuildContext context, bool dismissible, DialogPopup dialogPopup) {
  showDialog<void>(
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
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (BuildContext context) {
      return DialogPopup.report(
        title: title,
        details: details,
      );
    },
  );
}

void showAvailableUpdateDialogPopup(
    BuildContext context, String details, bool mandatory) {
  if (!kIsWeb) {
    String link = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.quimify'
        : 'https://apps.apple.com/pa/app/youtube/id544007664';

    showDialogPopup(
      context,
      !mandatory,
      DialogPopup.link(
        title:
            mandatory ? 'Actualización necesaria' : 'Actualización disponible',
        details: details,
        linkName: 'Actualizar',
        link: link,
        hasCloseButton: false,
        closable: !mandatory,
      ),
    );
  }
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
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (BuildContext context) {
      return DialogPopup(
        title: title,
        details: details,
      );
    },
  );
}

void showWelcomeDialogPopups(BuildContext context, AccessResult accessResult) {
  if (!accessResult.updateMandatory && accessResult.messagePresent) {
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

  if (accessResult.updateAvailable) {
    showAvailableUpdateDialogPopup(
      context,
      accessResult.updateDetails,
      accessResult.updateMandatory,
    );
  }

}
