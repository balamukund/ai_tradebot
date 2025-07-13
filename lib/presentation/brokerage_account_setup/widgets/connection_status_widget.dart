import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;

  const ConnectionStatusWidget({
    Key? key,
    required this.isConnected,
    this.isConnecting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isConnecting) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 3.w,
            height: 3.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            'Connecting',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (isConnected) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.getSuccessColor(true),
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            'Connected',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.getSuccessColor(true),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: 'radio_button_unchecked',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          'Not Connected',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
