import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants.dart';

void startLoading(context) {
  // Popup customization:
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Theme.of(context).colorScheme.surface
    ..indicatorColor = quimifyTeal
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Theme.of(context).colorScheme.shadow
    ..indicatorSize = 35
    ..userInteractions = true
    ..dismissOnTap = false
    ..textColor = Colors.transparent; // No nullable

  EasyLoading.show();
}

void stopLoading() {
  EasyLoading.dismiss();
}