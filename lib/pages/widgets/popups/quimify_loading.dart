import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void startQuimifyLoading(BuildContext context) {
  // Popup customization:
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..dismissOnTap = false
    ..userInteractions = true
    ..indicatorSize = 25
    ..radius = 13
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..indicatorColor = quimifyTeal
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Theme.of(context).colorScheme.shadow
    ..textColor = Colors.transparent // No nullable
    ..backgroundColor = Theme.of(context).colorScheme.surface;

  EasyLoading.show();
}

void stopQuimifyLoading() {
  EasyLoading.dismiss();
}
