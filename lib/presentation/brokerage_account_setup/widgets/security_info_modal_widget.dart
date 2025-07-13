import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityInfoModalWidget extends StatelessWidget {
  const SecurityInfoModalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 3.h),
            _buildSecurityFeatures(),
            SizedBox(height: 3.h),
            _buildPermissionsSection(),
            SizedBox(height: 3.h),
            _buildCloseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security & Privacy',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Learn how we protect your trading data and API credentials.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityFeatures() {
    final List<Map<String, dynamic>> securityFeatures = [
      {
        "icon": "security",
        "title": "End-to-End Encryption",
        "description":
            "All API credentials are encrypted using AES-256 encryption before storage.",
      },
      {
        "icon": "fingerprint",
        "title": "Biometric Authentication",
        "description":
            "Access your trading account using fingerprint or face recognition.",
      },
      {
        "icon": "vpn_lock",
        "title": "Secure API Communication",
        "description":
            "All broker API calls use HTTPS with certificate pinning for maximum security.",
      },
      {
        "icon": "shield",
        "title": "Local Storage Only",
        "description":
            "Your credentials are stored locally on your device, never on our servers.",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Features',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: securityFeatures.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final feature = securityFeatures[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: feature["icon"],
                    color: AppTheme.getSuccessColor(true),
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature["title"],
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        feature["description"],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPermissionsSection() {
    final List<Map<String, dynamic>> permissions = [
      {
        "permission": "Read Portfolio",
        "description": "View your holdings, positions, and account balance",
        "required": true,
      },
      {
        "permission": "Place Orders",
        "description": "Execute buy/sell orders on your behalf",
        "required": true,
      },
      {
        "permission": "Market Data",
        "description": "Access real-time and historical market data",
        "required": true,
      },
      {
        "permission": "Modify Orders",
        "description": "Update or cancel existing orders",
        "required": false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Permissions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'The following permissions are requested from your broker:',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: permissions.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
          itemBuilder: (context, index) {
            final permission = permissions[index];
            return Row(
              children: [
                CustomIconWidget(
                  iconName:
                      permission["required"] ? 'check_circle' : 'info_outline',
                  color: permission["required"]
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            permission["permission"],
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (permission["required"]) ...[
                            SizedBox(width: 1.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.w, vertical: 0.2.h),
                              decoration: BoxDecoration(
                                color: AppTheme.getErrorColor(true)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Required',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontSize: 10.sp,
                                  color: AppTheme.getErrorColor(true),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        permission["description"],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Got it',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
