import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'env.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  late String interstitialUnitId;
  late String bannerUnitId;

  InterstitialAd? _interstitialAd;

  // Constants:

  static const int _interstitialAdPeriod = 3;
  static const int _interstitialAdOffset = 1; // So 1st is shown 2nd, not 3rd

  // Initialize:

  initialize() async {
    if (Platform.isAndroid) {
      interstitialUnitId = Env.androidInterstitialUnitId;
      bannerUnitId = Env.androidBannerUnitId;
    } else {
      interstitialUnitId = Env.iosInterstitialUnitId;
      bannerUnitId = Env.iosBannerUnitId;
    }

    await MobileAds.instance.initialize();
    await _loadInterstitialAd();
  }

  // Private:

  int _interstitialAdChanceCounter = _interstitialAdOffset;

  bool _canShowInterstitialAd() =>
      ++_interstitialAdChanceCounter % _interstitialAdPeriod == 0;

  _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (_) => {},
      ),
    );
  }

  // Public:

  showInterstitialAd() {
    if (_interstitialAd == null) {
      _loadInterstitialAd();
      return;
    }

    if (_canShowInterstitialAd()) {
      _interstitialAd!.show();
      _loadInterstitialAd();
    }
  }

  Future<Widget> getBannerAd(Size size, VoidCallback onAdLoaded) async {
    BannerAd bannerAd = BannerAd(
      adUnitId: bannerUnitId,
      request: const AdRequest(),
      size: AdSize(
        width: size.width.toInt(),
        height: size.height.toInt(),
      ),
      listener: BannerAdListener(
        onAdLoaded: (_) => onAdLoaded(),
      ),
    );

    bannerAd.load();

    return SizedBox(
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }
}
