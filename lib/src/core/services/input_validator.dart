class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير وصغير ورقم';
    }
    return null;
  }

  static String? validatePasswordForLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.length < 2) {
      return 'الاسم يجب أن يكون أكثر من حرفين';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'الجنس مطلوب';
    }
    return null;
  }

  static String? validateBirthDate(DateTime? selectedBirthDate) {
    if (selectedBirthDate == null) {
      return 'تاريخ الميلاد مطلوب';
    }

    final age = DateTime.now().difference(selectedBirthDate).inDays / 365;
    if (age < 13) {
      return 'يجب أن يكون العمر 13 سنة على الأقل';
    }
    if (age > 100) {
      return 'تاريخ الميلاد غير صحيح';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }
}
