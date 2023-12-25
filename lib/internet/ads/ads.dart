import 'dart:developer' as developer;
import 'dart:io';
import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/internet/ads/env/env.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  // Constants:

  static const int _interstitialPeriod = 2; // Minimum attempts before next one
  static const int _interstitialOffset = 1; // Minimum attempts before 1st one

  // Fields:

  late String _bannerUnitId;
  late String _interstitialUnitId;

  InterstitialAd? _nextInterstitial;

  int _interstitialFreeAttempts = _interstitialPeriod - _interstitialOffset;

  // Initialize:

  initialize() {
    MobileAds.instance.initialize();

    if (Platform.isAndroid) {
      _bannerUnitId = Env.androidBannerUnitId;
      _interstitialUnitId = Env.androidInterstitialUnitId;
    } else {
      _bannerUnitId = Env.iosBannerUnitId;
      _interstitialUnitId = Env.iosInterstitialUnitId;
    }

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadConsentForm();
        }
      },
      (error) => developer.log(error.message),
    );

    _loadInterstitial();
  }

  // Private:

  _loadConsentForm() {
    ConsentForm.loadConsentForm(
      (consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((formError) {
            // Call this method again, if the user has already selected an
            // option the message will not be displayed again.
            _loadConsentForm();
          });
        }
      },
      (FormError? error) => developer.log(error?.message ?? ''),
    );
  }

  _loadInterstitial() => InterstitialAd.load(
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

  // Public:
  showInterstitial() {
    if (_nextInterstitial != null) {
      if (_interstitialFreeAttempts >= _interstitialPeriod) {
        _nextInterstitial!.show();
        _nextInterstitial = null;

        _loadInterstitial();
        _interstitialFreeAttempts = 0;
      } else {
        _interstitialFreeAttempts += 1;
      }
    } else {
      _loadInterstitial();
      _interstitialFreeAttempts += 1;
    }
  }

  loadBanner(Size size, void Function(Ad) onLoaded) => BannerAd(
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
