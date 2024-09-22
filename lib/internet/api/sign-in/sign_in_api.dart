import 'package:google_sign_in/google_sign_in.dart';
import 'package:quimify_client/internet/api/sign-in/info_google.dart';
import 'package:quimify_client/storage/storage.dart';

class UserAuthService {
  static final _googleSignIn = GoogleSignIn(scopes: scopes);

  static List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/user.birthday.read',
    'https://www.googleapis.com/auth/user.gender.read'
  ];

  static Future<void> signOut() async {
    if (_googleSignIn.currentUser != null) await _googleSignIn.signOut();
    final prefs = Storage();
    await prefs.saveBool('isAnonymouslySignedIn', false);
  }

  static Future<QuimifyIdentity?> signInGoogleUser() async {
    final user = await _googleSignIn.signIn();
    if (user == null) return null;
    return await postLogin(AuthProviders.google, user);
  }

  static Future<QuimifyIdentity?> signInAnonymousUser() async {
    QuimifyIdentity? identity = await postLogin(AuthProviders.none, null);
    final prefs = Storage();
    await prefs.saveBool('isAnonymouslySignedIn', true);

    return identity;
  }

  Future<bool> getisAnonymouslySignedIn() async {
    final prefs = Storage();
    return prefs.getBool('isAnonymouslySignedIn') ?? false;
  }

  // TODO: Implement error handling for login requests
  static Future<QuimifyIdentity?> postLogin(
      AuthProviders service, GoogleSignInAccount? googleUser) async {
    switch (service) {
      case AuthProviders.google:
        if (googleUser != null) {
          var data = await getInfoGoogle(googleUser);
          QuimifyIdentity identity = QuimifyIdentity(
              isPremium: false,
              googleUser: googleUser,
              photoUrl: googleUser.photoUrl,
              displayName: googleUser.displayName ?? 'Quimify',
              email: googleUser.email,
              gender: data['gender'],
              birthday: data['birthday']);
          return identity;
        }
        print('Enviado /login');
        break;
      case AuthProviders.none:
        return null;
    }
    return null;
  }

  static Future<QuimifyIdentity?> handleSilentAuthentication(
      AuthProviders service) async {
    if (service != AuthProviders.google) return null;

    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser != null) {
      return await postLogin(AuthProviders.google, googleUser);
    }
    return null;
  }
}

class QuimifyIdentity {
  final GoogleIdentity? googleUser;
  final bool isPremium;
  final String? photoUrl;
  final String displayName;
  final String? gender;
  final String email;
  final String? birthday;

  QuimifyIdentity({
    this.googleUser,
    required this.isPremium,
    required this.photoUrl,
    required this.displayName,
    required this.email,
    this.gender,
    this.birthday,
  });
}

enum AuthProviders { google, none }
