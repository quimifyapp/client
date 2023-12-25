import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in lib/internet/ads/env/ads.env file:
  // APPLOVIN_MAX_SDK_KEY=...
  // ANDROID_BANNER_UNIT_ID=...

// Set it up:
  // flutter clean (important or cache will play you)
  // flutter pub get
  // flutter packages pub run build_runner build --delete-conflicting-outputs

// Usage:
  // Env.androidInterstitialUnitId
  // Env.iosBannerUnitId
  // ...

@Envied(path: 'lib/internet/ads/env/ads.env')
abstract class Env {
  @EnviedField(varName: 'ANDROID_BANNER_UNIT_ID', obfuscate: true)
  static final String androidBannerUnitId = _Env.androidBannerUnitId;

  @EnviedField(varName: 'ANDROID_INTERSTITIAL_UNIT_ID', obfuscate: true)
  static final String androidInterstitialUnitId = _Env.androidInterstitialUnitId;

  @EnviedField(varName: 'IOS_BANNER_UNIT_ID', obfuscate: true)
  static final String iosBannerUnitId = _Env.iosBannerUnitId;

  @EnviedField(varName: 'IOS_INTERSTITIAL_UNIT_ID', obfuscate: true)
  static final String iosInterstitialUnitId = _Env.iosInterstitialUnitId;
}
