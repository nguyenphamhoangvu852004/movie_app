import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/data/AuthResult.dart';

abstract class AuthRepo {
  User? get currentUser;
  Stream<User?> get authStateChanges;
  Future<AuthResult> signInWithEmailAndPassword({required String email, required String password});
  Future<AuthResult> createUserWithEmailAndPassword({required String email, required String password});
  Future<AuthResult?> loginWithGoogle();
  Future<void> signOut();
}
