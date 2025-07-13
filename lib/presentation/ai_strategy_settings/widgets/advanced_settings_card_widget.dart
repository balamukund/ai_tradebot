import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedSettingsCardWidget extends StatelessWidget {
  final bool isExpanded;
  final int lookbackPeriod;
  final double clusteringSensitivity;
  final VoidCallback onExpandToggle;
  final Function(double) onLookbackPeriodChanged;
  final Function(double) onClusteringSensitivityChanged;

  const AdvancedSettingsCardWidget({
    super.key,
    required this.isExpanded,
    required this.lookbackPeriod,
    required this.clusteringSensitivity,
    required this.onExpandToggle,
    required this.onLookbackPeriodChanged,
    required this.onClusteringSensitivityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onExpandToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'settings',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Settings',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Technical parameters for experienced traders',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomIconWidget(
                      iconName: isExpanded ? 'expand_less' : 'expand_more',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                        ),
                        SizedBox(height: 2.h),

                        // Warning Banner
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.getWarningColor(
                                    Theme.of(context).brightness ==
                                        Brightness.light)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.getWarningColor(
                                      Theme.of(context).brightness ==
                                          Brightness.light)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'warning',
                                color: AppTheme.getWarningColor(
                                    Theme.of(context).brightness ==
                                        Brightness.light),
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  'Modifying these settings may affect strategy performance. Only change if you understand the implications.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.getWarningColor(
                                            Theme.of(context).brightness ==
                                                Brightness.light),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Lookback Period
                        _buildAdvancedSlider(
                          context: context,
                          title: 'Lookback Period',
                          value: lookbackPeriod.toDouble(),
                          min: 5.0,
                          max: 50.0,
                          divisions: 45,
                          suffix: ' days',
                          onChanged: onLookbackPeriodChanged,
                          description:
                              'Number of historical days used for pattern analysis',
                          icon: 'history',
                        ),
                        SizedBox(height: 3.h),

                        // Clustering Sensitivity
                        _buildAdvancedSlider(
                          context: context,
                          title: 'Clustering Sensitivity',
                          value: clusteringSensitivity,
                          min: 0.1,
                          max: 1.0,
                          divisions: 18,
                          suffix: '',
                          onChanged: onClusteringSensitivityChanged,
                          description:
                              'Sensitivity for market behavior clustering (0.1 = loose, 1.0 = strict)',
                          icon: 'scatter_plot',
                        ),
                        SizedBox(height: 3.h),

                        // Technical Information
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
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'info',
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Technical Details',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              _buildTechnicalDetail(
                                context: context,
                                title: 'Pattern Recognition',
                                description:
                                    'Uses Euclidean distance to find similar price patterns in historical data',
                              ),
                              SizedBox(height: 1.h),
                              _buildTechnicalDetail(
                                context: context,
                                title: 'K-Means Clustering',
                                description:
                                    'Groups market behaviors to identify recurring patterns and anomalies',
                              ),
                              SizedBox(height: 1.h),
                              _buildTechnicalDetail(
                                context: context,
                                title: 'SVM Classification',
                                description:
                                    'Support Vector Machine for bullish/bearish trend prediction',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSlider({
    required BuildContext context,
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String suffix,
    required Function(double) onChanged,
    required String description,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  suffix.isEmpty
                      ? value.toStringAsFixed(1)
                      : '${value.toStringAsFixed(0)}$suffix',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 2.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
              activeTrackColor: Theme.of(context).colorScheme.primary,
              thumbColor: Theme.of(context).colorScheme.primary,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalDetail({
    required BuildContext context,
    required String title,
    required String description,
  }) {
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
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
