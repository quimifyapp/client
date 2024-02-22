import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in lib/internet/ads/env/ads.env file:
  // DEFAULT_BANNER_UNIT_ID=...
  // DEFAULT_INTERSTITIAL_UNIT_ID=...

// Set it up:
  // flutter clean (important or cache will play you)
  // flutter pub get
  // flutter packages pub run build_runner build --delete-conflicting-outputs

// Usage:
  // Env.defaultBannerUnitI
  // Env.defaultInterstitialUnitId

@Envied(path: 'lib/internet/ads/env/ads.env')
abstract class Env {
  @EnviedField(varName: 'DEFAULT_BANNER_UNIT_ID', obfuscate: true)
  static final String defaultBannerUnitId = _Env.defaultBannerUnitId;

  @EnviedField(varName: 'DEFAULT_INTERSTITIAL_UNIT_ID', obfuscate: true)
  static final String defaultInterstitialUnitId = _Env.defaultInterstitialUnitId;
}
