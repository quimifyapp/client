import 'dart:developer' as developer;
import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/internet/ads/env/env.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  // Fields:

  late bool _showBanner = true;
  late String _bannerUnitId = Env.defaultBannerUnitId;

  late bool _showInterstitial = true;
  late int _interstitialPeriod = 2; // Minimum attempts before next one
  late int _interstitialOffset = 1; // Minimum attempts before 1st one
  late String _interstitialUnitId = Env.defaultInterstitialUnitId;

  late int _interstitialFreeAttempts;

  InterstitialAd? _nextInterstitial;

  // Initialize:

  initialize(ClientResult? clientResult) {
    MobileAds.instance.initialize();

    if (clientResult != null) {
      _showBanner = clientResult.bannerAdPresent;

      if (_showBanner) {
        _bannerUnitId = clientResult.bannerAdUnitId!;
      }

      _showInterstitial = clientResult.interstitialAdPresent;

      if (_showInterstitial) {
        _interstitialPeriod = clientResult.interstitialAdPeriod!;
        _interstitialOffset = clientResult.interstitialAdOffset!;
        _interstitialUnitId = clientResult.interstitialAdUnitId!;
      }
    }

    _interstitialFreeAttempts = _interstitialPeriod - _interstitialOffset;

    if (_showBanner || _showInterstitial) {
      _showGdrpForm();
    }

    if (_showInterstitial) {
      _loadInterstitial();
    }
  }

  // Private:

  _showGdrpForm() => ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          if (await ConsentInformation.instance.isConsentFormAvailable()) {
            _displayGdrpForm();
          }
        },
        (error) => developer.log(error.message),
      );

  _displayGdrpForm() => ConsentForm.loadConsentForm(
        (consentForm) async {
          final status = await ConsentInformation.instance.getConsentStatus();
          if (status == ConsentStatus.required) {
            consentForm.show((formError) => _displayGdrpForm());
          }
        },
        (FormError? error) => developer.log(error?.message ?? ''),
      );

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
          onAdFailedToLoad: (error) => developer.log(error.message),
        ),
      );

  // Public:

  loadBanner(Size size, void Function(Ad) onLoaded) {
    if (!_showBanner) {
      return;
    }

    BannerAd bannerAd = BannerAd(
      adUnitId: _bannerUnitId,
      request: const AdRequest(),
      size: AdSize(
        width: size.width.toInt(),
        height: size.height.toInt(),
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded(ad),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          developer.log(error.message);
        },
      ),
    );

    bannerAd.load();
  }

  showInterstitial() {
    if (!_showInterstitial) {
      return;
    }

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
}
