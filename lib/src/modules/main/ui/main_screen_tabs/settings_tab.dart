import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/core/utils/constants_manager.dart';
import 'package:sunnah_academy/src/core/widgets/core_widgets.dart';
import 'package:sunnah_academy/src/modules/auth/cubit/auth_cubit.dart';
import 'package:sunnah_academy/src/modules/main/cubit/main_cubit.dart';
import 'package:sunnah_academy/src/modules/student/cubit/student_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/ui/screens/login_screen.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late StudentCubit _studentCubit;
  late AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _studentCubit = StudentCubit.instance;
    _authCubit = AuthCubit.instance;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _studentCubit),
        BlocProvider.value(value: _authCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
          automaticallyImplyLeading: false,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<StudentCubit, StudentState>(
              listener: (context, state) {
                if (state is DeleteProfileSuccess) {
                  showToast('تم حذف الحساب بنجاح');
                  context.pushAndRemove(LoginScreen());
                }
              },
            ),
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthInitial) {
                  showToast('تم تسجيل الخروج بنجاح');
                  context.pushAndRemove(LoginScreen());
                } else if (state is AuthError) {
                  showToast('حدث خطأ أثناء تسجيل الخروج');
                }
              },
            ),
          ],
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Theme Settings
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إعدادات المظهر',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      BlocConsumer<MainCubit, MainState>(
                          listener: (BuildContext context, state) {},
                          builder: (context, state) {
                            MainCubit mainCubit = context.read<MainCubit>();
                            return SwitchListTile(
                              title: const Text('الوضع المظلم'),
                              subtitle:
                                  const Text('تبديل بين الوضع المظلم والمضيء'),
                              value: state.isDarkModeEnabled,
                              onChanged: (value) {
                                mainCubit.changeTheme();
                              },
                              secondary: Icon(
                                state.isDarkModeEnabled
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                color: theme.colorScheme.primary,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Contact & Support
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التواصل والدعم',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildContactTile(
                        icon: Icons.email,
                        title: 'البريد الإلكتروني',
                        subtitle: 'تواصل معنا عبر البريد الإلكتروني',
                        onTap: () => _launchEmail(),
                      ),
                      const Divider(),
                      _buildContactTile(
                        icon: Icons.message,
                        title: 'واتساب',
                        subtitle: 'تواصل معنا عبر واتساب',
                        onTap: () => _launchWhatsApp(),
                      ),
                      const Divider(),
                      _buildContactTile(
                        icon: Icons.phone,
                        title: 'الهاتف',
                        subtitle: 'اتصل بنا مباشرة',
                        onTap: () => _launchPhone(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Privacy & Legal
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الخصوصية والقانونية',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildSettingsTile(
                        icon: Icons.privacy_tip,
                        title: 'سياسة الخصوصية',
                        subtitle: 'اطلع على سياسة الخصوصية الخاصة بنا',
                        onTap: () => _launchPrivacyPolicy(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Account Management
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إدارة الحساب',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return _buildSettingsTile(
                            icon: Icons.logout,
                            title: 'تسجيل الخروج',
                            subtitle: 'تسجيل الخروج من الحساب',
                            onTap: () => _showLogoutConfirmationDialog(context),
                            textColor: theme.colorScheme.primary,
                            iconColor: theme.colorScheme.primary,
                          );
                        },
                      ),
                      const Divider(),
                      BlocBuilder<StudentCubit, StudentState>(
                        builder: (context, state) {
                          return _buildSettingsTile(
                            icon: Icons.delete_forever,
                            title: 'حذف الحساب',
                            subtitle: 'حذف حسابك نهائياً',
                            onTap: () => _showDeleteConfirmationDialog(context),
                            textColor: theme.colorScheme.error,
                            iconColor: theme.colorScheme.error,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // URL Launcher Functions
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: ConstantsManager.email,
      query: 'subject=استفسار من تطبيق الأكاديمية',
    );
    await launchUrl(emailUri);
  }

  Future<void> _launchWhatsApp() async {
    const String message = 'السلام عليكم، أحتاج المساعدة في تطبيق الأكاديمية';

    final Uri whatsappUri = Uri.parse(
        'whatsapp://send?phone=${ConstantsManager.whatsAppNumber}&text=${Uri.encodeComponent(message)}');
    await launchUrl(whatsappUri);
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: ConstantsManager.phoneNumber);
    await launchUrl(phoneUri);
  }

  Future<void> _launchPrivacyPolicy() async {
    const String privacyPolicyUrl =
        ConstantsManager.privacyPolicyUrl; // ضع الرابط المناسب
    final Uri uri = Uri.parse(privacyPolicyUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: _authCubit,
          child: AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                const Expanded(child: Text('تأكيد تسجيل الخروج')),
              ],
            ),
            content: Text(
              'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
              style: theme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('إلغاء'),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            context.pop();
                            _authCubit.logout();
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    child: state is AuthLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          )
                        : const Text('تسجيل الخروج'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: _studentCubit,
          child: AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8.0),
                const Expanded(child: Text('تأكيد حذف الحساب')),
              ],
            ),
            content: Text(
              'هل أنت متأكد من رغبتك في حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
              style: theme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('إلغاء'),
              ),
              BlocBuilder<StudentCubit, StudentState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: state is DeleteProfileLoading
                        ? null
                        : () {
                            context.pop();
                            _studentCubit.deleteAccount();
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    child: state is DeleteProfileLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.error,
                              ),
                            ),
                          )
                        : const Text('حذف'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
