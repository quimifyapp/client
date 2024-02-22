import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

showLoadingIndicator(BuildContext context) {
  // Popup customization:
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..dismissOnTap = false
    ..userInteractions = true
    ..indicatorSize = 25
    ..radius = 13
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..indicatorColor = QuimifyColors.teal()
    ..textColor = Colors.transparent // Can't be null
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = QuimifyColors.dialogBackdrop(context)
    ..backgroundColor = QuimifyColors.foreground(context);

  EasyLoading.show();
}

hideLoadingIndicator() {
  EasyLoading.dismiss();
}
