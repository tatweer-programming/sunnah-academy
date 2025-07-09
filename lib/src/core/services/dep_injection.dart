import 'package:get_it/get_it.dart';
import 'package:sunnah_academy/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:sunnah_academy/src/modules/auth/data/services/auth_remote_services.dart';

import '../../modules/auth/data/services/auth_local_services.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    _initializeRemoteServices();
    _initializeLocalServices();
    _initializeRepositories();
  }

  static void _initializeRemoteServices() {
    sl.registerLazySingleton(() => AuthRemoteServices());
  }

  static void _initializeLocalServices() {
    sl.registerLazySingleton(() => AuthLocalServices());
  }

  static void _initializeRepositories() {
    sl.registerLazySingleton(() =>
        AuthRepository(sl<AuthRemoteServices>(), sl<AuthLocalServices>()));
  }
}
