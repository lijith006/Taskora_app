import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskora/data/data_sources/auth_service.dart';
import 'package:taskora/data/repositories/item_repositort.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import '../../data/data_sources/item_remote_data_source.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../domain/usecases/get_items.dart';
import '../../domain/usecases/mutate_items.dart';

final sl = GetIt.instance;

Future<void> initItemFeature() async {
  // Firestore instance (enable offline is default on mobile)
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data source
  sl.registerLazySingleton<ItemRemoteDataSource>(
    () => ItemRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ItemRepository>(() => ItemRepositoryImpl(sl()));

  // Usecases
  sl.registerFactory(() => WatchItems(sl()));
  sl.registerFactory(() => FetchItemsOnce(sl()));
  sl.registerFactory(() => AddItem(sl()));
  sl.registerFactory(() => UpdateItem(sl()));
  sl.registerFactory(() => DeleteItem(sl()));

  // Bloc
  sl.registerFactory(
    () => ItemBloc(
      watchItems: sl(),
      fetchOnce: sl(),
      addItem: sl(),
      updateItem: sl(),
      deleteItem: sl(),
    ),
  );
}

Future<void> initDependencies() async {
  // Firebase services
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // Auth service
  sl.registerLazySingleton<AuthService>(() => FirebaseAuthService());

  // Features
  await initItemFeature();
}
