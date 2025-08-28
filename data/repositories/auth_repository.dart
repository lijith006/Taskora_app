import 'package:firebase_auth/firebase_auth.dart';
import '../data_sources/auth_service.dart';

abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  User? get currentUser;
  Stream<User?> authStateChanges();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;
  AuthRepositoryImpl(this._service);

  @override
  Future<User?> signInWithGoogle() => _service.signInWithGoogle();

  @override
  Future<User?> signInWithEmail(String email, String password) =>
      _service.signInWithEmail(email, password);

  @override
  Future<User?> signUpWithEmail(String email, String password) =>
      _service.signUpWithEmail(email, password);

  @override
  Future<void> signOut() => _service.signOut();

  @override
  User? get currentUser => _service.currentUser;

  @override
  Stream<User?> authStateChanges() => _service.authStateChanges();
}
