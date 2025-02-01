import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/internet/ads/env/env.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/internet/payments/payments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ads {
  static final Ads _singleton = Ads._internal();
  static const int kMaxDailyRewards = 5;
  static const String kLastRewardDateKey = 'last_reward_date';
  static const String kDailyRewardsCountKey = 'daily_rewards_count';

  factory Ads() => _singleton;

  Ads._internal();

  // Fields:

  late bool _showBanner = true;
  late String _bannerUnitId = Env.defaultBannerUnitId;

  late bool _showInterstitial = true;
  late int _interstitialPeriod = 2; // Minimum attempts before next one
  late int _interstitialOffset = 1; // Minimum attempts before 1st one
  late String _interstitialUnitId = Env.defaultInterstitialUnitId;

  late bool _showRewarded = true;
  late String _rewardedUnitId = Env.defaultRewardedUnitId;
  late int _dailyRewardsCount = 0;
  late DateTime _lastRewardDate;

  late int _interstitialFreeAttempts;

  InterstitialAd? _nextInterstitial;
  RewardedAd? _nextRewarded;

  // Initialize:

  initialize(ClientResult? clientResult) async {
    MobileAds.instance.initialize();

    // Load saved reward data
    final prefs = await SharedPreferences.getInstance();
    final lastRewardDateStr = prefs.getString(kLastRewardDateKey);
    if (lastRewardDateStr != null) {
      _lastRewardDate = DateTime.parse(lastRewardDateStr);

      // Reset counter if it's a new day
      if (!_isSameDay(_lastRewardDate, DateTime.now())) {
        _dailyRewardsCount = 0;
        await _saveRewardData();
      } else {
        _dailyRewardsCount = prefs.getInt(kDailyRewardsCountKey) ?? 0;
      }
    } else {
      _lastRewardDate = DateTime.now();
      _dailyRewardsCount = 0;
      await _saveRewardData();
    }

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

      _showRewarded = clientResult.rewardedAdPresent;
      if (_showRewarded && clientResult.rewardedAdUnitId != null) {
        _rewardedUnitId = clientResult.rewardedAdUnitId!;
      }
    }

    _interstitialFreeAttempts = _interstitialPeriod - _interstitialOffset;

    if (_showBanner || _showInterstitial || _showRewarded) {
      _showGdrpForm();
    }

    if (_showInterstitial) {
      _loadInterstitial();
    }

    if (_showRewarded) {
      _loadRewarded();
    }
  }

  // Private:

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _saveRewardData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        kLastRewardDateKey, _lastRewardDate.toIso8601String());
    await prefs.setInt(kDailyRewardsCountKey, _dailyRewardsCount);
  }

  Future<void> _incrementRewardCount() async {
    final now = DateTime.now();
    if (!_isSameDay(_lastRewardDate, now)) {
      _dailyRewardsCount = 0;
      _lastRewardDate = now;
    }
    _dailyRewardsCount++;
    await _saveRewardData();
  }

  _loadRewarded() => RewardedAd.load(
        adUnitId: _rewardedUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _nextRewarded = ad;

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _loadRewarded(); // Preload next rewarded ad
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                _loadRewarded();
              },
            );
          },
          onAdFailedToLoad: (error) => developer.log(error.message),
        ),
      );

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
              onAdFailedToShowFullScreenContent: (ad, err) {
                Payments().showPaywall();
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) {
                Payments().showPaywall();
                ad.dispose();
              },
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

    if (Payments().isSubscribed) {
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

    if (Payments().isSubscribed) {
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

  Future<bool> showRewarded() async {
    if (!_showRewarded) {
      return false;
    }

    if (Payments().isSubscribed) {
      return false;
    }

    if (_dailyRewardsCount >= kMaxDailyRewards) {
      return false;
    }

    if (_nextRewarded == null) {
      _loadRewarded();
      return false;
    }

    Completer<bool> rewardCompleter = Completer<bool>();

    _nextRewarded!.show(
      onUserEarnedReward: (_, reward) async {
        await _incrementRewardCount();
        rewardCompleter.complete(true);
      },
    );

    _nextRewarded = null;
    _loadRewarded(); // Preload next rewarded ad

    return rewardCompleter.future;
  }

  bool get isRewardedAdReady => _nextRewarded != null;

  int get remainingDailyRewards => kMaxDailyRewards - _dailyRewardsCount;

  bool get canWatchRewardedAd =>
      _showRewarded &&
      !Payments().isSubscribed &&
      _nextRewarded != null &&
      _dailyRewardsCount < kMaxDailyRewards;
}
