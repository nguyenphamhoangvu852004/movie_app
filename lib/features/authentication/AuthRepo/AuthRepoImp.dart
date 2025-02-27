import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/data/AuthResult.dart';
import 'package:movie_app/features/authentication/AuthRepo/AuthRepo.dart';

class AuthRepoImp implements AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(uid: userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e.message);
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

  @override
  Future<AuthResult> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(uid: userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e.message);
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

 @override
  Future<AuthResult> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult(error: "Google Sign-In bị hủy bởi người dùng");
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return AuthResult(uid: userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e.message);
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Đăng xuất Google nếu có
      await _firebaseAuth.signOut(); // Đăng xuất Firebase
    } catch (e) {
      print("Lỗi đăng xuất: $e");
    }
  }
}
