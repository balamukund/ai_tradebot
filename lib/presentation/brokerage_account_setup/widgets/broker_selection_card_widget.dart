import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './connection_status_widget.dart';

class BrokerSelectionCardWidget extends StatelessWidget {
  final Map<String, dynamic> brokerData;
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const BrokerSelectionCardWidget({
    Key? key,
    required this.brokerData,
    required this.isConnected,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected
              ? AppTheme.getSuccessColor(true).withValues(alpha: 0.3)
              : AppTheme.lightTheme.dividerColor,
          width: isConnected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: brokerData["logo"],
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            brokerData["name"],
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ConnectionStatusWidget(
                          isConnected: isConnected,
                          isConnecting: isConnecting,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      brokerData["description"],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildFeaturesList(),
          if (isConnected) ...[
            SizedBox(height: 2.h),
            _buildAccountDetails(),
          ],
          SizedBox(height: 2.h),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: (brokerData["features"] as List).map((feature) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            feature,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAccountDetails() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.getSuccessColor(true).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.getSuccessColor(true).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.getSuccessColor(true),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Account Balance: ${brokerData["accountBalance"]}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getSuccessColor(true),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.getSuccessColor(true),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Trading Permissions: ${(brokerData["tradingPermissions"] as List).join(", ")}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getSuccessColor(true),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (isConnecting) {
      return SizedBox(
        width: double.infinity,
        height: 5.h,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 4.w,
                height: 4.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Connecting...',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 5.h,
      child: isConnected
          ? OutlinedButton(
              onPressed: onDisconnect,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppTheme.getErrorColor(true),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Disconnect',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getErrorColor(true),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Connect',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
