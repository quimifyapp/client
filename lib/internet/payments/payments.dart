import 'dart:developer';
import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class Payments {
  static final Payments _singleton = Payments._internal();

  factory Payments() => _singleton;

  Payments._internal();

  bool _subscribed = false;
  bool _isInitialized = false;

  // Constants:

  static const _publicApiKeyAndroid = 'goog_SgCLLuxoLOuSMTDVBqzacRsJFaD';
  static const _publicApiKeyIos = 'appl_TVkhSRZrgVENdilvDxxbEzzGxXI';

  // Initialize:

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure RevenueCat
      await Purchases.configure(PurchasesConfiguration(_getPublicApiKey()));

      // Add listener for customer info updates
      Purchases.addCustomerInfoUpdateListener(_update);

      // Get initial customer info
      final customerInfo = await Purchases.getCustomerInfo();
      _update(customerInfo);

      _isInitialized = true;
    } catch (e) {
      log('RevenueCat initialization failed: $e');
      // Handle initialization failure
      _isInitialized = false;
      rethrow;
    }
  }

  // Private:

  String _getPublicApiKey() =>
      Platform.isAndroid ? _publicApiKeyAndroid : _publicApiKeyIos;

  _update(CustomerInfo customerInfo) {
    EntitlementInfo? entitlementInfo = customerInfo.entitlements.all['Premium'];
    _subscribed = entitlementInfo?.isActive ?? false;
  }

  // Public:

  Future<void> showPaywall() async {
    if (!_isInitialized) {
      log('Payments not initialized. Attempting to initialize...');
      await initialize();
    }

    try {
      await RevenueCatUI.presentPaywallIfNeeded(
        'Premium',
        displayCloseButton: true,
      );
    } catch (e) {
      log('Failed to show paywall: $e');
      // Handle paywall presentation failure
    }
  }

  bool get isSubscribed => _subscribed;
  bool get isInitialized => _isInitialized;
}
