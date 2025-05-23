import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/no_internet_dialog.dart';

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

  String getPublicApiKey() =>
      Platform.isAndroid ? _publicApiKeyAndroid : _publicApiKeyIos;

  _update(CustomerInfo customerInfo) {
    EntitlementInfo? entitlementInfo = customerInfo.entitlements.all['Premium'];
    _subscribed = entitlementInfo?.isActive ?? false;
  }

  // Public:
  Future<void> showPaywall(BuildContext context) async {
    // Check internet connectivity before proceeding
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) => noInternetDialog(context),
      );
      return;
    }

    // Check if Purchases is configured
    final isConfigured = await Purchases.isConfigured;
    if (!isConfigured) {
      final configuration = PurchasesConfiguration(
        Platform.isAndroid
            ? 'goog_SgCLLuxoLOuSMTDVBqzacRsJFaD'
            : 'appl_TVkhSRZrgVENdilvDxxbEzzGxXI',
      );

      // Configure RevenueCat
      await Purchases.configure(configuration);
    }

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
      rethrow;
    }
  }

  bool get isSubscribed => _subscribed;
  bool get isInitialized => _isInitialized;
}
