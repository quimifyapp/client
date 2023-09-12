import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'env.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  InterstitialAd? _interstitialAd;
  int _interstitialAdsShown = 0;

  // Constants:

  static const int _interstitialAdPeriod = 4;

  // Initialize:

  initialize() async {
    await MobileAds.instance.initialize();
    await _loadInterstitialAd();
  }

  // Private:

  bool _canShowInterstitialAd() =>
      ++_interstitialAdsShown % _interstitialAdPeriod == 0;

  _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: Env.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          // TODO handle
        },
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
      adUnitId: Env.bannerUnitId,
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
