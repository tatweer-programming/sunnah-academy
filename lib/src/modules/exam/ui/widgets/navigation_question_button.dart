import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum NavigationType {
  next,
  previous,
  finish,
}

class NavigationButton extends StatelessWidget {
  final NavigationType? navigationType;
  final VoidCallback? onPressed;

  const NavigationButton({
    super.key,
    required this.navigationType,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return navigationType == null
        ? const SizedBox()
        : Align(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(
                  _getIcon(),
                  color: Colors.white,
                  size: 18.sp,
                ),
                label: Text(
                  _getTextButton(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: navigationType == NavigationType.finish
                        ? Colors.green.shade600
                        : Colors.blue.shade600,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: navigationType == NavigationType.finish
                        ? Colors.green.shade200
                        : Colors.blue.shade200),
              ),
            ),
          );
  }

  IconData _getIcon() {
    if (navigationType == NavigationType.next) {
      return Icons.arrow_forward_rounded;
    } else if (navigationType == NavigationType.previous) {
      return Icons.arrow_back_rounded;
    } else {
      return Icons.send_rounded;
    }
  }

  String _getTextButton() {
    if (navigationType == NavigationType.next) {
      return 'السؤال القادم';
    } else if (navigationType == NavigationType.previous) {
      return 'السؤال السابق';
    } else {
      return 'انهاء الامتحان';
    }
  }
}
