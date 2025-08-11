import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunnah_academy/src/core/error/exception_manager.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/core/widgets/core_widgets.dart';
import 'package:sunnah_academy/src/core/widgets/custom_button.dart';
import 'package:sunnah_academy/src/modules/student/cubit/student_cubit.dart';
import 'package:sunnah_academy/src/modules/student/data/models/student.dart';
import 'package:sunnah_academy/src/modules/student/ui/screens/edit_profile_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late StudentCubit _studentCubit;

  @override
  void initState() {
    super.initState();
    _studentCubit = StudentCubit.instance;
    _studentCubit.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _studentCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الملف الشخصي'),
          automaticallyImplyLeading: false,
          actions: [
            BlocBuilder<StudentCubit, StudentState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.edit),
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
            } else if (state is UpdateProfileSuccess) {
              // Refresh profile data after successful update
              _buildProfileContent(context, state.student);
            }
          },
          builder: (context, state) {
            if (state is GetProfileLoading) {
              return const CustomLoadingWidget();
            } else if (state is StudentError) {
              return CustomErrorWidget(
                exception: state.error,
              );
            } else if (state is GetProfileSuccess) {
              return _buildProfileContent(context, state.student);
            }
            return const CustomLoadingWidget();
          },
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, Student student) async {
    final result = await context.push(
      BlocProvider.value(
        value: _studentCubit,
        child: EditProfileScreen(student: student),
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
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                    const SizedBox(height: 16.0),
                    Text(
                      student.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
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

            const SizedBox(height: 20.0),

            // Profile Information
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المعلومات الشخصية',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildInfoRow(
                      context,
                      'رقم الهاتف',
                      student.phoneNumber ?? 'غير محدد',
                      Icons.phone,
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(
                      context,
                      'الجنس',
                      student.gender ?? 'غير محدد',
                      Icons.person_outline,
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(
                      context,
                      'تاريخ الميلاد',
                      student.birthDate ?? 'غير محدد',
                      Icons.cake,
                    ),
                    const SizedBox(height: 12.0),
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

            const SizedBox(height: 20.0),

            // Edit Profile Button
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
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
        const SizedBox(width: 12.0),
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
              const SizedBox(height: 2.0),
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
}
