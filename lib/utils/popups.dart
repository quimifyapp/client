import 'package:flutter/material.dart';

import '../widgets/popup.dart';

void showPopup(BuildContext context, String title, String message) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (BuildContext context) {
      return Popup(
        title: title,
        message: message,
      );
    },
  );
}
