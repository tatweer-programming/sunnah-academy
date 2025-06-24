import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TarsheedBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _printStars();
    print('onCreate -- ${bloc.runtimeType}');
    _printStars();
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _printStars();
    print('onChange -- ${bloc.runtimeType}, $change');
    _printStars();
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _printStars();

    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
    _printStars();
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _printStars();
    print('onClose -- ${bloc.runtimeType}');
    _printStars();
  }

  void _printStars() {
    debugPrint(
        '*****************************************************************************');
  }
}
