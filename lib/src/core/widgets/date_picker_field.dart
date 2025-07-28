import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
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
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _updateControllerText();
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _updateControllerText();
    }
  }

  void _updateControllerText() {
    if (widget.selectedDate != null) {
      _controller.text = DateFormat('yyyy-MM-dd').format(widget.selectedDate!);
    } else {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          readOnly: true,
          enabled: widget.enabled,
          validator: widget.validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: theme.iconTheme.color,
                  )
                : null,
            suffixIcon: Icon(
              Icons.calendar_today,
              color: theme.iconTheme.color,
            ),
          ),
          onTap: widget.enabled
              ? () async {
                  final DateTime firstDate = widget.firstDate ?? DateTime(1940);
                  final DateTime lastDate = widget.lastDate ?? DateTime.now();

                  if (firstDate.isAfter(lastDate)) {
                    return;
                  }

                  DateTime initialDate;
                  if (widget.selectedDate != null) {
                    if (widget.selectedDate!.isBefore(firstDate)) {
                      initialDate = firstDate;
                    } else if (widget.selectedDate!.isAfter(lastDate)) {
                      initialDate = lastDate;
                    } else {
                      initialDate = widget.selectedDate!;
                    }
                  } else {
                    final now = DateTime.now();
                    if (now.isBefore(firstDate)) {
                      initialDate = firstDate;
                    } else if (now.isAfter(lastDate)) {
                      initialDate = lastDate;
                    } else {
                      initialDate = now;
                    }
                  }

                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
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
                  if (picked != null && widget.onDateSelected != null) {
                    widget.onDateSelected!(picked);
                  }
                }
              : null,
        ),
      ],
    );
  }
}
