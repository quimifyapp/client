import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();

  factory AuthService() => _singleton;

  AuthService._internal();

  // Fields:
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences _prefs;

  static const String _skipLoginKey = 'skip_login';

  bool _isSignedIn = false;
  bool _hasSkippedLogin = false;
  User? _currentUser;
  String? _firstName;
  String? _lastName;
  String? _photoUrl;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Initialize:
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _hasSkippedLogin = _prefs.getBool(_skipLoginKey) ?? false;

      // Set up auth state listener
      _auth.authStateChanges().listen((User? user) async {
        _currentUser = user;
        _isSignedIn = user != null;
        if (user != null) {
          await _fetchOrCreateUserData(user);
          await setSkipLogin(false);
        } else {
          _clearUserInfo();
        }
      });

      // Check if user is already signed in
      _currentUser = _auth.currentUser;
      _isSignedIn = _currentUser != null;
      if (_currentUser != null) {
        await _fetchOrCreateUserData(_currentUser!);
      }
    } catch (e) {
      developer.log('Error initializing AuthService: $e');
    }
  }

  Future<void> _fetchOrCreateUserData(User user) async {
    try {
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // User exists, fetch their data
        final userData = docSnapshot.data() as Map<String, dynamic>;
        _firstName = userData['firstName'];
        _lastName = userData['lastName'];
        _photoUrl = userData['photoUrl'];

        // Update photo URL if it's different
        if (user.photoURL != null && user.photoURL != _photoUrl) {
          _photoUrl = user.photoURL;
          await docRef.update({'photoUrl': _photoUrl});
          developer.log('Updated photo URL for user: ${user.email}');
        }
      } else {
        // New user, handle differently based on provider
        if (user.providerData
            .any((element) => element.providerId == 'apple.com')) {
          // Apple user - we should have this data from sign in
          await docRef.set({
            'firstName': _firstName,
            'lastName': _lastName,
            'email': user.email,
            'photoUrl': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'provider': 'apple.com'
          });
        } else {
          if (user.displayName != null) {
            final nameParts = user.displayName!.split(' ');
            _firstName = nameParts.first;
            _lastName = nameParts.length > 1 ? nameParts.last : null;
          }

          await docRef.set({
            'firstName': _firstName,
            'lastName': _lastName,
            'email': user.email,
            'photoUrl': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'provider': user.providerData.first.providerId
          });
        }
      }
    } catch (e) {
      developer.log('Error managing user data: $e');
    }
  }

  void _clearUserInfo() {
    _firstName = null;
    _lastName = null;
    _currentUser = null;
    _photoUrl = null;
    _isSignedIn = false;
  }

  Future<void> setSkipLogin(bool skip) async {
    try {
      await _prefs.setBool(_skipLoginKey, skip);
      _hasSkippedLogin = skip;
    } catch (e) {
      developer.log('Error setting skip login: $e');
    }
  }

  bool get hasSkippedLogin => _hasSkippedLogin;

  Future<void> _handleError(String operation, dynamic error) async {
    developer.log('Error during $operation: $error');
    if (_currentUser != null) {
      await _auth.signOut();
      await _googleSignIn.signOut();
    }
    _clearUserInfo();
  }

  // Public methods:
  Future<UserCredential?> signInWithGoogle() async {
    try {
      developer.log('Starting Google sign-in process...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        developer.log('User cancelled the sign-in process');
        return null;
      }

      developer.log('Getting Google auth tokens...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null) {
        developer.log('Error: Access token is null');
        return null;
      }

      if (googleAuth.idToken == null) {
        developer.log('Error: ID token is null');
        return null;
      }

      developer.log('Creating Firebase credential...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken!,
        idToken: googleAuth.idToken!,
      );

      developer.log('Signing in to Firebase...');
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      _currentUser = userCredential.user;

      if (_currentUser != null) {
        developer.log('User signed in successfully, fetching user data...');
        await _fetchOrCreateUserData(_currentUser!);
      }

      _isSignedIn = true;

      return userCredential;
    } catch (e) {
      developer.log('Detailed error during Google sign-in: $e');
      if (e is FirebaseAuthException) {
        developer.log('Firebase Auth Error Code: ${e.code}');
        developer.log('Firebase Auth Error Message: ${e.message}');
      }
      await _handleError('Google sign-in', e);
      return null;
    }
  }

  // Sign in with Apple
  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);

      _currentUser = userCredential.user;

      // Check if user exists in Firestore
      final docRef = _firestore.collection('users').doc(_currentUser!.uid);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // This is a new user
        _firstName = appleCredential.givenName;
        _lastName = appleCredential.familyName;

        // Store in Firestore
        await docRef.set({
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _currentUser!.email,
          'photoUrl': _currentUser!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'provider': 'apple.com'
        });

        // Update Firebase display name
        await _currentUser?.updateDisplayName(
            '${_firstName ?? ''} ${_lastName ?? ''}'.trim());
      } else {
        // Existing user, fetch their data
        await _fetchOrCreateUserData(_currentUser!);
      }

      _isSignedIn = true;
      return userCredential;
    } catch (e) {
      developer.log('Apple Sign In Error: ${e.toString()}');
      await _handleError('Apple sign-in', e);
      return null;
    }
  }

  // Had to add rollback function because of firebase doesn't delete the user
  // if they are not signed in recently, so what I did was store the user data
  // then delete their firestore document and then delete their auth user
  // if any error occurs during deleting auth user, I restore the user data
  // the most probably error to occur during deleting user is the recently not
  // signed it, this kind of gives us a safe way to handle it
  Future<bool> deleteAccount() async {
    if (_currentUser == null) return false;

    try {
      // We get and store the user data temporarily
      final docRef = _firestore.collection('users').doc(_currentUser!.uid);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) return false;

      final userData = docSnapshot.data()!;
      final tempUser = Map<String, dynamic>.from(userData);

      // Then Delete Firestore document
      await docRef.delete();

      try {
        // Then Delete authentication user
        await _currentUser!.delete();

        // If it was successful, sign out
        await signOut();
        return true;
      } catch (authError) {
        developer.log('Error deleting auth user: $authError');

        // If it failed, restore the Firestore document
        try {
          await docRef.set(tempUser);
          return false;
        } catch (restoreError) {
          developer.log('Error restoring user data: $restoreError');
        }
        return false;
      }
    } catch (e) {
      developer.log('Error during account deletion: $e');
      return false;
    }
  }

  // Helper methods for Apple Sign In
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      _clearUserInfo();
    } catch (e) {
      await _handleError('sign-out', e);
    }
  }

  // Firestore specific methods
  Future<Map<String, dynamic>?> getUserData() async {
    if (_currentUser == null) return null;

    try {
      final docSnapshot =
          await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      developer.log('Error fetching user data: $e');
      return null;
    }
  }

  // User information getters
  bool get isSignedIn => _isSignedIn;
  User? get currentUser => _currentUser;
  String? get email => _currentUser?.email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get uid => _currentUser?.uid;
  String? get photoUrl => _photoUrl;

  // Get all user info at once
  Map<String, String?> get userInfo => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'uid': uid,
        'photoUrl': photoUrl,
      };
}
