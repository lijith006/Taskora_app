import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_bloc.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_state.dart';
import 'package:taskora/presentation/screens/main_screen.dart';
import 'package:taskora/presentation/screens/auth/login_screen.dart';

class AuthDecider extends StatelessWidget {
  const AuthDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainScreen();
        } else if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
