import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ChartToolbarWidget extends StatelessWidget {
  final String selectedTimeframe;
  final Function(String) onTimeframeChanged;
  final bool showVolume;
  final bool showRSI;
  final bool showMACD;
  final bool showAISignals;
  final Function(String) onToggleIndicator;

  const ChartToolbarWidget({
    Key? key,
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
    required this.showVolume,
    required this.showRSI,
    required this.showMACD,
    required this.showAISignals,
    required this.onToggleIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeframes = ['1M', '5M', '15M', '1H', '1D', '1W'];

    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Timeframe Selector
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: timeframes.map((timeframe) {
                  final isSelected = selectedTimeframe == timeframe;
                  return GestureDetector(
                    onTap: () => onTimeframeChanged(timeframe),
                    child: Container(
                      margin: EdgeInsets.only(right: 2.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.dividerColor,
                        ),
                      ),
                      child: Text(
                        timeframe,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Indicator Toggle Buttons
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildIndicatorButton(
                  'V',
                  showVolume,
                  () => onToggleIndicator('volume'),
                  'Volume',
                ),
                SizedBox(width: 1.w),
                _buildIndicatorButton(
                  'RSI',
                  showRSI,
                  () => onToggleIndicator('rsi'),
                  'RSI',
                ),
                SizedBox(width: 1.w),
                _buildIndicatorButton(
                  'MACD',
                  showMACD,
                  () => onToggleIndicator('macd'),
                  'MACD',
                ),
                SizedBox(width: 1.w),
                _buildIndicatorButton(
                  'AI',
                  showAISignals,
                  () => onToggleIndicator('signals'),
                  'AI Signals',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorButton(
    String label,
    bool isActive,
    VoidCallback onTap,
    String tooltip,
  ) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 8.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.dividerColor,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isActive
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 8.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
