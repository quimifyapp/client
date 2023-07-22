import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager { // TODO rename
  static BannerAd? _bannerAd;
  static InterstitialAd? _interstitialAd;

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await MobileAds.instance.initialize();
    await _loadInterstitialAd();
  }

  static Future<void> _loadInterstitialAd() async {
    print("Loaded new InterstitialAd");
    // TODO (PRODUCTION): Replace with: const adUnitId =  env.interstitialUnitId
    const adUnitId = 'ca-app-pub-8671969439707812/9624458985';
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  static Future<void> loadBannerAd(double bannerAdWidth) async {
    const adUnitId = 'ca-app-pub-8671969439707812/1546255460'; // Put in SECRETS
    final adSize = AdSize(
      width: bannerAdWidth.toInt(),
      height: 50,
    );

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: adSize,
      listener: const BannerAdListener(),
    );

    await _bannerAd!.load();
  }

  static Widget getBannerAdWidget() {
    return AdWidget(ad: _bannerAd!);
  }

  static BannerAd? getBannerAd() {
    return _bannerAd;
  }

  static void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      _loadInterstitialAd().then((_) {
        _interstitialAd!.show();
        _loadInterstitialAd();
      });
    } else {
      _interstitialAd!.show();
      _loadInterstitialAd();
    }
  }
}