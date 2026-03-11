import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (_) {
      return Stream.value(null);
    }
  }

  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      throw Exception('Only @gmail.com accounts are allowed to use this app.');
    }
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> loginWithEmail(String email, String password) async {
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      throw Exception('Only @gmail.com accounts are allowed to use this app.');
    }
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final credential = await _auth.signInWithPopup(googleProvider);

      if (credential.user != null &&
          !credential.user!.email!.toLowerCase().endsWith('@gmail.com')) {
        await credential.user!
            .delete(); // Delete the mistakenly created Firebase Auth user
        await _auth.signOut();
        throw Exception(
          'Only @gmail.com accounts are allowed to use this app.',
        );
      }

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
