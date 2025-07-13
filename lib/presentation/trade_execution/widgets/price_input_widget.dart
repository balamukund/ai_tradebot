import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PriceInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String orderType;
  final Map<String, dynamic> stockData;
  final ValueChanged<bool> onPriceAdjusted;

  const PriceInputWidget({
    Key? key,
    required this.controller,
    required this.orderType,
    required this.stockData,
    required this.onPriceAdjusted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orderType == 'Market' ? 'Market Price' : 'Price',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              if (orderType != 'Market') ...[
                GestureDetector(
                  onTap: () => onPriceAdjusted(false),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'remove',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
              ],
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  readOnly: orderType == 'Market',
                  decoration: InputDecoration(
                    hintText: 'Enter price',
                    prefixText: '₹',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                    fillColor: orderType == 'Market'
                        ? AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5)
                        : null,
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: orderType == 'Market'
                        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        : null,
                  ),
                ),
              ),
              if (orderType != 'Market') ...[
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () => onPriceAdjusted(true),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'add',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 2.h),
          _buildBidAskInfo(),
          if (orderType == 'Market') ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Market orders execute immediately at current market price',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBidAskInfo() {
    final bidPrice = stockData["bidPrice"] as double;
    final askPrice = stockData["askPrice"] as double;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bid',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '₹${bidPrice.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getSuccessColor(true),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 4.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Ask',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '₹${askPrice.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getErrorColor(true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
