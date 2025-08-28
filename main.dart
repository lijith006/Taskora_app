import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taskora/core/constants/app_themes.dart';
import 'package:taskora/core/di/di.dart';
import 'package:taskora/data/data_sources/auth_service.dart';
import 'package:taskora/data/repositories/auth_repository.dart';

import 'package:taskora/presentation/blocs/authentication/bloc/auth_bloc.dart';
import 'package:taskora/presentation/blocs/authentication/bloc/auth_event.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_event.dart';
import 'package:taskora/presentation/screens/auth/login_screen.dart';
import 'package:taskora/presentation/screens/main_screen.dart';
import 'package:taskora/presentation/screens/add_edit_item_screen.dart';
import 'package:taskora/presentation/screens/profile_screen.dart';
import 'package:taskora/presentation/screens/report_screen.dart';
import 'package:taskora/presentation/screens/splash_screen.dart';
import 'package:taskora/presentation/screens/task_detail_screen.dart';
import 'package:taskora/presentation/widgets/auth_decider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initDependencies();

  final authRepo = AuthRepositoryImpl(FirebaseAuthService());
  runApp(MyApp(authRepo: authRepo));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepo;
  const MyApp({required this.authRepo, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepo)..add(AuthAppStarted())),
        BlocProvider(create: (_) => sl<ItemBloc>()..add(ItemsStarted())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taskora',
        theme: AppThemes.light(),
        darkTheme: AppThemes.dark(),
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/decider': (_) => const AuthDecider(),
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const MainScreen(),
          '/add': (_) => const AddEditItemScreen(),
          '/reports': (_) => const ReportsScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/detail': (context) {
            final taskId = ModalRoute.of(context)!.settings.arguments as String;
            return TaskDetailScreen(taskId: taskId);
          },
        },

        initialRoute: '/splash',
      ),
    );
  }
}
