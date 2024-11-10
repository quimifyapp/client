import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// Get the GetIt instance
final getIt = GetIt.instance;

// Service class to manage subscription state
class SubscriptionService {
  bool _isSubscribed = false;
  EntitlementInfo? _entitlementInfo;

  bool get isSubscribed => _isSubscribed;
  EntitlementInfo? get entitlementInfo => _entitlementInfo;

  // Stream controllers to broadcast subscription changes
  final _subscriptionController = StreamController<bool>.broadcast();
  Stream<bool> get subscriptionStream => _subscriptionController.stream;

  Future<void> initialize() async {
    // Set up listener for RevenueCat customer info updates
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      await _handleCustomerInfoUpdate(customerInfo);
    });

    // Get initial subscription state
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      await _handleCustomerInfoUpdate(customerInfo);
    } catch (e) {
      debugPrint('Error getting initial customer info: $e');
    }
  }

  Future<void> _handleCustomerInfoUpdate(CustomerInfo customerInfo) async {
    final entitlementInfo = customerInfo.entitlements.all['Premium'];
    final isSubscribed = entitlementInfo?.isActive ?? false;

    _isSubscribed = isSubscribed;
    _entitlementInfo = entitlementInfo;

    // Notify listeners
    _subscriptionController.add(isSubscribed);
  }

  void dispose() {
    _subscriptionController.close();
  }
}
