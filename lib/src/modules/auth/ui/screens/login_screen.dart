import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/auth/cubit/auth_cubit.dart';
import 'package:sunnah_academy/src/modules/auth/ui/screens/register_screen.dart';

import '../../../../core/error/exception_manager.dart';
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
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى إدخال البريد الإلكتروني أولاً'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    context.read<AuthCubit>().forgotPassword(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AuthCubit.instance,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
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
            } else if (state is AuthError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          child: LoadingOverlay(
            isLoading: _isLoading,
            message: 'جاري تسجيل الدخول...',
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
                        title: 'أهلاً بك مرة أخرى',
                        subtitle: 'سجل دخولك للمتابعة',
                      ),

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
                        label: 'كلمة المرور',
                        hint: 'أدخل كلمة المرور',
                        prefixIcon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: 'نسيت كلمة المرور؟',
                              type: ButtonType.text,
                              onPressed: _handleForgotPassword,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

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
                            height: 52,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // الفاصل
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
                        text: 'إنشاء حساب جديد',
                        type: ButtonType.outlined,
                        onPressed: () {
                          context.push(const RegisterScreen());
                        },
                        width: double.infinity,
                        height: 52,
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
