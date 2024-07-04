import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future<GoogleSignInAccount?> loginSilently() => _googleSignIn.signInSilently();

  static Future<bool> isLoggedIn() => _googleSignIn.isSignedIn();

  static Future logout() => _googleSignIn.disconnect();

}
