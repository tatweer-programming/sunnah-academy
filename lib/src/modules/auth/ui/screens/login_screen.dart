import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/auth/cubit/auth_cubit.dart';
import 'package:sunnah_academy/src/modules/auth/ui/screens/forgot_password_screen.dart';
import 'package:sunnah_academy/src/modules/auth/ui/screens/register_screen.dart';
import 'package:sunnah_academy/src/modules/student/ui/screens/profile_page.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/services/input_validator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      AuthCubit.instance.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _handleForgotPassword() {
    context.push(const ForgotPasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AuthCubit.instance,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is AuthLoading;
            });

            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تسجيل الدخول بنجاح'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
              context.pushAndRemove(ProfileScreen());
            } else if (state is AuthError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          child: LoadingOverlay(
            isLoading: _isLoading,
            message: 'جاري تسجيل الدخول...',
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 4.h),

                        AuthHeader(
                          title: 'أهلاً بك مرة أخرى',
                          subtitle: 'سجل دخولك للمتابعة',
                        ),

                        SizedBox(height: 4.h),
                        CustomTextField(
                          label: 'البريد الإلكتروني',
                          hint: 'أدخل بريدك الإلكتروني',
                          prefixIcon: Icons.email_outlined,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: InputValidator.validateEmail,
                        ),

                        SizedBox(height: 3.h),

                        CustomTextField(
                          label: 'كلمة المرور',
                          hint: 'أدخل كلمة المرور',
                          prefixIcon: Icons.lock_outline,
                          controller: _passwordController,
                          isPassword: true,
                          validator: InputValidator.validatePasswordForLogin,
                          autofillHints: const [AutofillHints.password],
                        ),

                        SizedBox(height: 2.h),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomButton(
                            text: 'نسيت كلمة المرور؟',
                            type: ButtonType.text,
                            onPressed: _handleForgotPassword,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // زر تسجيل الدخول
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: 'تسجيل الدخول',
                              onPressed: () {
                                _handleLogin(context);
                              },
                              isLoading: _isLoading,
                              width: double.infinity,
                              height: 6.5.h,
                            );
                          },
                        ),

                        SizedBox(height: 3.h),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: theme.dividerTheme.color,
                                thickness: theme.dividerTheme.thickness,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
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

                        SizedBox(height: 3.h),

                        CustomButton(
                          text: 'إنشاء حساب جديد',
                          type: ButtonType.outlined,
                          onPressed: () {
                            context.push(const RegisterScreen());
                          },
                          width: double.infinity,
                          height: 6.5.h,
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
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
