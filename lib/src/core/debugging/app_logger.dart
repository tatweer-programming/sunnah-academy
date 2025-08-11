import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:sunnah_academy/src/core/apis/dio_helper.dart';

import 'bloc_observer.dart';

/// this class created to easily debug the app
///  it used to observe the app's state and behavior
///  in it we can observe all blocs , repositories, services, and logical flow

class AppLogger {
  static void init() {
    if (kDebugMode) {
      Bloc.observer = MyBlocObserver();
      DioHelper
          .addLogger(); // Add logger to DioHelper to log all HTTP requests and responses
    }
  }
}
