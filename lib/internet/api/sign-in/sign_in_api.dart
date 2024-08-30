import 'package:google_sign_in/google_sign_in.dart';
import 'package:quimify_client/internet/api/sign-in/info_google.dart';

class UserAuthService {
  static final _googleSignIn = GoogleSignIn(scopes: scopes);

  static QuimifyIdentity _identity = QuimifyIdentity(
      isPremium: false,
      // TODO Add Default Photo to assets
      photoUrl:
          'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg',
      displayName: 'Quimify',
      email: 'Quimify@quimify.com',
      birthday: 'EIGHTEEN_TO_TWENTY',
      gender: 'Male');

  static QuimifyIdentity get identity => _identity;

  static List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/user.birthday.read',
    'https://www.googleapis.com/auth/user.gender.read'
  ];

  static Future<void> signOut() async {
    if (_googleSignIn.currentUser != null) await _googleSignIn.signOut();
  }

  // Donde va la logica de cada tipo de autenticación
  static Future<QuimifyIdentity?> signInGoogleUser() async {
    final user = await _googleSignIn.signIn();
    if (user == null) return null;
    return await postLogin(AuthProviders.google, user, null);
  }

  static Future<QuimifyIdentity?> signInAnonymousUser() async {
    return await postLogin(AuthProviders.none, null, null);
  }

  // TODO: Hacer la petición POST /login(id)
  static Future<QuimifyIdentity> postLogin(AuthProviders service,
      GoogleSignInAccount? googleUser, AppleIdentity? appleUser) async {
    switch (service) {
      case AuthProviders.google:
        if (googleUser != null) {
          var data = await getInfoGoogle(googleUser);
          // At the moment, returning default QuimifyIdentity
          _identity = QuimifyIdentity(
              isPremium: false,
              googleUser: googleUser,
              photoUrl: googleUser.photoUrl ??
                  'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg',
              displayName: googleUser.displayName ?? 'Quimify',
              email: googleUser.email,
              gender: data['gender'],
              birthday: data['birthday']);
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
    //TODO: At the moment, only works with GooglwSignIn
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

enum AuthProviders { google, apple, none }
