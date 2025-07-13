import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RiskManagementCardWidget extends StatelessWidget {
  final double maxDailyLossPercentage;
  final double positionSizingLimit;
  final double stopLossBuffer;
  final Function(double) onMaxDailyLossChanged;
  final Function(double) onPositionSizingChanged;
  final Function(double) onStopLossBufferChanged;

  const RiskManagementCardWidget({
    super.key,
    required this.maxDailyLossPercentage,
    required this.positionSizingLimit,
    required this.stopLossBuffer,
    required this.onMaxDailyLossChanged,
    required this.onPositionSizingChanged,
    required this.onStopLossBufferChanged,
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
                  iconName: 'security',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Risk Management',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showRiskManagementInfo(context),
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
              'Configure risk parameters to protect your capital',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 3.h),

            // Max Daily Loss Percentage
            _buildSliderSection(
              context: context,
              title: 'Maximum Daily Loss',
              value: maxDailyLossPercentage,
              min: 0.5,
              max: 5.0,
              divisions: 18,
              suffix: '%',
              onChanged: onMaxDailyLossChanged,
              description:
                  'Stop all trading when daily loss reaches this percentage',
            ),
            SizedBox(height: 3.h),

            // Position Sizing Limit
            _buildSliderSection(
              context: context,
              title: 'Position Sizing Limit',
              value: positionSizingLimit,
              min: 1.0,
              max: 25.0,
              divisions: 24,
              suffix: '%',
              onChanged: onPositionSizingChanged,
              description: 'Maximum percentage of capital per trade',
            ),
            SizedBox(height: 3.h),

            // Stop Loss Buffer
            _buildSliderSection(
              context: context,
              title: 'Stop Loss Buffer',
              value: stopLossBuffer,
              min: 0.5,
              max: 3.0,
              divisions: 10,
              suffix: '%',
              onChanged: onStopLossBufferChanged,
              description: 'Additional buffer below calculated stop loss',
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
  }) {
    return Column(
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
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toStringAsFixed(1)}$suffix',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
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
  }

  void _showRiskManagementInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Risk Management',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Risk management parameters help protect your capital:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                _buildInfoItem(
                  context,
                  'Maximum Daily Loss',
                  'Automatically stops all trading when your daily loss reaches this percentage of your total capital.',
                ),
                SizedBox(height: 1.h),
                _buildInfoItem(
                  context,
                  'Position Sizing Limit',
                  'Limits the maximum amount of capital that can be allocated to a single trade.',
                ),
                SizedBox(height: 1.h),
                _buildInfoItem(
                  context,
                  'Stop Loss Buffer',
                  'Adds an extra safety margin below the calculated stop loss level to account for market volatility.',
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
