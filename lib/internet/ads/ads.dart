import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/internet/ads/env.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  late String _interstitialUnitId;
  late String _bannerUnitId;

  InterstitialAd? _nextInterstitialAd;

  // Constants:

  static const int _interstitialAdPeriod = 3;
  static const int _interstitialAdOffset = 1; // So 1st is shown 2nd, not 3rd

  // Initialize:

  initialize() {
    if (Platform.isAndroid) {
      _interstitialUnitId = Env.androidInterstitialUnitId;
      _bannerUnitId = Env.androidBannerUnitId;
    } else {
      _interstitialUnitId = Env.iosInterstitialUnitId;
      _bannerUnitId = Env.iosBannerUnitId;
    }

    MobileAds.instance.initialize();
  }

  // Private:

  int _interstitialAdAttempts = _interstitialAdOffset;

  bool _canShowInterstitialAd() =>
      ++_interstitialAdAttempts % _interstitialAdPeriod == 0;

  _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _nextInterstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, err) => ad.dispose(),
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
          );
        },
        onAdFailedToLoad: (_) => {},
      ),
    );
  }

  // Public:

  showInterstitialAd() {
    if (_canShowInterstitialAd()) {
      _nextInterstitialAd?.show();
    }

    _loadInterstitialAd();
  }

  loadBannerAd(Size size, void Function(Ad) onAdLoaded) async {
    BannerAd(
      adUnitId: _bannerUnitId,
      request: const AdRequest(),
      size: AdSize(
        width: size.width.toInt(),
        height: size.height.toInt(),
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onAdLoaded(ad),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    ).load();
  }
}
