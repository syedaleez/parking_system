import 'package:get_it/get_it.dart';
import 'package:parking_system/repository/auth_repository.dart';
import 'package:parking_system/repository/user_repository.dart';
import 'package:parking_system/repository/admin_repository.dart';
import '../logic/admin/admin_cubit.dart';
import '../logic/user/user_cubit.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register Repositories..
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<AdminRepository>(() => AdminRepository());

  // Register Cubits..
  locator.registerFactory(() => UserCubit(locator<UserRepository>()));
  locator.registerFactory(() => AdminCubit(locator<AdminRepository>()));
}
