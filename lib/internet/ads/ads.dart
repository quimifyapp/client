import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/internet/ads/env/env.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  late String _interstitialUnitId;
  late String _bannerUnitId;

  InterstitialAd? _nextInterstitial;

  // Constants:

  static const int _interstitialPeriod = 3; // Must be > 1
  static const int _interstitialOffset = 1; // Must be > 0

  // Initialize:

  initialize() {
    MobileAds.instance.initialize();

    if (Platform.isAndroid) {
      _interstitialUnitId = Env.androidInterstitialUnitId;
      _bannerUnitId = Env.androidBannerUnitId;
    } else {
      _interstitialUnitId = Env.iosInterstitialUnitId;
      _bannerUnitId = Env.iosBannerUnitId;
    }
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        loadConsentForm();
      }
    }, (error) {
      //TODO: Manage error
    });
  }

  // Private:

  int _interstitialAttempts = _interstitialOffset;

  bool _timeToLoadInterstitial() =>
      (_interstitialAttempts + 1) % _interstitialPeriod == 0;

  bool _timeToShowInterstitial() =>
      _interstitialAttempts % _interstitialPeriod == 0;

  loadConsentForm() {
    ConsentForm.loadConsentForm((consentForm) async {
      final status = await ConsentInformation.instance.getConsentStatus();
      if (status == ConsentStatus.required) {
        consentForm.show((formError) {
          // Call this method again, if the user has already selected an
          // option the message will not be displayed again.
          loadConsentForm();
        });
      }
    }, (FormError? error) {
      //TODO: Handle error
    });
  }

  _loadInterstitial() async {
    await InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _nextInterstitial = ad;

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

  showInterstitial() {
    _interstitialAttempts += 1;

    if (_timeToLoadInterstitial()) {
      _loadInterstitial();
    } else if (_timeToShowInterstitial()) {
      _nextInterstitial?.show();
    }
  }

  loadBanner(Size size, void Function(Ad) onLoaded) async {
    BannerAd(
      adUnitId: _bannerUnitId,
      request: const AdRequest(),
      size: AdSize(
        width: size.width.toInt(),
        height: size.height.toInt(),
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded(ad),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    ).load();
  }
}
