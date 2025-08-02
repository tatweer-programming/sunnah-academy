import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/apis/api.dart' show ApiManager;
import 'package:sunnah_academy/src/core/apis/dio_helper.dart';
import 'package:sunnah_academy/src/core/services/dep_injection.dart'
    show ServiceLocator;
import 'package:sunnah_academy/src/core/services/secure_storage_helper.dart';
import 'package:sunnah_academy/src/modules/student/ui/screens/profile_page.dart';

import '../../modules/auth/ui/screens/login_screen.dart';
import '../../modules/exam/cubit/exam_cubit.dart';
import '../../modules/exam/data/repositories/exam_repository.dart';
import '../../modules/exam/data/services/exam_remote_services.dart';
import '../../modules/exam/ui/screens/exam_screen.dart';
import '../debugging/app_logger.dart';

class AppInitializer {
  static bool? _isFirstRun;
  static void initializeServiceLocator() {
    ServiceLocator.init();
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
      return  ExamScreen();
    } else {
      return LoginScreen();
    }
  }

  static Future<void> _getSavedData() async {
    try {
      var authInfo = await SecureStorageHelper.getData(key: "auth_info");
      if (authInfo != null) {
        ApiManager.authToken = authInfo['token'];
        ApiManager.userId = authInfo['id'];
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> saveFirstRunFlag() async {}
}
