import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in .env file:
// VARIABLE=value
// Keys and certificates go without BEGIN-END blocks, newlines or '\n':
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
  @EnviedField(varName: 'interstitialUnitId', obfuscate: true)
  static const interstitialUnitId = _Env.interstitialUnitId;

  @EnviedField(varName: 'bannerUnitId', obfuscate: true)
  static const bannerUnitId = _Env.bannerUnitId;

  @EnviedField(varName: 'API_CERTIFICATE', obfuscate: true)
  static final apiCertificate = _Env.apiCertificate;

  @EnviedField(varName: 'API_PRIVATE_KEY', obfuscate: true)
  static final apiPrivateKey = _Env.apiPrivateKey;
}
