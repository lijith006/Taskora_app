import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_bloc.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_event.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_state.dart';
import 'package:taskora/presentation/widgets/confirmation_dialogue.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final user = state.user;

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : const AssetImage(
                                      "assets/images/default_user.png",
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.email ?? "No Email",
                          style: AppStyles.heading,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // About
                  ListTile(
                    leading: const Icon(Symbols.info),
                    title: const Text("About"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("About Taskora"),
                          content: const Text(
                            "Taskora is a task management app that helps you stay productive and organized.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Terms & Conditions
                  ListTile(
                    leading: const Icon(Symbols.description),
                    title: const Text("Terms & Conditions"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Terms & Conditions"),
                          content: const Text(
                            "By using Taskora, you agree to our terms and conditions.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Sign Out
                  ListTile(
                    leading: const Icon(Symbols.logout, color: Colors.red),
                    title: const Text("Sign Out"),
                    onTap: () async {
                      final confirm = await ConfirmationDialog.show(
                        context: context,
                        title: "Confirm Sign Out",
                        message: "Are you sure you want to sign out?",
                        confirmText: "Sign Out",
                        confirmColor: Colors.red,
                      );

                      if (confirm == true) {
                        context.read<AuthBloc>().add(AuthLoggedOut());
                        Navigator.of(context).pushReplacementNamed('/login');

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Signed out successfully"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 150),

                  // App Name
                  Center(
                    child: Text(
                      "Taskora",
                      style: TextStyle(
                        fontSize: 28,
                        //fontWeight: FontWeight.bold,
                        color: AppColors.scaffold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 2,
                            color: const Color.fromARGB(
                              255,
                              196,
                              182,
                              182,
                            ).withOpacity(0.2),
                          ),
                          Shadow(
                            offset: Offset(-1, -1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("Not logged in"));
            }
          },
        ),
      ),
    );
  }
}
