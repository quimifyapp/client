import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class Payments {
  static final Payments _singleton = Payments._internal();

  factory Payments() => _singleton;

  Payments._internal();

  bool _subscribed = false;

  // Constants:

  static const _publicApiKeyAndroid = 'goog_SgCLLuxoLOuSMTDVBqzacRsJFaD';
  static const _publicApiKeyIos = 'appl_TVkhSRZrgVENdilvDxxbEzzGxXI';

  // Initialize:

  initialize() async {
    await Purchases.configure(PurchasesConfiguration(_publicApiKey()));
    Purchases.addCustomerInfoUpdateListener(_update);
    Purchases.getCustomerInfo().then(_update);
  }

  // Private:

  String _publicApiKey() =>
      Platform.isAndroid ? _publicApiKeyAndroid : _publicApiKeyIos;

  _update(CustomerInfo customerInfo) {
    EntitlementInfo? entitlementInfo = customerInfo.entitlements.all['Premium'];
    _subscribed = entitlementInfo?.isActive ?? false;
  }

  // Public:

  showPaywall() => RevenueCatUI.presentPaywallIfNeeded(
        'Premium',
        displayCloseButton: true,
      );

  bool get isSubscribed => _subscribed;
}
