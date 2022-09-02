import 'package:flutter/material.dart';

import '../widgets/dialog_popup.dart';

void showDetailedDialogPopup(
    BuildContext context, String title, String details) {
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

void showDialogPopup(BuildContext context, String title) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (BuildContext context) {
      return DialogPopup(
        title: title
      );
    },
  );
}
