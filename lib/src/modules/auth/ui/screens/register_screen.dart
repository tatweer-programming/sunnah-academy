import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/auth/cubit/auth_cubit.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/student_creation_form.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/date_picker_field.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../widgets/auth_header.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedBirthDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.length < 2) {
      return 'الاسم يجب أن يكون أكثر من حرفين';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != _passwordController.text) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'الجنس مطلوب';
    }
    return null;
  }

  String? _validateBirthDate(String? value) {
    if (_selectedBirthDate == null) {
      return 'تاريخ الميلاد مطلوب';
    }

    final age = DateTime.now().difference(_selectedBirthDate!).inDays / 365;
    if (age < 13) {
      return 'يجب أن يكون العمر 13 سنة على الأقل';
    }
    if (age > 100) {
      return 'تاريخ الميلاد غير صحيح';
    }
    return null;
  }

  void _handleRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final creationForm = StudentCreationForm(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phoneNumber: _phoneController.text.trim(),
        gender: _selectedGender!,
        birthDate: _selectedBirthDate!.toIso8601String().split('T')[0],
      );

      AuthCubit.instance.register(creationForm);
    }
  }

  List<DropdownMenuItem<String>> _getGenderItems(BuildContext context) {
    return [
      DropdownMenuItem(
        value: 'male',
        child: Text('ذكر'),
      ),
      DropdownMenuItem(
        value: 'female',
        child: Text('أنثى'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AuthCubit.instance,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is AuthLoading;
            });

            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إنشاء الحساب بنجاح'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
              context.pop();
            } else if (state is AuthError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          child: LoadingOverlay(
            isLoading: _isLoading,
            message: 'جاري إنشاء الحساب...',
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      AuthHeader(
                        title: 'إنشاء حساب جديد',
                        subtitle: 'انضم إلينا وابدأ رحلتك التعليمية',
                      ),

                      // الاسم
                      CustomTextField(
                        label: 'الاسم كاملاً',
                        hint: 'أدخل اسمك كاملاً',
                        prefixIcon: Icons.person_outline,
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: _validateName,
                      ),

                      const SizedBox(height: 20),

                      // البريد الإلكتروني
                      CustomTextField(
                        label: 'البريد الإلكتروني',
                        hint: 'أدخل بريدك الإلكتروني',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'رقم الهاتف',
                        hint: 'أدخل رقم هاتفك',
                        prefixIcon: Icons.phone_outlined,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),

                      const SizedBox(height: 20),

                      CustomDropdown<String>(
                        label: 'الجنس',
                        hint: 'اختر الجنس',
                        prefixIcon: Icons.person_pin_outlined,
                        value: _selectedGender,
                        items: _getGenderItems(context),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: _validateGender,
                      ),

                      const SizedBox(height: 20),

                      DatePickerField(
                        label: 'تاريخ الميلاد',
                        hint: 'اختر تاريخ ميلادك',
                        prefixIcon: Icons.cake_outlined,
                        selectedDate: _selectedBirthDate,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedBirthDate = date;
                          });
                        },
                        validator: _validateBirthDate,
                        firstDate: DateTime(1920),
                        lastDate:
                            DateTime.now().subtract(Duration(days: 365 * 13)),
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'كلمة المرور',
                        hint: 'أدخل كلمة مرور قوية',
                        prefixIcon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'تأكيد كلمة المرور',
                        hint: 'أعد إدخال كلمة المرور',
                        prefixIcon: Icons.lock_outline,
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: _validateConfirmPassword,
                      ),

                      const SizedBox(height: 32),

                      CustomButton(
                        text: 'إنشاء الحساب',
                        onPressed: () {
                          _handleRegister(context);
                        },
                        isLoading: _isLoading,
                        width: double.infinity,
                        height: 52,
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: theme.dividerTheme.color,
                              thickness: theme.dividerTheme.thickness,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'أو',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: theme.dividerTheme.color,
                              thickness: theme.dividerTheme.thickness,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      CustomButton(
                        text: 'لديك حساب بالفعل؟ سجل دخولك',
                        type: ButtonType.text,
                        onPressed: () {
                          context.pop();
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
