import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaperTradingCardWidget extends StatelessWidget {
  final bool paperTradingEnabled;
  final Function(bool) onToggle;

  const PaperTradingCardWidget({
    super.key,
    required this.paperTradingEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: paperTradingEnabled ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: paperTradingEnabled
            ? BorderSide(
                color: AppTheme.getWarningColor(
                    Theme.of(context).brightness == Brightness.light),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: paperTradingEnabled
              ? LinearGradient(
                  colors: [
                    AppTheme.getWarningColor(
                            Theme.of(context).brightness == Brightness.light)
                        .withValues(alpha: 0.05),
                    AppTheme.getWarningColor(
                            Theme.of(context).brightness == Brightness.light)
                        .withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: paperTradingEnabled
                          ? AppTheme.getWarningColor(
                                  Theme.of(context).brightness ==
                                      Brightness.light)
                              .withValues(alpha: 0.1)
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: paperTradingEnabled ? 'science' : 'trending_up',
                      color: paperTradingEnabled
                          ? AppTheme.getWarningColor(
                              Theme.of(context).brightness == Brightness.light)
                          : Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Paper Trading Mode',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            if (paperTradingEnabled) ...[
                              SizedBox(width: 2.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.getWarningColor(
                                      Theme.of(context).brightness ==
                                          Brightness.light),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'SIMULATION',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          paperTradingEnabled
                              ? 'Test strategies with virtual money - no real trades'
                              : 'Enable to test strategies without real money',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: paperTradingEnabled
                                        ? AppTheme.getWarningColor(
                                            Theme.of(context).brightness ==
                                                Brightness.light)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                    fontWeight: paperTradingEnabled
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: paperTradingEnabled,
                    onChanged: onToggle,
                    activeColor: AppTheme.getWarningColor(
                        Theme.of(context).brightness == Brightness.light),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Paper Trading Benefits
              if (paperTradingEnabled) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getWarningColor(
                            Theme.of(context).brightness == Brightness.light)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.getWarningColor(
                              Theme.of(context).brightness == Brightness.light)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'lightbulb',
                            color: AppTheme.getWarningColor(
                                Theme.of(context).brightness ==
                                    Brightness.light),
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Paper Trading Benefits',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.getWarningColor(
                                      Theme.of(context).brightness ==
                                          Brightness.light),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      _buildBenefitItem(
                        context: context,
                        icon: 'shield',
                        title: 'Risk-Free Testing',
                        description: 'Test strategies without financial risk',
                      ),
                      SizedBox(height: 1.h),
                      _buildBenefitItem(
                        context: context,
                        icon: 'analytics',
                        title: 'Performance Analysis',
                        description:
                            'Analyze strategy performance with real market data',
                      ),
                      SizedBox(height: 1.h),
                      _buildBenefitItem(
                        context: context,
                        icon: 'school',
                        title: 'Learning Experience',
                        description:
                            'Understand AI behavior before live trading',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // Virtual Portfolio Status
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Virtual Portfolio',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPortfolioMetric(
                              context: context,
                              label: 'Virtual Balance',
                              value: '₹10,00,000',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildPortfolioMetric(
                              context: context,
                              label: 'P&L',
                              value: '+₹12,450',
                              color: AppTheme.getSuccessColor(
                                  Theme.of(context).brightness ==
                                      Brightness.light),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPortfolioMetric(
                              context: context,
                              label: 'Total Trades',
                              value: '47',
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildPortfolioMetric(
                              context: context,
                              label: 'Win Rate',
                              value: '68.1%',
                              color: AppTheme.getSuccessColor(
                                  Theme.of(context).brightness ==
                                      Brightness.light),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Live Trading Warning
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getErrorColor(
                            Theme.of(context).brightness == Brightness.light)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.getErrorColor(
                              Theme.of(context).brightness == Brightness.light)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: AppTheme.getErrorColor(
                            Theme.of(context).brightness == Brightness.light),
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Live Trading Mode',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppTheme.getErrorColor(
                                        Theme.of(context).brightness ==
                                            Brightness.light),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'AI will execute real trades with your actual money. Ensure you understand the risks.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.getErrorColor(
                                        Theme.of(context).brightness ==
                                            Brightness.light),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required BuildContext context,
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.getWarningColor(
              Theme.of(context).brightness == Brightness.light),
          size: 16,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioMetric({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
