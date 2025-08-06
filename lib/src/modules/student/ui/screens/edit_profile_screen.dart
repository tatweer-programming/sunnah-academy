import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/error/exception_manager.dart';
import 'package:sunnah_academy/src/core/routing/navigation_manager.dart';
import 'package:sunnah_academy/src/core/services/input_validator.dart';
import 'package:sunnah_academy/src/core/widgets/core_widgets.dart';
import 'package:sunnah_academy/src/core/widgets/custom_button.dart';
import 'package:sunnah_academy/src/core/widgets/custom_text_field.dart';
import 'package:sunnah_academy/src/core/widgets/date_picker_field.dart';
import 'package:sunnah_academy/src/modules/student/cubit/student_cubit.dart';

import '../../data/models/student.dart';

class EditProfileScreen extends StatefulWidget {
  final Student student;

  const EditProfileScreen({
    super.key,
    required this.student,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController(); // إضافة controller للإيميل

  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.student.name;
    _phoneController.text = widget.student.phoneNumber;
    _emailController.text = widget.student.email; // تهيئة حقل الإيميل

    // Parse birth date
    if (widget.student.birthDate.isNotEmpty) {
      try {
        _selectedBirthDate = DateTime.parse(widget.student.birthDate);
      } catch (e) {
        _selectedBirthDate = null;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose(); // إضافة disposal للإيميل controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => StudentCubit.instance,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تعديل البيانات'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<StudentCubit, StudentState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              showToast('تم تحديث البيانات بنجاح');
              context.pop();
            } else if (state is StudentError) {
              ExceptionManager.showMessage(state.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    // Form Fields
                    Card(
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
                            SizedBox(height: 20.0),

                            // Name Field
                            CustomTextField(
                              label: 'الاسم الكامل',
                              hint: 'أدخل اسمك الكامل',
                              prefixIcon: Icons.person,
                              controller: _nameController,
                              validator: (value) {
                                return InputValidator.validateName(value);
                              },
                            ),

                            SizedBox(height: 16.0),
                            CustomTextField(
                                label: 'البريد الإلكتروني',
                                hint: 'أدخل بريدك الإلكتروني',
                                prefixIcon: Icons.email,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  return InputValidator.validateEmail(value);
                                }),

                            SizedBox(height: 16.0),

                            // Phone Field
                            CustomTextField(
                              label: 'رقم الهاتف',
                              hint: 'أدخل رقم هاتفك',
                              prefixIcon: Icons.phone,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  InputValidator.validatePhone(value),
                            ),

                            SizedBox(height: 16.0),

                            // Birth Date Picker
                            DatePickerField(
                              label: 'تاريخ الميلاد',
                              hint: 'اختر تاريخ الميلاد',
                              prefixIcon: Icons.cake,
                              selectedDate: _selectedBirthDate,
                              firstDate: DateTime(1940),
                              lastDate: DateTime.now().subtract(Duration(
                                  days: 365 * 5)), // At least 5 years old
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedBirthDate = date;
                                });
                              },
                              validator: (value) =>
                                  InputValidator.validateBirthDate(
                                      DateTime.tryParse(value ?? '')),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Account Information (Read-only) - الجنس أصبح للقراءة فقط
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'معلومات الحساب',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            _buildReadOnlyField(
                              context,
                              'الجنس',
                              widget.student.gender == 'male' ? 'ذكر' : 'أنثى',
                              Icons.person_outline,
                            ),
                            SizedBox(height: 12.0),
                            _buildReadOnlyField(
                              context,
                              'المستوى الحالي',
                              'المستوى ${widget.student.currentLevel}',
                              Icons.school,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30.0),

                    // Action Buttons
                    SizedBox(
                      height: 6.h,
                      child: CustomButton(
                        text: 'حفظ التغييرات',
                        icon: Icons.save,
                        isLoading: state is UpdateProfileLoading,
                        onPressed: _saveProfile,
                      ),
                    ),

                    SizedBox(height: 12.0),

                    CustomButton(
                      text: 'إلغاء',
                      type: ButtonType.outlined,
                      icon: Icons.cancel,
                      onPressed: state is UpdateProfileLoading
                          ? null
                          : () => context.pop(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.5),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: theme.iconTheme.color?.withOpacity(0.6),
                size: 20,
              ),
              SizedBox(width: 12.0),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim(); // إضافة الإيميل
      final phoneNumber = _phoneController.text.trim();
      final birthDate = _selectedBirthDate?.toIso8601String().split('T')[0];

      final hasChanges = name != widget.student.name ||
          email != widget.student.email ||
          phoneNumber != widget.student.phoneNumber ||
          birthDate != widget.student.birthDate;

      if (!hasChanges) {
        showToast('لم يتم إجراء أي تعديل');
        return;
      }

      context.read<StudentCubit>().updateProfile(
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            birthDate: birthDate,
          );
    }
  }
}
