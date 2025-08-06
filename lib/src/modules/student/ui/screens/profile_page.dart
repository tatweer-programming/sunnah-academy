import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/error/exception_manager.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/core/widgets/core_widgets.dart';
import 'package:sunnah_academy/src/core/widgets/custom_button.dart';
import 'package:sunnah_academy/src/modules/student/cubit/student_cubit.dart';

import '../../../auth/ui/screens/login_screen.dart';
import '../../data/models/student.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late StudentCubit _studentCubit;

  @override
  void initState() {
    super.initState();
    _studentCubit = StudentCubit.instance;
    _studentCubit.getProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _studentCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الملف الشخصي'),
          actions: [
            BlocBuilder<StudentCubit, StudentState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: state is GetProfileSuccess
                      ? () {
                          _navigateToEditProfile(context, state.student);
                        }
                      : state is UpdateProfileSuccess
                          ? () {
                              _navigateToEditProfile(context, state.student);
                            }
                          : null,
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<StudentCubit, StudentState>(
          listener: (context, state) {
            if (state is StudentError) {
              ExceptionManager.showMessage(state.error);
            } else if (state is DeleteProfileSuccess) {
              showToast('تم حذف الحساب بنجاح');
              context.pushAndRemove(LoginScreen());
            } else if (state is UpdateProfileSuccess) {
              // Refresh profile data after successful update
              _buildProfileContent(context, state.student);
            }
          },
          builder: (context, state) {
            if (state is GetProfileLoading) {
              return CustomLoadingWidget();
            } else if (state is StudentError) {
              return CustomErrorWidget(
                exception: state.error,
              );
            } else if (state is GetProfileSuccess) {
              return _buildProfileContent(context, state.student);
            }
            return CustomLoadingWidget();
          },
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, Student student) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _studentCubit,
          child: EditProfileScreen(student: student),
        ),
      ),
    );

    // If profile was updated, refresh the data
    if (result == true) {
      _studentCubit.getProfile();
    }
  }

  Widget _buildProfileContent(BuildContext context, Student student) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        _studentCubit.refreshProfile();
        // Wait for the operation to complete
        await Future.delayed(Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      student.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      student.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.0),

            // Profile Information
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المعلومات الشخصية',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    _buildInfoRow(
                      context,
                      'رقم الهاتف',
                      student.phoneNumber ?? 'غير محدد',
                      Icons.phone,
                    ),
                    SizedBox(height: 12.0),
                    _buildInfoRow(
                      context,
                      'الجنس',
                      student.gender ?? 'غير محدد',
                      Icons.person_outline,
                    ),
                    SizedBox(height: 12.0),
                    _buildInfoRow(
                      context,
                      'تاريخ الميلاد',
                      student.birthDate ?? 'غير محدد',
                      Icons.cake,
                    ),
                    SizedBox(height: 12.0),
                    _buildInfoRow(
                      context,
                      'المستوى الحالي',
                      'المستوى ${student.currentLevel ?? 'غير محدد'}',
                      Icons.school,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.0),

            // Action Buttons
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton(
                        text: 'تعديل البيانات',
                        icon: Icons.edit,
                        onPressed: () {
                          _navigateToEditProfile(context, student);
                        },
                      ),
                    ),
                    SizedBox(height: 12.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: BlocBuilder<StudentCubit, StudentState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: 'حذف الحساب',
                            type: ButtonType.outlined,
                            icon: Icons.delete_forever,
                            isLoading: state is DeleteProfileLoading,
                            onPressed: () =>
                                _showDeleteConfirmationDialog(context),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.0),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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
                SizedBox(width: 8.0),
                Expanded(child: Text('تأكيد حذف الحساب')),
              ],
            ),
            content: Text(
              'هل أنت متأكد من رغبتك في حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
              style: theme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('إلغاء'),
              ),
              BlocBuilder<StudentCubit, StudentState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: state is DeleteProfileLoading
                        ? null
                        : () {
                            Navigator.of(dialogContext).pop();
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
                        : Text('حذف'),
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
