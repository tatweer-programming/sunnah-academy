import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:hydrated_bloc/hydrated_bloc.dart'
    show HydratedBloc, HydratedStorageDirectory, HydratedStorage;
import 'package:path_provider/path_provider.dart';
import 'package:sunnah_academy/src/core/apis/api.dart' show ApiManager;
import 'package:sunnah_academy/src/core/apis/dio_helper.dart';
import 'package:sunnah_academy/src/core/services/dep_injection.dart'
    show ServiceLocator;
import 'package:sunnah_academy/src/core/services/secure_storage_helper.dart';
import 'package:sunnah_academy/src/modules/main/ui/screens/main_screen.dart';

import '../../modules/auth/ui/screens/login_screen.dart';
import '../debugging/app_logger.dart';

class AppInitializer {
  static void initializeServiceLocator() {
    ServiceLocator.init();
  }

  static Future<void> initializeHydratedStorage() async {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );
  }

  static Future<Widget> init() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    DioHelper.init();
    AppLogger.init();
    SecureStorageHelper.init();
    await _getSavedData();
    if (ApiManager.authToken != null) {
      DioHelper.setToken(ApiManager.authToken!);

      return MainScreen();
    } else {
      return LoginScreen();
    }
  }

  static Future<void> _getSavedData() async {
    try {
      var authInfo = await SecureStorageHelper.getData(key: "auth_info");
      if (authInfo != null || authInfo != "") {
        ApiManager.authToken = authInfo['token'];
        ApiManager.userId = authInfo['id'];
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> saveFirstRunFlag() async {}
}
