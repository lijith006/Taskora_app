import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskora/data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  AuthBloc(this._repo) : super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLoginWithGoogle>(_onGoogleLogin);
    on<AuthLoginWithEmail>(_onEmailLogin);
    on<AuthSignUpWithEmail>(_onEmailSignUp);
    on<AuthLoggedOut>(_onLogout);
  }

  Future<void> _onAppStarted(AuthAppStarted _, Emitter<AuthState> emit) async {
    final user = _repo.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGoogleLogin(
    AuthLoginWithGoogle _,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading(googleLoading: true)); //  shows loading
      final user = await _repo.signInWithGoogle();

      if (user == null) {
        emit(const AuthFailure('Google sign-in cancelled'));
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onEmailLogin(
    AuthLoginWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading(emailLoading: true)); // only email button loading
      final user = await _repo.signInWithEmail(event.email, event.password);

      if (user == null) {
        emit(const AuthFailure('Login failed'));
      } else {
        emit(AuthAuthenticated(user));
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Email is invalid';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled';
          break;
        default:
          message = e.message ?? 'Login failed';
      }
      emit(AuthFailure(message));
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onEmailSignUp(
    AuthSignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = await _repo.signUpWithEmail(event.email, event.password);
      if (user == null) {
        emit(const AuthFailure('Signup failed'));
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(AuthLoggedOut _, Emitter<AuthState> emit) async {
    await _repo.signOut();
    emit(AuthUnauthenticated());
  }
}
