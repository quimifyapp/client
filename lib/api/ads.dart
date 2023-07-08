import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static late BannerAd _bannerAd;
  static late InterstitialAd _interstitialAd;

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await MobileAds.instance.initialize();
// MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
// testDeviceIds: [
// '3681BD2E0063F9636687A46C105FF29A'
// ])); //TODO: Production remove this
    await _loadBannerAd();
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

  static Future<void> _loadBannerAd() async {
    const adUnitId = 'ca-app-pub-3940256099942544/6300978111';
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Banner ad successfully loaded.
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose(); // Dispose the ad to free resources.
        },
      ),
    )..load();
  }

  static Future<void> _reloadBannerAd() async {
    await _loadBannerAd();
  }

  static AdWidget getBannerAdWidget() {
    final currentBannerAd = _bannerAd;
    _reloadBannerAd();
    return AdWidget(ad: currentBannerAd);
  }

  static void showInterstitialAd() {
    if (Random().nextInt(100) < 80) {
      _interstitialAd.show();
      _loadInterstitialAd();
    }
  }
}
