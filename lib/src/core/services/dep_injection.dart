import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    _initializeRemoteServices();
    _initializeLocalServices();
    _initializeRepositories();
    _initializeBlocs();
  }

  static void _initializeBlocs() {}

  static void _initializeRemoteServices() {}

  static void _initializeLocalServices() {}

  static void _initializeRepositories() {}
}
