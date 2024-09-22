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
    return signInPOST(user);
  }

  static Future<QuimifyIdentity?> signInAnonymousUser() async {
    bool state = await logInPOST(null);
    final prefs = Storage();
    await prefs.saveBool('isAnonymouslySignedIn', state);
    QuimifyIdentity identity = QuimifyIdentity();
    return identity;
  }

  Future<bool> hasSkippedLogin() async {
    final prefs = Storage();
    return prefs.getBool('userSkippedLogIn') ?? false;
  }

  // TODO: Implement error handling for login requests
  static Future<QuimifyIdentity?> signInPOST(
      GoogleSignInAccount googleUser) async {
    var data = await getInfoGoogle(googleUser);
    QuimifyIdentity identity = QuimifyIdentity(
        googleUser: googleUser,
        photoUrl: googleUser.photoUrl,
        displayName: googleUser.displayName ?? 'Quimify',
        email: googleUser.email,
        gender: data['gender'],
        birthday: data['birthday']);
    //formato api.quimify.com/login?id=...&email=...&gender=...&birthday=...
    print('Enviado /login');
    //formato api.quimify.com/login?id=...&email=...&gender=...&birthday=...
    return identity;
  }

  // TODO: Logic of hhtp request (make sure to handle errors)
  //* Return true if login was successful, false otherwise
  static Future<bool> logInPOST(GoogleSignInAccount? googleUser) async {
    // If user is null, it means that the user is not logged in
    if (googleUser == null) return false;

    // _Important_: Do not use this returned Google ID to communicate the
    /// currently signed in user to your backend server. Instead, send an ID token
    /// which can be securely validated on the server.
    var id = googleUser.authentication.then((value) => value.idToken);
    //formato api.quimify.com/login?id=...&email=...&gender=...&birthday=...
    print('Enviado /login' + id.toString());
    return true;
  }

  static Future<QuimifyIdentity?> handleSilentAuthentication() async {
    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser != null) {
      bool state = await logInPOST(googleUser);
      QuimifyIdentity identity = QuimifyIdentity(
        googleUser: googleUser,
        photoUrl: googleUser.photoUrl,
        displayName: googleUser.displayName ?? 'Quimify',
        email: googleUser.email,
      );
      return state ? identity : null;
    }
    return null;
  }
}

class QuimifyIdentity {
  final GoogleIdentity? googleUser;
  final String? photoUrl;
  final String? displayName;
  final String? gender;
  final String? email;
  final String? birthday;

  QuimifyIdentity({
    this.googleUser,
    this.photoUrl,
    this.displayName,
    this.email,
    this.gender,
    this.birthday,
  });
}

enum AuthProviders { google, none }
