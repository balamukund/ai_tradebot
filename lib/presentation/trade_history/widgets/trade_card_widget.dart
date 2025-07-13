import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TradeCardWidget extends StatelessWidget {
  final Map<String, dynamic> trade;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeRight;

  const TradeCardWidget({
    Key? key,
    required this.trade,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onSwipeRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isProfit = (trade['pnl'] as double) > 0;
    final pnlColor = isProfit ? AppTheme.successLight : AppTheme.errorLight;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Dismissible(
        key: Key(trade['id'] as String),
        direction: DismissDirection.startToEnd,
        background: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'swipe_right',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Actions',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          onSwipeRight();
          return false;
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                : AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.dividerLight,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    if (isMultiSelectMode) ...[
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : Colors.transparent,
                          border: Border.all(
                            color: AppTheme.lightTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      SizedBox(width: 3.w),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                trade['symbol'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: trade['tradeType'] == 'BUY'
                                      ? AppTheme.successLight
                                          .withValues(alpha: 0.1)
                                      : AppTheme.errorLight
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  trade['tradeType'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: trade['tradeType'] == 'BUY'
                                        ? AppTheme.successLight
                                        : AppTheme.errorLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            trade['companyName'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoColumn(
                        'Quantity',
                        '${trade['quantity']} shares',
                        AppTheme.textHighEmphasisLight,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        'Price',
                        '₹${(trade['price'] as double).toStringAsFixed(2)}',
                        AppTheme.textHighEmphasisLight,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        'P&L',
                        '₹${(trade['pnl'] as double).toStringAsFixed(2)}',
                        pnlColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'psychology',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          trade['aiSignal'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.5.w,
                            vertical: 0.2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${trade['signalConfidence']}%',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatTimestamp(trade['timestamp'] as DateTime),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
