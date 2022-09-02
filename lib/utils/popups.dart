import 'package:flutter/material.dart';

import '../widgets/dialog_popup.dart';

void showDialogPopup(BuildContext context, String title, String message) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (BuildContext context) {
      return DialogPopup(
        title: title,
        message: message,
      );
    },
  );
}
