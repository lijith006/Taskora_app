import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {}

class AuthLoginWithGoogle extends AuthEvent {}

class AuthLoginWithEmail extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginWithEmail(this.email, this.password);
  @override
  List<Object?> get props => [email];
}

class AuthSignUpWithEmail extends AuthEvent {
  final String email;
  final String password;
  final File? profileImage;

  const AuthSignUpWithEmail(this.email, this.password, {this.profileImage});

  @override
  List<Object?> get props => [email, password, profileImage];
}

class AuthLoggedOut extends AuthEvent {}
