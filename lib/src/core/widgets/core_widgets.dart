import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:sunnah_academy/src/core/utils/assets_manager.dart';

import '../error/exception_manager.dart';

class CustomErrorWidget extends StatelessWidget {
  final Exception exception;
  final double? height;

  const CustomErrorWidget({
    super.key,
    required this.exception,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image(
                height: 80.h,
                width: 80.w,
                image: AssetImage(ExceptionManager.getIconPath(exception)),
                fit: BoxFit.contain,
                color: theme.colorScheme.error,
                colorBlendMode: BlendMode.overlay,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              ExceptionManager.getMessage(exception),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: 60.h,
            width: 60.w,
            image: AssetImage(AssetsManager.noDataFound),
          ),
          SizedBox(height: 10.h),
          Text(
            "",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 14.sp,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

class DropDownWidget extends StatefulWidget {
  final String? value;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final String label;
  final List<DropDownItem> items;

  const DropDownWidget({
    super.key,
    this.value,
    this.validator,
    this.onChanged,
    required this.label,
    required this.items,
  });

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      value: widget.value,
      validator: widget.validator,
      style: theme.textTheme.bodyMedium,
      dropdownColor: theme.colorScheme.surface,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: theme.colorScheme.onSurface,
        size: 20.sp,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        hintStyle: theme.inputDecorationTheme.hintStyle,
      ),
      items: widget.items.map((item) {
        return DropdownMenuItem<String>(
          value: item.value,
          child: Row(
            children: [
              if (item.leading != null) ...[
                item.leading!,
                SizedBox(width: 8.w),
              ],
              Expanded(
                child: Text(
                  item.label,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}

class DropDownItem {
  final String value;
  final String label;
  final Widget? leading;

  DropDownItem(
    this.value,
    this.label, {
    this.leading,
  });
}
