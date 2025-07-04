import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:sunnah_academy/src/core/apis/api.dart' show ApiManager;
import 'package:sunnah_academy/src/core/apis/dio_helper.dart';
import 'package:sunnah_academy/src/core/services/dep_injection.dart'
    show ServiceLocator;

class AppInitializer {
  static bool? _isFirstRun;
  static void initializeServiceLocator() {
    ServiceLocator.init();
  }

  static Future<Widget> init() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    DioHelper.init();
    await _getSavedData();
    if (ApiManager.authToken != null) {
      DioHelper.setToken(ApiManager.authToken!);
    }
    return Container();
  }

  static Future<void> _getSavedData() async {
    try {} catch (e) {
      log(e.toString());
    }
  }

  static Future<void> saveFirstRunFlag() async {}
}
