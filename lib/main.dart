import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/apis/dio_helper.dart';
import 'package:sunnah_academy/src/core/debugging/app_logger.dart';
import 'package:sunnah_academy/src/core/debugging/loggable.dart';
import 'package:sunnah_academy/src/core/utils/theme_manager.dart';
import 'package:sunnah_academy/src/modules/auth/cubit/auth_cubit.dart';
import 'package:sunnah_academy/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:sunnah_academy/src/modules/auth/data/services/auth_local_services.dart';
import 'package:sunnah_academy/src/modules/auth/data/services/auth_remote_services.dart';
import 'package:sunnah_academy/src/modules/subjects/ui/widgets/subject_card.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();

  AppLogger.init();
  TestRandom().getRandomNumber();

  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://9ba81b3b0c38fa93b8df359699e394b3@o4509670649823232.ingest.de.sentry.io/4509670866485328';
        options.sendDefaultPii = true;
      },
      appRunner: () => runApp(
        SentryWidget(
          child: MyApp(),
        ),
      ),
    );
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        AuthRepository(AuthRemoteServices(), AuthLocalServices()),
      )..login("mahmoud", "123456"),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Sizer(builder: (context, orientation, deviceType) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitDown,
            ]);
            return MaterialApp(
              title: 'Theme Test App',
              theme: AppTheme.lightTheme,
              locale: const Locale(
                'ar',
              ),
              supportedLocales: const [
                Locale('ar', ''),
              ],
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: TestSubjectCardScreen(),
              debugShowCheckedModeBanner: false,
            );
          });
        },
      ),
    );
  }
}

class TestRandom {
  int getRandomNumber() {
    logInfo("Generating random number");
    return DateTime.now().millisecondsSinceEpoch % 1000;
  }
}
