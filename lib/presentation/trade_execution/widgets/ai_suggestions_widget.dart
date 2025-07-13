import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiSuggestionsWidget extends StatelessWidget {
  final Map<String, dynamic> suggestions;
  final TextEditingController stopLossController;
  final TextEditingController targetController;

  const AiSuggestionsWidget({
    Key? key,
    required this.suggestions,
    required this.stopLossController,
    required this.targetController,
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI Suggestions',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              const Spacer(),
              _buildConfidenceIndicator(),
            ],
          ),
          SizedBox(height: 2.h),
          _buildSuggestionCard(),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStopLossInput(),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildTargetInput(),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildRiskAnalysis(),
        ],
      ),
    );
  }

  Widget _buildConfidenceIndicator() {
    final confidence = suggestions["confidence"] as double;
    final confidencePercent = (confidence * 100).round();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getConfidenceColor(confidence).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${confidencePercent}% confidence',
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: _getConfidenceColor(confidence),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return AppTheme.getSuccessColor(true);
    if (confidence >= 0.6) return AppTheme.getWarningColor(true);
    return AppTheme.getErrorColor(true);
  }

  Widget _buildSuggestionCard() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Stop-Loss',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '₹${(suggestions["recommendedStopLoss"] as double).toStringAsFixed(2)}',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getErrorColor(true),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Recommended Target',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '₹${(suggestions["recommendedTarget"] as double).toStringAsFixed(2)}',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getSuccessColor(true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            suggestions["reasoning"] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopLossInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stop-Loss',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: stopLossController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: 'Enter stop-loss',
            prefixText: '₹',
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.5.h,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                stopLossController.text =
                    (suggestions["recommendedStopLoss"] as double)
                        .toStringAsFixed(2);
              },
              child: Container(
                margin: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomIconWidget(
                  iconName: 'auto_fix_high',
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildTargetInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Price',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: targetController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: 'Enter target',
            prefixText: '₹',
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.5.h,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                targetController.text =
                    (suggestions["recommendedTarget"] as double)
                        .toStringAsFixed(2);
              },
              child: Container(
                margin: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomIconWidget(
                  iconName: 'auto_fix_high',
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildRiskAnalysis() {
    final volatilityScore = suggestions["volatilityScore"] as double;
    final riskLevel = suggestions["riskLevel"] as String;

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
                  'Risk Level',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  riskLevel,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getRiskColor(riskLevel),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Volatility Score',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${(volatilityScore * 100).toStringAsFixed(0)}%',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return AppTheme.getSuccessColor(true);
      case 'medium':
        return AppTheme.getWarningColor(true);
      case 'high':
        return AppTheme.getErrorColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }
}
