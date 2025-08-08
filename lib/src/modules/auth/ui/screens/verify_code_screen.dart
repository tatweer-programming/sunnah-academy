import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/modules/auth/cubit/auth_cubit.dart';
import 'package:sunnah_academy/src/modules/auth/ui/screens/reset_password_screen.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../widgets/auth_header.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  late AuthCubit authCubit;
  final OtpFieldController _otpController = OtpFieldController();
  String _verificationCode = '';
  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    authCubit = AuthCubit.instance;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  bool _isCodeComplete() {
    return _verificationCode.length == 6;
  }

  void _handleVerifyCode(BuildContext context) {
    if (_isCodeComplete()) {
      // التأكد من أن الـ Cubit ليس مغلق قبل استخدامه
      if (authCubit.isClosed) {
        authCubit = AuthCubit.instance;
      }
      authCubit.verifyCode(_verificationCode);
    }
  }

  void _handleResendCode(BuildContext context) {
    if (_canResend) {
      // التأكد من أن الـ Cubit ليس مغلق قبل استخدامه
      if (authCubit.isClosed) {
        authCubit = AuthCubit.instance;
      }
      authCubit.forgotPassword(widget.email);
      _startResendTimer();
      // مسح الـ OTP field عند إعادة الإرسال
      _otpController.clear();
      setState(() {
        _verificationCode = '';
      });
    }
  }

  void _onOtpCompleted(String pin) {
    setState(() {
      _verificationCode = pin;
    });
    // التحقق تلقائياً عند اكتمال الكود
    if (pin.length == 6) {
      _handleVerifyCode(context);
    }
  }

  void _onOtpChanged(String pin) {
    setState(() {
      _verificationCode = pin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: authCubit,
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
            print('Current state: ${state.runtimeType}'); // للتطوير فقط

            if (state is AuthLoading) {
              setState(() {
                _isLoading = true;
              });
            } else {
              setState(() {
                _isLoading = false;
              });
            }

            if (state is CodeVerificationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم التحقق من الرمز بنجاح'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );

              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  context.pushReplacement(ResetPasswordScreen());
                }
              });
            } else if (state is ForgotPasswordEmailSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إعادة إرسال رمز التحقق'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            } else if (state is AuthError) {
              // مسح الـ OTP field في حالة الخطأ
              _otpController.clear();
              setState(() {
                _verificationCode = '';
              });
              ExceptionManager.showMessage(state.exception);
            }
          },
          child: LoadingOverlay(
            isLoading: _isLoading,
            message: 'جاري التحقق من الرمز...',
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 4.h),

                    // Header
                    AuthHeader(
                      title: 'تحقق من رمز التفعيل',
                      subtitle:
                          'أدخل الرمز المكون من 6 أرقام المرسل إلى\n${widget.email}',
                    ),

                    SizedBox(height: 6.h),

                    // Security icon
                    Center(
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.security,
                          size: 10.w,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // OTP Text Field
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: OTPTextField(
                        controller: _otpController,
                        length: 6,
                        width: 100.w,
                        fieldWidth: 12.w,
                        style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ) ??
                            TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                        textFieldAlignment: MainAxisAlignment.spaceEvenly,
                        fieldStyle: FieldStyle.box,
                        otpFieldStyle: OtpFieldStyle(
                          backgroundColor: theme.colorScheme.surface,
                          borderColor: theme.colorScheme.outline,
                          focusBorderColor: theme.colorScheme.primary,
                          enabledBorderColor: theme.colorScheme.outline,
                          disabledBorderColor:
                              theme.colorScheme.outline.withOpacity(0.5),
                          errorBorderColor: theme.colorScheme.error,
                        ),
                        onChanged: _onOtpChanged,
                        onCompleted: _onOtpCompleted,
                        keyboardType: TextInputType.number,
                        spaceBetween: 2.w,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'تحقق من الرمز',
                          onPressed: _isCodeComplete() && !_isLoading
                              ? () => _handleVerifyCode(context)
                              : null,
                          isLoading: _isLoading,
                          width: double.infinity,
                          height: 6.5.h,
                        );
                      },
                    ),

                    SizedBox(height: 3.h),

                    Center(
                      child: Column(
                        children: [
                          Text(
                            'لم تستلم الرمز؟',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          TextButton(
                            onPressed: _canResend && !_isLoading
                                ? () => _handleResendCode(context)
                                : null,
                            child: Text(
                              _canResend
                                  ? 'إعادة إرسال الرمز'
                                  : 'إعادة إرسال الرمز خلال ($_resendTimer) ثانية',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _canResend && !_isLoading
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Center(
                      child: TextButton(
                        onPressed: !_isLoading ? () => context.pop() : null,
                        child: Text(
                          'تغيير البريد الإلكتروني',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: !_isLoading
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.4),
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
    );
  }
}
