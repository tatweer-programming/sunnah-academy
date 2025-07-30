import 'package:get_it/get_it.dart';
import 'package:sunnah_academy/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:sunnah_academy/src/modules/auth/data/services/auth_remote_services.dart';
import 'package:sunnah_academy/src/modules/student/data/services/account_remote_services.dart';

import '../../modules/auth/cubit/auth_cubit.dart';
import '../../modules/auth/data/services/auth_local_services.dart';
import '../../modules/student/data/repositories/account_repository.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    _initializeRemoteServices();
    _initializeLocalServices();
    _initializeRepositories();
    _initializeBlocs();
  }

  static void _initializeRemoteServices() {
    sl.registerLazySingleton(() => AuthRemoteServices());
    sl.registerLazySingleton(() => StudentRemoteServices());
  }

  static void _initializeLocalServices() {
    sl.registerLazySingleton(() => AuthLocalServices());
  }

  static void _initializeRepositories() {
    sl.registerLazySingleton(() =>
        AuthRepository(sl<AuthRemoteServices>(), sl<AuthLocalServices>()));
    sl.registerLazySingleton(
        () => StudentRepository(sl<StudentRemoteServices>()));
  }

  static void _initializeBlocs() {
    sl.registerCachedFactory(() => AuthCubit(sl<AuthRepository>()));
  }
}
