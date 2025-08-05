import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
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
          ),
          dropdownColor: theme.colorScheme.surface,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.iconTheme.color,
          ),
        ),
      ],
    );
  }
}
