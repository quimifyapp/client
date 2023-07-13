import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static BannerAd? _bannerAd;
  static late InterstitialAd _interstitialAd;

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await MobileAds.instance.initialize();
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: [
          '3681BD2E0063F9636687A46C105FF29A',
        ],
      ),
    ); // TODO: Production remove this
    await _loadInterstitialAd();
  }

  static Future<void> _loadInterstitialAd() async {
    const adUnitId = 'ca-app-pub-3940256099942544/1033173712';
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  static Future<void> loadBannerAd(double bannerAdWidth) async {
    const adUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Put in SECRETS
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
    if (Random().nextInt(100) < 80) {
      _interstitialAd.show();
      _loadInterstitialAd();
    }
  }
}
