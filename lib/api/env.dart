import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in lib/api/.env file:
// INTERSTITIAL_UNIT_ID=
// BANNER_UNIT_ID=

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

@Envied(path: 'lib/api/.env')
abstract class Env {
  @EnviedField(varName: 'INTERSTITIAL_UNIT_ID', obfuscate: true)
  static final String interstitialUnitId = _Env.interstitialUnitId;

  @EnviedField(varName: 'BANNER_UNIT_ID', obfuscate: true)
  static final String bannerUnitId = _Env.bannerUnitId;

  @EnviedField(varName: 'API_CERTIFICATE', obfuscate: true)
  static final String apiCertificate = _Env.apiCertificate;

  @EnviedField(varName: 'API_PRIVATE_KEY', obfuscate: true)
  static final String apiPrivateKey = _Env.apiPrivateKey;
}
