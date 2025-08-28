// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskora/presentation/blocs/authentication/bloc/auth_bloc.dart';
// import 'package:taskora/presentation/blocs/authentication/bloc/auth_event.dart';
// import 'package:taskora/presentation/blocs/authentication/bloc/auth_state.dart';
// import 'package:taskora/presentation/widgets/custom_button.dart';
// import 'package:taskora/presentation/widgets/custom_text_form_field.dart';
// import 'package:taskora/presentation/widgets/validators.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_icons.dart';
// import '../../../core/constants/app_strings.dart';
// import '../../../core/constants/app_styles.dart';

// import 'signup_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: BlocListener<AuthBloc, AuthState>(
//           listener: (context, state) {
//             if (state is AuthAuthenticated) {
//               // Show success snackbar
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Login successful!')),
//               );
//               // Navigate to home
//               Navigator.of(context).pushReplacementNamed('/home');
//             } else if (state is AuthFailure) {
//               //snackbar
//               ScaffoldMessenger.of(context).clearSnackBars();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                   duration: const Duration(seconds: 3),
//                 ),
//               );
//             }
//           },
//           // child: BlocListener<AuthBloc, AuthState>(
//           //   listener: (context, state) {
//           //     if (state is AuthAuthenticated) {
//           //       Navigator.of(context).pushReplacementNamed('/home');
//           //     } else if (state is AuthFailure) {
//           //       ScaffoldMessenger.of(
//           //         context,
//           //       ).showSnackBar(SnackBar(content: Text(state.message)));
//           //     }
//           //   },
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: MediaQuery.of(context).size.height - 40,
//                 //  content stretches to fill screen
//               ),
//               child: IntrinsicHeight(
//                 //  Column fill available height
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 40),
//                     Text(AppStrings.appName, style: AppStyles.heading),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Welcome back! Sign in to continue",
//                       style: AppStyles.subtitle,
//                     ),
//                     const SizedBox(height: 40),

//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           CustomTextFormField(
//                             controller: _emailController,
//                             label: "Email",
//                             icon: Icons.email_outlined,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: Validators.email,
//                             autovalidateMode:
//                                 AutovalidateMode.onUserInteraction,
//                           ),
//                           const SizedBox(height: 16),
//                           CustomTextFormField(
//                             controller: _passwordController,
//                             label: "Password",
//                             icon: Icons.lock_outline,
//                             obscureText: true,
//                             validator: Validators.password,
//                             autovalidateMode:
//                                 AutovalidateMode.onUserInteraction,
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     BlocBuilder<AuthBloc, AuthState>(
//                       builder: (context, state) {
//                         final isLoading = state is AuthLoading;
//                         return SizedBox(
//                           width: double.infinity,
//                           child: CustomButton(
//                             text: "Login",
//                             isLoading: isLoading,
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 context.read<AuthBloc>().add(
//                                   AuthLoginWithEmail(
//                                     _emailController.text.trim(),
//                                     _passwordController.text.trim(),
//                                   ),
//                                 );
//                               }
//                             },
//                           ),

//                           //  ElevatedButton(
//                           //   style: AppStyles.primaryButton,
//                           //   onPressed: isLoading
//                           //       ? null
//                           //       : () {
//                           //           if (_formKey.currentState!.validate()) {
//                           //             context.read<AuthBloc>().add(
//                           //               AuthLoginWithEmail(
//                           //                 _emailController.text.trim(),
//                           //                 _passwordController.text.trim(),
//                           //               ),
//                           //             );
//                           //           }
//                           //         },
//                           //   child: isLoading
//                           //       ? const SizedBox(
//                           //           height: 20,
//                           //           width: 20,
//                           //           child: CircularProgressIndicator(
//                           //             strokeWidth: 2,
//                           //             color: Colors.white,
//                           //           ),
//                           //         )
//                           //       : const Text("Login"),
//                           // ),
//                         );
//                       },
//                     ),

//                     const SizedBox(height: 20),

//                     // Google login, sign up link
//                     Row(
//                       children: const [
//                         Expanded(child: Divider()),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           child: Text("OR"),
//                         ),
//                         Expanded(child: Divider()),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     BlocBuilder<AuthBloc, AuthState>(
//                       builder: (context, state) {
//                         final isLoading = state is AuthLoading;
//                         return SizedBox(
//                           width: double.infinity,
//                           child: OutlinedButton.icon(
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               side: BorderSide(color: AppColors.primary),
//                             ),
//                             onPressed: isLoading
//                                 ? null
//                                 : () {
//                                     context.read<AuthBloc>().add(
//                                       AuthLoginWithGoogle(),
//                                     );
//                                   },
//                             icon: Image.asset(
//                               AppIcons.google,
//                               width: 24,
//                               height: 24,
//                             ),
//                             label: isLoading
//                                 ? const CircularProgressIndicator()
//                                 : const Text("Sign in with Google"),
//                           ),
//                         );
//                       },
//                     ),

//                     // const Spacer(),
//                     const SizedBox(height: 40),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Don’t have an account?"),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (_) => const SignupScreen(),
//                               ),
//                             );
//                           },
//                           child: const Text("Sign up"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//************************************** */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_bloc.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_event.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_state.dart';
import 'package:taskora/presentation/widgets/custom_button.dart';
import 'package:taskora/presentation/widgets/custom_text_form_field.dart';
import 'package:taskora/presentation/widgets/validators.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful!')),
              );
              // Navigate to home
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (state is AuthFailure) {
              //snackbar
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          // child: BlocListener<AuthBloc, AuthState>(
          //   listener: (context, state) {
          //     if (state is AuthAuthenticated) {
          //       Navigator.of(context).pushReplacementNamed('/home');
          //     } else if (state is AuthFailure) {
          //       ScaffoldMessenger.of(
          //         context,
          //       ).showSnackBar(SnackBar(content: Text(state.message)));
          //     }
          //   },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 40,
                //  content stretches to fill screen
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(AppStrings.appName, style: AppStyles.heading),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome back! Sign in to continue",
                      style: AppStyles.subtitle,
                    ),
                    const SizedBox(height: 40),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _passwordController,
                            label: "Password",
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: Validators.password,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final emailLoading = state is AuthLoading
                            ? state.emailLoading
                            : false;
                        return SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "Login",
                            isLoading: emailLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthLoginWithEmail(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("OR"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final googleLoading = state is AuthLoading
                            ? state.googleLoading
                            : false;
                        return SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: AppColors.primary),
                            ),
                            onPressed: googleLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                      AuthLoginWithGoogle(),
                                    );
                                  },
                            icon: Image.asset(
                              AppIcons.google,
                              width: 24,
                              height: 24,
                            ),
                            label: googleLoading
                                ? const CircularProgressIndicator()
                                : const Text("Sign in with Google"),
                          ),
                        );
                      },
                    ),

                    // const Spacer(),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text("Sign up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
