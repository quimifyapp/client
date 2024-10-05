import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quimify_client/internet/api/sign-in/info_google.dart';
import 'package:quimify_client/storage/storage.dart';

class UserAuthService {
  static final _googleSignIn = GoogleSignIn(scopes: scopes);
  static final UserAuthService _instance = UserAuthService();
  static QuimifyIdentity? _user;

  static List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/user.birthday.read',
    'https://www.googleapis.com/auth/user.gender.read'
  ];

  // * Constructor, Singleton pattern
  initialize() async {
    try {
      // Sets ISRG Root X1 certificate, not present in Android < 25
      var certificate = await rootBundle.load('assets/ssl/isrg-x1.crt');
      var bytes = certificate.buffer.asUint8List();
      SecurityContext.defaultContext.setTrustedCertificatesBytes(bytes);
    } catch (_) {} // It's already present in modern devices anyways
  }

  // * Getters

  static UserAuthService getInstance() {
    return _instance;
  }

  static QuimifyIdentity? getUser() {
    return _user;
  }

  static bool loginRequiered() {
    return _instance.hasSkippedLogin() == false &&
        UserAuthService._user == null;
  }

  bool hasSkippedLogin() {
    final prefs = Storage();
    return prefs.getBool('userSkippedLogIn') ?? false;
  }

  // * Methods

  static Future<bool> signOut() async {
    if (_googleSignIn.currentUser != null) await _googleSignIn.signOut();
    final prefs = Storage();
    await prefs.saveBool('isAnonymouslySignedIn', false);
    UserAuthService._user = null;
    return true;
  }

  Future<QuimifyIdentity?> signInGoogleUser() async {
    final user = await _googleSignIn.signIn();
    if (user == null) return null;
    UserAuthService._user = await _signInPOST(user);
    return UserAuthService._user;
  }

  Future<QuimifyIdentity?> signInAnonymousUser() async {
    bool state = await _logInPOST(null);
    final prefs = Storage();
    await prefs.saveBool('isAnonymouslySignedIn', state);
    QuimifyIdentity identity = QuimifyIdentity();
    UserAuthService._user = identity;
    return UserAuthService._user;
  }

  Future<QuimifyIdentity?> handleSilentAuthentication() async {
    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser != null) {
      bool state = await _logInPOST(googleUser);
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

  // * Private Class methods

  // TODO: Implement error handling for login requests
  //
  Future<QuimifyIdentity?> _signInPOST(GoogleSignInAccount googleUser) async {
    var data = await getInfoGoogle(googleUser);
    QuimifyIdentity identity = QuimifyIdentity(
        googleUser: googleUser,
        photoUrl: googleUser.photoUrl,
        displayName: googleUser.displayName ?? 'Quimify',
        email: googleUser.email,
        gender: data['gender'],
        birthday: data['birthday']);
    //format: api.quimify.com/login?id=...&email=...&gender=...&birthday=...
    return identity;
  }

  // TODO: Logic of hhtp request (make sure to handle errors)
  //* Return true if login was successful, false otherwise
  Future<bool> _logInPOST(GoogleSignInAccount? googleUser) async {
    // If user is null, it means that the user is not logged in
    if (googleUser == null) return false;

    // _Important_: Do not use this returned Google ID to communicate the
    /// currently signed in user to your backend server. Instead, send an ID token
    /// which can be securely validated on the server.
    var id = googleUser.authentication.then((value) => value.idToken);
    //formato api.quimify.com/login?id=...&email=...&gender=...&birthday=...
    return true;
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
