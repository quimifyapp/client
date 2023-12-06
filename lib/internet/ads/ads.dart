import 'dart:developer' as developer;
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';
import 'package:quimify_client/internet/ads/env/env.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  // Constants:

  static const int _interstitialPeriod = 4; // Minimum attempts before next one
  static const int _interstitialOffset = 2; // Minimum attempts before 1st one

  // Fields:

  late String _bannerUnitId;
  late String _interstitialUnitId;

  int _interstitialFreeAttempts = _interstitialPeriod - _interstitialOffset;

  // Initialize:

  initialize() async {
    if (Platform.isAndroid) {
      _bannerUnitId = Env.androidBannerUnitId;
      _interstitialUnitId = Env.androidInterstitialUnitId;
    } else {
      _bannerUnitId = Env.iosBannerUnitId;
      _interstitialUnitId = Env.iosInterstitialUnitId;
    }

    await AppLovinMAX.initialize(Env.applovinMaxSdkKey);

    _initializeInterstitial();
    _loadInterstitial();
  }

  // Private:

  _initializeInterstitial() => AppLovinMAX.setInterstitialListener(
        InterstitialListener(
          onAdLoadedCallback: (ad) {},
          onAdLoadFailedCallback: (id, error) => developer.log(error.message),
          onAdDisplayedCallback: (ad) {},
          onAdDisplayFailedCallback: (ad, error) {},
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (ad) => _loadInterstitial(),
        ),
      );

  _loadInterstitial() => AppLovinMAX.loadInterstitial(_interstitialUnitId);

  // Public:

  MaxAdView getBanner(String name, bool visible, VoidCallback onLoaded) =>
      MaxAdView(
        placement: name,
        adUnitId: _bannerUnitId,
        adFormat: AdFormat.banner,
        visible: visible,
        listener: AdViewAdListener(
          onAdLoadedCallback: (ad) => onLoaded(),
          onAdLoadFailedCallback: (ad, error) => developer.log(error.message),
          onAdClickedCallback: (ad) {},
          onAdExpandedCallback: (ad) {},
          onAdCollapsedCallback: (ad) {},
        ),
      );

  showInterstitial() async {
    bool? ready = await AppLovinMAX.isInterstitialReady(_interstitialUnitId);

    if (ready ?? false) {
      if (_interstitialFreeAttempts >= _interstitialPeriod) {
        AppLovinMAX.showInterstitial(_interstitialUnitId);
        _interstitialFreeAttempts = 0;
      } else {
        _interstitialFreeAttempts += 1;
      }
    } else {
      _loadInterstitial();
      _interstitialFreeAttempts += 1;
    }
  }
}
