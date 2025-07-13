import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfitTargetCardWidget extends StatelessWidget {
  final double profitTargetPercentage;
  final bool trailingStopEnabled;
  final double trailingStopPercentage;
  final Function(double) onProfitTargetChanged;
  final Function(bool) onTrailingStopToggle;
  final Function(double) onTrailingStopPercentageChanged;

  const ProfitTargetCardWidget({
    super.key,
    required this.profitTargetPercentage,
    required this.trailingStopEnabled,
    required this.trailingStopPercentage,
    required this.onProfitTargetChanged,
    required this.onTrailingStopToggle,
    required this.onTrailingStopPercentageChanged,
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
                  iconName: 'trending_up',
                  color: AppTheme.getSuccessColor(
                      Theme.of(context).brightness == Brightness.light),
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Profit Targets',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showProfitTargetInfo(context),
                  icon: CustomIconWidget(
                    iconName: 'info_outline',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Configure profit booking and trailing stop settings',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 3.h),

            // Profit Target Percentage
            _buildSliderSection(
              context: context,
              title: 'Profit Target',
              value: profitTargetPercentage,
              min: 0.5,
              max: 3.0,
              divisions: 10,
              suffix: '%',
              onChanged: onProfitTargetChanged,
              description: 'Automatically book profits when target is reached',
            ),
            SizedBox(height: 3.h),

            // Trailing Stop Toggle
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: trailingStopEnabled
                    ? AppTheme.getSuccessColor(
                            Theme.of(context).brightness == Brightness.light)
                        .withValues(alpha: 0.05)
                    : Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: trailingStopEnabled
                      ? AppTheme.getSuccessColor(
                              Theme.of(context).brightness == Brightness.light)
                          .withValues(alpha: 0.2)
                      : Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'follow_the_signs',
                        color: trailingStopEnabled
                            ? AppTheme.getSuccessColor(
                                Theme.of(context).brightness ==
                                    Brightness.light)
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trailing Stop Loss',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Automatically adjust stop loss as price moves in your favor',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: trailingStopEnabled,
                        onChanged: onTrailingStopToggle,
                      ),
                    ],
                  ),
                  if (trailingStopEnabled) ...[
                    SizedBox(height: 2.h),
                    _buildSliderSection(
                      context: context,
                      title: 'Trailing Distance',
                      value: trailingStopPercentage,
                      min: 0.3,
                      max: 2.0,
                      divisions: 17,
                      suffix: '%',
                      onChanged: onTrailingStopPercentageChanged,
                      description: 'Distance to maintain below highest price',
                      showCard: false,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Visual Example
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
                    'Example Trade Scenario',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  _buildTradeExample(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection({
    required BuildContext context,
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String suffix,
    required Function(double) onChanged,
    required String description,
    bool showCard = true,
  }) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(
                        Theme.of(context).brightness == Brightness.light)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toStringAsFixed(1)}$suffix',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.getSuccessColor(
                          Theme.of(context).brightness == Brightness.light),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            activeTrackColor: AppTheme.getSuccessColor(
                Theme.of(context).brightness == Brightness.light),
            thumbColor: AppTheme.getSuccessColor(
                Theme.of(context).brightness == Brightness.light),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );

    return showCard ? content : content;
  }

  Widget _buildTradeExample(BuildContext context) {
    return Column(
      children: [
        _buildTradeStep(
          context: context,
          step: '1',
          title: 'Entry Price',
          value: '₹100.00',
          description: 'AI signal triggers buy order',
        ),
        SizedBox(height: 1.h),
        _buildTradeStep(
          context: context,
          step: '2',
          title: 'Profit Target',
          value:
              '₹${(100 + (100 * profitTargetPercentage / 100)).toStringAsFixed(2)}',
          description:
              'Automatic profit booking at ${profitTargetPercentage.toStringAsFixed(1)}%',
        ),
        if (trailingStopEnabled) ...[
          SizedBox(height: 1.h),
          _buildTradeStep(
            context: context,
            step: '3',
            title: 'Trailing Stop',
            value:
                '₹${(100 - (100 * trailingStopPercentage / 100)).toStringAsFixed(2)}',
            description:
                'Stop loss trails ${trailingStopPercentage.toStringAsFixed(1)}% below highest price',
          ),
        ],
      ],
    );
  }

  Widget _buildTradeStep({
    required BuildContext context,
    required String step,
    required String title,
    required String value,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.getSuccessColor(
                              Theme.of(context).brightness == Brightness.light),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
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

  void _showProfitTargetInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Profit Targets',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Profit target settings help you lock in gains automatically:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                _buildInfoItem(
                  context,
                  'Profit Target',
                  'The percentage gain at which positions are automatically closed to book profits.',
                ),
                SizedBox(height: 1.h),
                _buildInfoItem(
                  context,
                  'Trailing Stop Loss',
                  'Automatically adjusts your stop loss upward as the stock price rises, helping to lock in profits while allowing for continued gains.',
                ),
                SizedBox(height: 1.h),
                _buildInfoItem(
                  context,
                  'Trailing Distance',
                  'The percentage distance to maintain between the current price and the trailing stop loss level.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
