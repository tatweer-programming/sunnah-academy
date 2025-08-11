import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF4C9376);
  static const Color accentGold = Color(0xFFCDAA5C);

  static const Color primaryLight = Color(0xFF6BA892);
  static const Color primaryDark = Color(0xFF3A7259);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color background = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkOnBackground = Color(0xFFE1E1E1);
  static const Color darkOnSurface = Color(0xFFE1E1E1);
  static const Color darkError = Color(0xFFCF6679);

  static const Color onPrimary = Colors.white;
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onError = Colors.white;
  static const String fontFamily = 'Cairo';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,

      // نظام الألوان
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary: primaryGreen,
        onPrimary: onPrimary,
        secondary: accentGold,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: onSurface,
        background: background,
        onBackground: onBackground,
        error: error,
        onError: onError,
      ),

      // شريط التطبيق
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: onPrimary,
        elevation: 2,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        titleTextStyle: TextStyle(
          color: onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        iconTheme: IconThemeData(
          color: onPrimary,
          size: 24,
        ),
      ),

      // الأزرار المرفوعة
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: onPrimary,
          elevation: 3,
          shadowColor: primaryGreen.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // الأزرار المحددة
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: BorderSide(color: primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // الأزرار النصية
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // حقول النص
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: error, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIconColor: accentGold,
        suffixIconColor: accentGold,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        color: background,
        elevation: 2,
        shadowColor: primaryGreen.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(8),
      ),

      // الأيقونات
      iconTheme: IconThemeData(
        color: accentGold,
        size: 24,
      ),

      // أزرار الأيقونات
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: accentGold,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),

      // مؤشر التقدم
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryGreen,
        linearTrackColor: primaryGreen.withOpacity(0.2),
        circularTrackColor: primaryGreen.withOpacity(0.2),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),

      // Radio Button
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen;
          }
          return Colors.grey.shade400;
        }),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen.withOpacity(0.5);
          }
          return Colors.grey.shade300;
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryGreen,
        inactiveTrackColor: primaryGreen.withOpacity(0.3),
        thumbColor: primaryGreen,
        overlayColor: primaryGreen.withOpacity(0.2),
        valueIndicatorColor: primaryGreen,
        valueIndicatorTextStyle: TextStyle(
          color: onPrimary,
          fontFamily: fontFamily,
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey.shade600,
        selectedIconTheme: IconThemeData(color: primaryGreen, size: 24),
        unselectedIconTheme:
            IconThemeData(color: Colors.grey.shade600, size: 24),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: primaryGreen,
        unselectedLabelColor: Colors.grey.shade600,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: 16,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        iconColor: accentGold,
        textColor: onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primaryGreen.withOpacity(0.2),
        disabledColor: Colors.grey.shade200,
        labelStyle: TextStyle(
          color: onSurface,
          fontFamily: fontFamily,
        ),
        secondaryLabelStyle: TextStyle(
          color: onPrimary,
          fontFamily: fontFamily,
        ),
        brightness: Brightness.light,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryDark,
        contentTextStyle: TextStyle(fontFamily: 'Cairo', color: onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        behavior: SnackBarBehavior.floating,
        actionTextColor: accentGold,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: onSurface,
          fontSize: 16,
        ),
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w300),
        displayMedium: TextStyle(color: onSurface, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(color: onSurface, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w500),
        headlineMedium:
            TextStyle(color: onSurface, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(color: onSurface, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: onSurface, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: onSurface, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: onSurface, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: onSurface, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: onSurface, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: onSurface, fontWeight: FontWeight.w500),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,

      // نظام الألوان للوضع المظلم
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.dark,
        primary: primaryLight, // استخدام لون أفتح للوضع المظلم
        onPrimary: Colors.black,
        secondary: accentGold,
        onSecondary: Colors.black,
        surface: darkSurface,
        onSurface: darkOnSurface,
        background: darkBackground,
        onBackground: darkOnBackground,
        error: darkError,
        onError: Colors.black,
        surfaceVariant: darkSurfaceVariant,
      ),

      // شريط التطبيق
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        elevation: 2,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        titleTextStyle: TextStyle(
          color: darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        iconTheme: IconThemeData(
          color: accentGold,
          size: 24,
        ),
      ),

      // الأزرار المرفوعة
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: primaryGreen.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // الأزرار المحددة
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          side: BorderSide(color: primaryLight, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // الأزرار النصية
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // حقول النص
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: darkError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: darkError, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade300),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIconColor: accentGold,
        suffixIconColor: accentGold,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(8),
      ),

      // الأيقونات
      iconTheme: IconThemeData(
        color: accentGold,
        size: 24,
      ),

      // أزرار الأيقونات
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: accentGold,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),

      // مؤشر التقدم
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryLight,
        linearTrackColor: primaryLight.withOpacity(0.3),
        circularTrackColor: primaryLight.withOpacity(0.3),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),

      // Radio Button
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen;
          }
          return Colors.grey.shade500;
        }),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen;
          }
          return Colors.grey.shade500;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGreen.withOpacity(0.5);
          }
          return Colors.grey.shade700;
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryLight,
        inactiveTrackColor: primaryLight.withOpacity(0.3),
        thumbColor: primaryLight,
        overlayColor: primaryLight.withOpacity(0.2),
        valueIndicatorColor: primaryGreen,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: fontFamily,
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryLight,
        unselectedItemColor: Colors.grey.shade500,
        selectedIconTheme: IconThemeData(color: primaryLight, size: 24),
        unselectedIconTheme:
            IconThemeData(color: Colors.grey.shade500, size: 24),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: primaryLight,
        unselectedLabelColor: Colors.grey.shade500,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryLight, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade700,
        thickness: 1,
        space: 16,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        iconColor: accentGold,
        textColor: darkOnSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVariant,
        selectedColor: primaryLight.withOpacity(0.3),
        disabledColor: Colors.grey.shade800,
        labelStyle: TextStyle(
          color: darkOnSurface,
          fontFamily: fontFamily,
        ),
        secondaryLabelStyle: TextStyle(
          color: Colors.white,
          fontFamily: fontFamily,
        ),
        brightness: Brightness.dark,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceVariant,
        contentTextStyle: TextStyle(fontFamily: 'Cairo', color: darkOnSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        behavior: SnackBarBehavior.floating,
        actionTextColor: accentGold,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 6,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: darkOnSurface,
          fontSize: 16,
        ),
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w300),
        displayMedium:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w400),
        displaySmall:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w400),
        headlineLarge:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w500),
        headlineMedium:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w500),
        headlineSmall:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w500),
        titleLarge:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w600),
        titleMedium:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w500),
        titleSmall:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: darkOnSurface, fontWeight: FontWeight.w400),
        bodyMedium:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: darkOnSurface, fontWeight: FontWeight.w400),
        labelLarge:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w500),
        labelMedium:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w500),
        labelSmall:
            TextStyle(color: darkOnSurface, fontWeight: FontWeight.w500),
      ),
    );
  }
}
