import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final DateTime? selectedDate;
  final void Function(DateTime)? onDateSelected;
  final String? Function(String?)? validator;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.selectedDate,
    this.onDateSelected,
    this.validator,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController controller = TextEditingController();

    if (selectedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
    }

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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          enabled: enabled,
          validator: validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: theme.iconTheme.color,
                  )
                : null,
            suffixIcon: Icon(
              Icons.calendar_today,
              color: theme.iconTheme.color,
            ),
          ),
          onTap: enabled
              ? () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: firstDate ?? DateTime(1900),
                    lastDate: lastDate ?? DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: theme.copyWith(
                          colorScheme: theme.colorScheme.copyWith(
                            primary: theme.colorScheme.primary,
                            onPrimary: theme.colorScheme.onPrimary,
                            surface: theme.colorScheme.surface,
                            onSurface: theme.colorScheme.onSurface,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && onDateSelected != null) {
                    onDateSelected!(picked);
                  }
                }
              : null,
        ),
      ],
    );
  }
}
