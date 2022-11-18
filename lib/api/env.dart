import 'package:envied/envied.dart';

part 'env.g.dart';

// Put variables in .env file, between " " and without BEGIN-END blocks

// Run: flutter packages pub run build_runner build --delete-conflicting-outputs

// Usage: Env.apiKey, Env.apiCertificate

@Envied(path: '.env')
abstract class Env {

  @EnviedField(varName: 'API_CERTIFICATE', obfuscate: true)
  static final apiCertificate = _Env.apiCertificate;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final apiKey = _Env.apiKey;

}