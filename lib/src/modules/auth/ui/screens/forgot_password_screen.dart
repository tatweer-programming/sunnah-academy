import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/auth/cubit/auth_cubit.dart';
import 'package:sunnah_academy/src/modules/auth/ui/screens/verify_code_screen.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/services/input_validator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../widgets/auth_header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendCode(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      AuthCubit.instance.forgotPassword(_emailController.text.trim());
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

            if (state is ForgotPasswordEmailSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال رمز التحقق إلى بريدك الإلكتروني'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
              context.pushReplacement(VerifyCodeScreen(
                email: state.email,
              ));
            } else if (state is AuthError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          child: LoadingOverlay(
            isLoading: _isLoading,
            message: 'جاري إرسال رمز التحقق...',
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthHeader(
                        title: 'نسيت كلمة المرور؟',
                        subtitle: 'أدخل بريدك الإلكتروني وسنرسل لك رمز التحقق',
                      ),

                      // Email icon
                      Center(
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.email_outlined,
                            size: 10.w,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),

                      SizedBox(height: 1.h),

                      CustomTextField(
                        label: 'البريد الإلكتروني',
                        hint: 'أدخل بريدك الإلكتروني',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: InputValidator
                            .validateEmail, // استخدام InputValidator
                      ),

                      SizedBox(height: 4.h),

                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: 'إرسال رمز التحقق',
                            onPressed: () {
                              _handleSendCode(context);
                            },
                            isLoading: _isLoading,
                            width: double.infinity,
                            height: 6.5.h,
                          );
                        },
                      ),

                      SizedBox(height: 3.h),

                      Center(
                        child: TextButton(
                          onPressed: () => context.pop(),
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
}
