import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    final email = user?.email;

    if (user == null || email == null || email.isEmpty) {
      throw const AuthServiceException('Sessao de autenticacao invalida.');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> deleteCurrentUser() async {
    await _firebaseAuth.currentUser?.delete();
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<String> currentIdToken() async {
    final user = _firebaseAuth.currentUser;
    final idToken = await user?.getIdToken();

    if (idToken == null || idToken.isEmpty) {
      throw const AuthServiceException('Sessao de autenticacao invalida.');
    }

    return idToken;
  }
}

class AuthServiceException implements Exception {
  const AuthServiceException(this.message);

  final String message;
}
