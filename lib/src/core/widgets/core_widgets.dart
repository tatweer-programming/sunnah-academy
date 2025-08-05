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
                height: height != null ? height! * 0.8 : 80.h,
                width: 80.w,
                image: AssetImage(ExceptionManager.getIconPath(exception)),
                fit: BoxFit.contain,
                // color: theme.colorScheme.error,
                colorBlendMode: BlendMode.overlay,
              ),
            ),
            Text(
              ExceptionManager.getMessage(exception),
              style: theme.textTheme.titleMedium?.copyWith(
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
