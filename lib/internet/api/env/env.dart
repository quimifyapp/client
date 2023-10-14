import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in lib/internet/api/env/api.env file:
  // Format: quoted and without BEGIN-END blocks or any line breaks
  // API_CERTIFICATE="..."
  // API_PRIVATE_KEY="..."

// Set it up:
  // flutter clean
  // flutter pub get
  // flutter packages pub run build_runner build --delete-conflicting-outputs

// Usage:
  // Env.apiPrivateKey
  // Env.apiCertificate

@Envied(path: 'lib/internet/api/env/api.env')
abstract class Env {
  @EnviedField(varName: 'API_CERTIFICATE', obfuscate: true)
  static final String apiCertificate = _Env.apiCertificate;

  @EnviedField(varName: 'API_PRIVATE_KEY', obfuscate: true)
  static final String apiPrivateKey = _Env.apiPrivateKey;
}
