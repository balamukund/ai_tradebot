import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StrategyToggleCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> strategies;
  final bool rsiEnabled;
  final bool macdEnabled;
  final bool patternEnabled;
  final bool volumeEnabled;
  final bool ldcEnabled;
  final Function(bool) onRsiToggle;
  final Function(bool) onMacdToggle;
  final Function(bool) onPatternToggle;
  final Function(bool) onVolumeToggle;
  final Function(bool) onLdcToggle;

  const StrategyToggleCardWidget({
    super.key,
    required this.strategies,
    required this.rsiEnabled,
    required this.macdEnabled,
    required this.patternEnabled,
    required this.volumeEnabled,
    required this.ldcEnabled,
    required this.onRsiToggle,
    required this.onMacdToggle,
    required this.onPatternToggle,
    required this.onVolumeToggle,
    required this.onLdcToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'auto_graph',
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Trading Strategies',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Enable or disable specific AI trading algorithms',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 3.h),

            // RSI Momentum Strategy
            _buildStrategyCard(
              context: context,
              strategy: strategies[0],
              isEnabled: rsiEnabled,
              onToggle: onRsiToggle,
              icon: 'trending_up',
              description:
                  'Momentum-based trading using Relative Strength Index',
            ),
            SizedBox(height: 2.h),

            // MACD Crossover Strategy
            _buildStrategyCard(
              context: context,
              strategy: strategies[1],
              isEnabled: macdEnabled,
              onToggle: onMacdToggle,
              icon: 'swap_calls',
              description: 'Signal line crossover detection for trend changes',
            ),
            SizedBox(height: 2.h),

            // Pattern Recognition Strategy
            _buildStrategyCard(
              context: context,
              strategy: strategies[2],
              isEnabled: patternEnabled,
              onToggle: onPatternToggle,
              icon: 'pattern',
              description:
                  'Machine learning pattern recognition in price movements',
            ),
            SizedBox(height: 2.h),

            // Volume Analysis Strategy
            _buildStrategyCard(
              context: context,
              strategy: strategies[3],
              isEnabled: volumeEnabled,
              onToggle: onVolumeToggle,
              icon: 'bar_chart',
              description: 'Volume-based confirmation for trade signals',
            ),
            SizedBox(height: 2.h),

            // LDC Strategy - New advanced strategy
            _buildStrategyCard(
              context: context,
              strategy: strategies[4],
              isEnabled: ldcEnabled,
              onToggle: onLdcToggle,
              icon: 'precision_manufacturing',
              description:
                  'Advanced ML using Lorentzian distance metrics for pattern recognition',
              isAdvanced: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategyCard({
    required BuildContext context,
    required Map<String, dynamic> strategy,
    required bool isEnabled,
    required Function(bool) onToggle,
    required String icon,
    required String description,
    bool isAdvanced = false,
  }) {
    final String name = strategy["name"] as String;
    final double winRate = (strategy["winRate"] as num).toDouble();
    final double avgProfit = (strategy["avgProfit"] as num).toDouble();
    final int totalTrades = strategy["totalTrades"] as int;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isEnabled
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
            : Theme.of(context)
                .colorScheme
                .onSurfaceVariant
                .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnabled
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        gradient: isAdvanced && isEnabled
            ? LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isEnabled
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1)
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: isEnabled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isEnabled
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                          ),
                        ),
                        if (isAdvanced) ...[
                          SizedBox(width: 1.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 0.25.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ADVANCED',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: onToggle,
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Performance Metrics
          Row(
            children: [
              Expanded(
                child: _buildMetric(
                  context: context,
                  label: 'Win Rate',
                  value: '${winRate.toStringAsFixed(1)}%',
                  color: _getWinRateColor(context, winRate),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildMetric(
                  context: context,
                  label: 'Avg Profit',
                  value: '${avgProfit.toStringAsFixed(1)}%',
                  color: AppTheme.getSuccessColor(
                      Theme.of(context).brightness == Brightness.light),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildMetric(
                  context: context,
                  label: 'Trades',
                  value: totalTrades.toString(),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Status Indicator
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppTheme.getSuccessColor(
                          Theme.of(context).brightness == Brightness.light)
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                isEnabled ? 'Active' : 'Inactive',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isEnabled
                          ? AppTheme.getSuccessColor(
                              Theme.of(context).brightness == Brightness.light)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (isAdvanced && isEnabled) ...[
                Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'science',
                        color: Theme.of(context).colorScheme.primary,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'ML Active',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
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
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Color _getWinRateColor(BuildContext context, double winRate) {
    if (winRate >= 70) {
      return AppTheme.getSuccessColor(
          Theme.of(context).brightness == Brightness.light);
    } else if (winRate >= 60) {
      return AppTheme.getWarningColor(
          Theme.of(context).brightness == Brightness.light);
    } else {
      return AppTheme.getErrorColor(
          Theme.of(context).brightness == Brightness.light);
    }
  }
}
