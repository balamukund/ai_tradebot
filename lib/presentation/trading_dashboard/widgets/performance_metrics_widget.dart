import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PerformanceMetricsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> metrics;

  const PerformanceMetricsWidget({
    Key? key,
    required this.metrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      child: PageView.builder(
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: _getIconForMetric(metric["title"] as String),
                      color: _getColorForMetric(metric["color"] as String),
                      size: 32,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      metric["value"] as String,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color:
                                _getColorForMetric(metric["color"] as String),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      metric["title"] as String,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      metric["subtitle"] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getIconForMetric(String title) {
    switch (title) {
      case "Today's Trades":
        return 'swap_horiz';
      case 'Weekly Performance':
        return 'trending_up';
      case 'Risk Exposure':
        return 'security';
      default:
        return 'analytics';
    }
  }

  Color _getColorForMetric(String colorType) {
    switch (colorType) {
      case 'success':
        return AppTheme.getSuccessColor(true);
      case 'warning':
        return AppTheme.getWarningColor(true);
      case 'error':
        return AppTheme.getErrorColor(true);
      default:
        return AppTheme.getAccentColor(true);
    }
  }
}
