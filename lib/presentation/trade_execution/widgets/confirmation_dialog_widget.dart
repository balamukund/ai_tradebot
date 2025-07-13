import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String orderType;
  final String symbol;
  final int quantity;
  final double price;
  final bool isPaperTrading;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialogWidget({
    Key? key,
    required this.orderType,
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.isPaperTrading,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalValue = quantity * price;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'warning',
            size: 24,
            color: isPaperTrading
                ? AppTheme.getWarningColor(true)
                : AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              isPaperTrading ? 'Confirm Paper Order' : 'Confirm Order',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: isPaperTrading
                    ? AppTheme.getWarningColor(true)
                    : AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPaperTrading)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.getWarningColor(true).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'science',
                    size: 32,
                    color: AppTheme.getWarningColor(true),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'PAPER TRADING MODE',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.getWarningColor(true),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'No real money will be involved in this transaction',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getWarningColor(true),
                    ),
                  ),
                ],
              ),
            ),
          Text(
            'Please confirm your order details:',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),
          _buildConfirmationDetails(totalValue),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.errorContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  size: 16,
                  color: AppTheme.getErrorColor(true),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    isPaperTrading
                        ? 'This is a simulated trade for practice purposes only'
                        : 'This action cannot be undone. Please review carefully.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getErrorColor(true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPaperTrading
                ? AppTheme.getWarningColor(true)
                : AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(
            isPaperTrading ? 'Place Paper Order' : 'Confirm Order',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationDetails(double totalValue) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDetailRow('Symbol', symbol),
          _buildDetailRow('Order Type', orderType),
          _buildDetailRow('Quantity', '$quantity shares'),
          _buildDetailRow('Price', '₹${price.toStringAsFixed(2)}'),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            height: 2.h,
          ),
          _buildDetailRow('Total Value', '₹${totalValue.toStringAsFixed(2)}',
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isTotal
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
