import 'package:flutter/material.dart';
import 'package:sunnah_academy/src/core/widgets/image_builders.dart';

import '../../../../core/utils/assets_manager.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.08),
        // اللوجو
        Container(
          width: 120,
          height: 120,
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
        ),
        const SizedBox(height: 32),
        // العنوان
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // العنوان الفرعي
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
