import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in lib/api/.env file:
// ANDROID_INTERSTITIAL_UNIT_ID=ca-app-pub-.../...
// ANDROID_BANNER_UNIT_ID=ca-app-pub-.../...
// IOS_INTERSTITIAL_UNIT_ID=ca-app-pub-.../...
// IOS_BANNER_UNIT_ID=ca-app-pub-.../...

// Keys and certs. go quoted, without BEGIN-END blocks and in a single line:
// API_CERTIFICATE="..."
// API_PRIVATE_KEY="..."

// Set it up:
// flutter clean
// flutter pub get
// flutter packages pub run build_runner build --delete-conflicting-outputs

// Usage:
// Env.apiPrivateKey
// Env.apiCertificate
// ...

@Envied(path: 'lib/api/.env')
abstract class Env {
  @EnviedField(varName: 'API_CERTIFICATE', obfuscate: true)
  static final String apiCertificate = _Env.apiCertificate;

  @EnviedField(varName: 'API_PRIVATE_KEY', obfuscate: true)
  static final String apiPrivateKey = _Env.apiPrivateKey;

  @EnviedField(varName: 'ANDROID_INTERSTITIAL_UNIT_ID', obfuscate: true)
  static final String androidInterstitialUnitId = _Env.androidInterstitialUnitId;

  @EnviedField(varName: 'ANDROID_BANNER_UNIT_ID', obfuscate: true)
  static final String androidBannerUnitId = _Env.androidBannerUnitId;

  @EnviedField(varName: 'IOS_INTERSTITIAL_UNIT_ID', obfuscate: true)
  static final String iosInterstitialUnitId = _Env.iosInterstitialUnitId;

  @EnviedField(varName: 'IOS_BANNER_UNIT_ID', obfuscate: true)
  static final String iosBannerUnitId = _Env.iosBannerUnitId;
}
