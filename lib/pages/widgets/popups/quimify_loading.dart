import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void startQuimifyLoading(BuildContext context) {
  // Popup customization:
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Theme.of(context).colorScheme.surface
    ..indicatorColor = quimifyTeal
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Theme.of(context).colorScheme.shadow
    ..indicatorSize = 25
    ..radius = 13
    ..userInteractions = true
    ..dismissOnTap = false
    ..textColor = Colors.transparent; // No nullable

  EasyLoading.show();
}

void stopqQuimifyLoading() {
  EasyLoading.dismiss();
}
