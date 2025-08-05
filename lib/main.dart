import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/services/app_initializer.dart';
import 'package:sunnah_academy/src/core/utils/theme_manager.dart';
import 'package:sunnah_academy/src/core/widgets/splash_screen.dart';
import 'package:sunnah_academy/src/modules/exam/cubit/exam_cubit.dart';
import 'package:sunnah_academy/src/modules/exam/data/repositories/exam_repository.dart';
import 'package:sunnah_academy/src/modules/exam/data/services/exam_remote_services.dart';
import 'package:sunnah_academy/src/modules/exam/ui/screens/exam_screen.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppInitializer.initializeServiceLocator();

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExamCubit>.value(
          value: ExamCubit(
              examRepository:
                  ExamRepository(remoteServices: ExamRemoteServicesImpl())),
        )
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
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
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
