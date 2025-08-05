import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/auth/cubit/auth_cubit.dart';
import 'package:sunnah_academy/src/modules/auth/ui/screens/login_screen.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/services/input_validator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../widgets/auth_header.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      AuthCubit.instance.resetPassword(_passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AuthCubit.instance,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is AuthLoading;
            });

            if (state is PasswordResetSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تغيير كلمة المرور بنجاح'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
              context.pushAndRemove(
                const LoginScreen(),
              );
            } else if (state is AuthError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          child: LoadingOverlay(
            isLoading: _isLoading,
            message: 'جاري تغيير كلمة المرور...',
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 4.h),

                      // Header
                      AuthHeader(
                        title: 'إعادة تعيين كلمة المرور',
                        subtitle: 'أدخل كلمة المرور الجديدة',
                      ),

                      SizedBox(height: 6.h),

                      // Lock icon
                      Center(
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_reset,
                            size: 10.w,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      CustomTextField(
                        label: 'كلمة المرور الجديدة',
                        hint: 'أدخل كلمة المرور الجديدة',
                        prefixIcon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                        validator: InputValidator.validatePassword,
                        onChanged: (value) => setState(() {}),
                      ),

                      SizedBox(height: 3.h),

                      CustomTextField(
                        label: 'تأكيد كلمة المرور الجديدة',
                        hint: 'أعد إدخال كلمة المرور الجديدة',
                        prefixIcon: Icons.lock_outline,
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: (value) =>
                            InputValidator.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                        onChanged: (value) => setState(() {}),
                      ),

                      SizedBox(height: 2.h),

                      // تنبيه متطلبات كلمة المرور
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'متطلبات كلمة المرور:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            _buildPasswordRequirement(
                              '• 8 أحرف على الأقل',
                              _passwordController.text.length >= 8,
                              theme,
                            ),
                            _buildPasswordRequirement(
                              '• يحتوي على حرف كبير وصغير ورقم',
                              RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                                  .hasMatch(_passwordController.text),
                              theme,
                            ),
                            _buildPasswordRequirement(
                              '• كلمتا المرور متطابقتان',
                              _passwordController.text.isNotEmpty &&
                                  _confirmPasswordController.text.isNotEmpty &&
                                  _passwordController.text ==
                                      _confirmPasswordController.text,
                              theme,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // زر إعادة تعيين كلمة المرور
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: 'إعادة تعيين كلمة المرور',
                            onPressed: () {
                              _handleResetPassword(context);
                            },
                            isLoading: _isLoading,
                            width: double.infinity,
                            height: 6.5.h,
                          );
                        },
                      ),

                      SizedBox(height: 3.h),

                      // رابط العودة لتسجيل الدخول
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.pushAndRemove(
                              const LoginScreen(),
                            );
                          },
                          child: Text(
                            'العودة إلى تسجيل الدخول',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildPasswordRequirement(String text, bool isValid, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 4.w,
            color: isValid
                ? Colors.green
                : theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isValid
                    ? Colors.green
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
