import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sunnah_academy/src/core/debugging/loggable.dart';

import '../services/dep_injection.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    logLine("Bloc Created");
    super.onCreate(bloc);
    logInfo("Bloc Created Bloc: ${bloc.runtimeType}");
    logLine("");
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logInfo("Bloc Change: ${bloc.runtimeType} | Change: $change");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logError("Bloc Error", error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    sl.dropScope(bloc.runtimeType.toString());
    super.onClose(bloc);
    debugPrint('---------------BlocClose: ${bloc.runtimeType}');
  }
}
