import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in .env file, keys and certificates without BEGIN-END blocks:
  // API_CERTIFICATE="..."
  // API_PRIVATE_KEY="..."

// Set it up:
  // flutter packages pub run build_runner build --delete-conflicting-outputs

// Usage:
  // Env.apiPrivateKey
  // Env.apiCertificate

@Envied(path: '.env')
abstract class Env {

  @EnviedField(varName: 'API_CERTIFICATE', obfuscate: true)
  static final apiCertificate = _Env.apiCertificate;

  @EnviedField(varName: 'API_PRIVATE_KEY', obfuscate: true)
  static final apiPrivateKey = _Env.apiPrivateKey;

}