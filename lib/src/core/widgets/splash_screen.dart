import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/widgets/image_builders.dart';

import '../services/app_initializer.dart';
import '../utils/assets_manager.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSplashScreen.withScreenFunction(
      screenFunction: () async {
        return await AppInitializer.init();
      },
      duration: 3000,
      splashIconSize: _calculateSplashIconSize(context),
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      curve: Curves.bounceIn,
      splash: _buildSplashLogo(context, colorScheme),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: colorScheme.surface,
    );
  }

  double _calculateSplashIconSize(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final shortestSide = screenSize.shortestSide;

    double iconSize = shortestSide * 0.6;

    iconSize = iconSize.clamp(200.w, 300.w);

    return iconSize;
  }

  Widget _buildSplashLogo(BuildContext context, ColorScheme colorScheme) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Image.asset(
          errorBuilder: defaultImageErrorBuilder,
          AssetsManager.logo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
