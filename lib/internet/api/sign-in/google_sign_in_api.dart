import 'package:google_sign_in/google_sign_in.dart';

class UserAuthService {
  static final _googleSignIn = GoogleSignIn(scopes: scopes);

  static QuimifyIdentity _identity = QuimifyIdentity(
      isPremium: false,
      photoUrl:
          'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg',
      displayName: 'Quimify',
      email: 'Quimify@quimify.com',
      birthday: 'a');

  static QuimifyIdentity get identity => _identity;

  static List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/user.birthday.read',
  ];

  static Future<void> signOut() async {
    if (_googleSignIn.currentUser != null) await _googleSignIn.signOut();
  }

  static Future<GoogleSignInAccount?> getGoogleUser() async {
    if (_googleSignIn.currentUser == null) {
      await UserAuthService.signInGoogleUser();
    }
    return _googleSignIn.currentUser;
  }

  static Future<QuimifyIdentity?> signInGoogleUser() async {
    final user = await _googleSignIn.signIn();
    if (user == null) return null;
    return await postLogin(AuthProviders.google, user, null);
  }

  static GoogleSignInAccount? getAppleUser() {
    // TODO: Implement Apple Sign-In
    return _googleSignIn.currentUser;
  }

  // TODO: Hacer la petición POST /login(id)
  static Future<QuimifyIdentity> postLogin(AuthProviders service,
      GoogleIdentity? googleUser, AppleIdentity? appleUser) async {
    switch (service) {
      case AuthProviders.google:
        if (googleUser != null) {
          // At the moment, returning default QuimifyIdentity
          _identity = QuimifyIdentity(
              isPremium: false,
              googleUser: googleUser,
              photoUrl: googleUser.photoUrl ??
                  'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg',
              displayName: googleUser.displayName ?? 'Quimify',
              email: googleUser.email,
              //TODO: Get Birthday from Google
              birthday: googleUser.displayName);
        }
        print('Enviado /login');
        return _identity;
      case AuthProviders.apple:
        // TODO: Implement Apple Sign-In
        return _identity;
      case AuthProviders.none:
        return _identity;
    }
  }

  static Future<QuimifyIdentity?> handleSilentAuthentication(
      AuthProviders service) async {
    // At the moment, only works with GooglwSignIn
    if (service != AuthProviders.google) return null;

    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser != null) {
      return await postLogin(AuthProviders.google, googleUser, null);
    }
    return null;
  }
}

// Later implementation, just for logic now
class AppleIdentity {}

class QuimifyIdentity {
  final GoogleIdentity? googleUser;
  final bool isPremium;
  final String photoUrl;
  final String displayName;
  final String? email;
  final String? birthday;

  QuimifyIdentity({
    this.googleUser,
    required this.isPremium,
    required this.photoUrl,
    required this.displayName,
    this.email,
    this.birthday,
  });
}

enum AuthProviders { google, apple, none }
