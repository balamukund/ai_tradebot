import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final String selectedRange;
  final Function(String) onRangeChanged;

  const DateRangeSelectorWidget({
    Key? key,
    required this.selectedRange,
    required this.onRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ranges = ['Today', '1W', '1M', '3M', 'All Time'];

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(children: [
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: ranges.map((range) {
                    final isSelected = selectedRange == range;
                    return GestureDetector(
                        onTap: () => onRangeChanged(range),
                        child: Container(
                            margin: EdgeInsets.only(right: 2.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme
                                        .lightTheme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme.dividerLight)),
                            child: Text(range,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppTheme.textHighEmphasisLight,
                                        fontWeight: FontWeight.w500))));
                  }).toList()))),
          GestureDetector(
              onTap: () => _showCustomDatePicker(context),
              child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.dividerLight)),
                  child: CustomIconWidget(
                      iconName: 'date_range',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20))),
        ]));
  }

  void _showCustomDatePicker(BuildContext context) {
    showDateRangePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: AppTheme.lightTheme.primaryColor)),
              child: child!);
        }).then((dateRange) {
      if (dateRange != null) {
        final customRange =
            'Custom (${_formatDate(dateRange.start)} - ${_formatDate(dateRange.end)})';
        onRangeChanged(customRange);
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
