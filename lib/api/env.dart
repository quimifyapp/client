import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in .env file:
// VARIABLE=value
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

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'INTERSTITIAL_UNIT_ID', obfuscate: true)
  static final interstitialUnitId = _Env.interstitialUnitId;

  @EnviedField(varName: 'BANNER_UNIT_ID', obfuscate: true)
  static final bannerUnitId = _Env.bannerUnitId;

  @EnviedField(varName: 'API_CERTIFICATE', obfuscate: true)
  static final apiCertificate = _Env.apiCertificate;

  @EnviedField(varName: 'API_PRIVATE_KEY', obfuscate: true)
  static final apiPrivateKey = _Env.apiPrivateKey;
}
