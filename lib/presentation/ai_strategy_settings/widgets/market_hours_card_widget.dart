import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MarketHoursCardWidget extends StatelessWidget {
  final bool preMarketEnabled;
  final TimeOfDay marketStartTime;
  final TimeOfDay marketEndTime;
  final Function(bool) onPreMarketToggle;
  final Function(TimeOfDay) onStartTimeChanged;
  final Function(TimeOfDay) onEndTimeChanged;

  const MarketHoursCardWidget({
    super.key,
    required this.preMarketEnabled,
    required this.marketStartTime,
    required this.marketEndTime,
    required this.onPreMarketToggle,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
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
                  iconName: 'schedule',
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Market Hours',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showMarketHoursInfo(context),
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
              'Configure trading windows and market participation',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 3.h),

            // Pre-market Trading Toggle
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: preMarketEnabled
                    ? Theme.of(context)
                        .colorScheme
                        .tertiary
                        .withValues(alpha: 0.05)
                    : Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: preMarketEnabled
                      ? Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withValues(alpha: 0.2)
                      : Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'wb_twilight',
                    color: preMarketEnabled
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pre-Market Trading',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Trade during pre-market hours (9:00 AM - 9:15 AM)',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: preMarketEnabled,
                    onChanged: onPreMarketToggle,
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Trading Hours Configuration
            Text(
              'Trading Hours',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),

            // Market Start Time
            _buildTimeSelector(
              context: context,
              title: 'Market Start Time',
              time: marketStartTime,
              onTimeChanged: onStartTimeChanged,
              icon: 'play_arrow',
            ),
            SizedBox(height: 2.h),

            // Market End Time
            _buildTimeSelector(
              context: context,
              title: 'Market End Time',
              time: marketEndTime,
              onTimeChanged: onEndTimeChanged,
              icon: 'stop',
            ),
            SizedBox(height: 3.h),

            // Market Status Preview
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
                    'Trading Schedule',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  if (preMarketEnabled) ...[
                    _buildScheduleItem(
                      context: context,
                      title: 'Pre-Market',
                      time: '9:00 AM - 9:15 AM',
                      status: 'Active',
                      isActive: true,
                    ),
                    SizedBox(height: 1.h),
                  ],
                  _buildScheduleItem(
                    context: context,
                    title: 'Regular Market',
                    time:
                        '${_formatTime(marketStartTime)} - ${_formatTime(marketEndTime)}',
                    status: 'Active',
                    isActive: true,
                  ),
                  SizedBox(height: 1.h),
                  _buildScheduleItem(
                    context: context,
                    title: 'After Hours',
                    time: '3:30 PM - 4:00 PM',
                    status: 'Inactive',
                    isActive: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required BuildContext context,
    required String title,
    required TimeOfDay time,
    required Function(TimeOfDay) onTimeChanged,
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () => _selectTime(context, time, onTimeChanged),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
                  Text(
                    _formatTime(time),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required BuildContext context,
    required String title,
    required String time,
    required String status,
    required bool isActive,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.getSuccessColor(
                    Theme.of(context).brightness == Brightness.light)
                : Theme.of(context).colorScheme.onSurfaceVariant,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: isActive
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
            status,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isActive
                      ? AppTheme.getSuccessColor(
                          Theme.of(context).brightness == Brightness.light)
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay currentTime,
      Function(TimeOfDay) onTimeChanged) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              dayPeriodColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentTime) {
      onTimeChanged(picked);
    }
  }

  void _showMarketHoursInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Market Hours',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Configure when your AI trading bot should be active:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                _buildInfoItem(
                  context,
                  'Pre-Market Trading',
                  'Allows trading during the pre-market session (9:00 AM - 9:15 AM). Note: Lower liquidity and higher volatility.',
                ),
                SizedBox(height: 1.h),
                _buildInfoItem(
                  context,
                  'Regular Market Hours',
                  'Standard trading session with highest liquidity. Default: 9:15 AM - 3:30 PM.',
                ),
                SizedBox(height: 1.h),
                _buildInfoItem(
                  context,
                  'After Hours',
                  'Post-market session (3:30 PM - 4:00 PM). Currently not supported for automated trading.',
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
