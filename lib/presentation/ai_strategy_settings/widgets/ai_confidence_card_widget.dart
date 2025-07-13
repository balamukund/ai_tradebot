import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiConfidenceCardWidget extends StatelessWidget {
  final double confidenceThreshold;
  final Function(double) onThresholdChanged;

  const AiConfidenceCardWidget({
    super.key,
    required this.confidenceThreshold,
    required this.onThresholdChanged,
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
                  iconName: 'psychology',
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'AI Confidence Threshold',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showConfidenceInfo(context),
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
              'Minimum AI signal strength required for automated trades',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 3.h),

            // Confidence Threshold Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Confidence Level',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(context, confidenceThreshold)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${confidenceThreshold.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color:
                              _getConfidenceColor(context, confidenceThreshold),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6.0,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 18.0),
                activeTrackColor:
                    _getConfidenceColor(context, confidenceThreshold),
                thumbColor: _getConfidenceColor(context, confidenceThreshold),
              ),
              child: Slider(
                value: confidenceThreshold,
                min: 50.0,
                max: 95.0,
                divisions: 18,
                onChanged: onThresholdChanged,
              ),
            ),
            SizedBox(height: 1.h),

            // Confidence Level Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Conservative',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Text(
                  'Aggressive',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Signal Preview
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
                    'Signal Preview',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Signals above ${confidenceThreshold.toStringAsFixed(0)}% confidence will trigger automated trades',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 2.h),
                  _buildSignalExample(context, 'RELIANCE', 85.0, 'BUY'),
                  SizedBox(height: 1.h),
                  _buildSignalExample(context, 'TCS', 72.0, 'SELL'),
                  SizedBox(height: 1.h),
                  _buildSignalExample(context, 'HDFC', 68.0, 'BUY'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalExample(
      BuildContext context, String symbol, double confidence, String action) {
    final bool willExecute = confidence >= confidenceThreshold;
    final Color actionColor = action == 'BUY'
        ? AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light)
        : AppTheme.getErrorColor(
            Theme.of(context).brightness == Brightness.light);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            symbol,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: actionColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              action,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: actionColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '${confidence.toStringAsFixed(0)}%',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getConfidenceColor(context, confidence),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: willExecute
                  ? AppTheme.getSuccessColor(
                          Theme.of(context).brightness == Brightness.light)
                      .withValues(alpha: 0.1)
                  : Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              willExecute ? 'Execute' : 'Skip',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: willExecute
                        ? AppTheme.getSuccessColor(
                            Theme.of(context).brightness == Brightness.light)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getConfidenceColor(BuildContext context, double confidence) {
    if (confidence >= 80) {
      return AppTheme.getSuccessColor(
          Theme.of(context).brightness == Brightness.light);
    } else if (confidence >= 65) {
      return AppTheme.getWarningColor(
          Theme.of(context).brightness == Brightness.light);
    } else {
      return AppTheme.getErrorColor(
          Theme.of(context).brightness == Brightness.light);
    }
  }

  void _showConfidenceInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'AI Confidence Threshold',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'The AI confidence threshold determines how certain the AI must be before executing a trade automatically.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Confidence Levels:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 1.h),
                _buildConfidenceLevel(context, '80-95%', 'High Confidence',
                    'Conservative approach with fewer but higher quality trades'),
                SizedBox(height: 1.h),
                _buildConfidenceLevel(context, '65-79%', 'Medium Confidence',
                    'Balanced approach with moderate trade frequency'),
                SizedBox(height: 1.h),
                _buildConfidenceLevel(context, '50-64%', 'Low Confidence',
                    'Aggressive approach with more frequent trades'),
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

  Widget _buildConfidenceLevel(
      BuildContext context, String range, String level, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              range,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(width: 2.w),
            Text(
              level,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
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
    );
  }
}
