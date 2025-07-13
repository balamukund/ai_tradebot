import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    Key? key,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  String _selectedTradeType = 'All';
  String _selectedPnLFilter = 'All';
  RangeValues _signalConfidenceRange = RangeValues(0, 100);
  RangeValues _pnlRange = RangeValues(-10000, 10000);

  final List<String> _tradeTypes = ['All', 'BUY', 'SELL'];
  final List<String> _pnlFilters = ['All', 'Profit', 'Loss'];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          _buildHandle(),
          _buildHeader(),
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTradeTypeFilter(),
                        SizedBox(height: 3.h),
                        _buildPnLFilter(),
                        SizedBox(height: 3.h),
                        _buildSignalConfidenceFilter(),
                        SizedBox(height: 3.h),
                        _buildPnLRangeFilter(),
                        SizedBox(height: 4.h),
                        _buildActionButtons(),
                      ]))),
        ]));
  }

  Widget _buildHandle() {
    return Container(
        width: 12.w,
        height: 0.5.h,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
            color: AppTheme.dividerLight,
            borderRadius: BorderRadius.circular(2)));
  }

  Widget _buildHeader() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppTheme.dividerLight, width: 1))),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Filter Trades',
              style: AppTheme.lightTheme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: _resetFilters,
              child: Text('Reset',
                  style: TextStyle(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _buildTradeTypeFilter() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Trade Type',
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 1.h),
      Row(
          children: _tradeTypes.map((type) {
        final isSelected = _selectedTradeType == type;
        return Expanded(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTradeType = type;
                  });
                },
                child: Container(
                    margin: EdgeInsets.only(
                        right: type != _tradeTypes.last ? 2.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.dividerLight)),
                    child: Text(type,
                        textAlign: TextAlign.center,
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textHighEmphasisLight,
                                fontWeight: FontWeight.w500)))));
      }).toList()),
    ]);
  }

  Widget _buildPnLFilter() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Profit/Loss',
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 1.h),
      Row(
          children: _pnlFilters.map((filter) {
        final isSelected = _selectedPnLFilter == filter;
        return Expanded(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPnLFilter = filter;
                  });
                },
                child: Container(
                    margin: EdgeInsets.only(
                        right: filter != _pnlFilters.last ? 2.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.dividerLight)),
                    child: Text(filter,
                        textAlign: TextAlign.center,
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textHighEmphasisLight,
                                fontWeight: FontWeight.w500)))));
      }).toList()),
    ]);
  }

  Widget _buildSignalConfidenceFilter() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Signal Confidence',
            style: AppTheme.lightTheme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        Text(
            '${_signalConfidenceRange.start.round()}% - ${_signalConfidenceRange.end.round()}%',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500)),
      ]),
      SizedBox(height: 1.h),
      RangeSlider(
          values: _signalConfidenceRange,
          min: 0,
          max: 100,
          divisions: 20,
          activeColor: AppTheme.lightTheme.primaryColor,
          inactiveColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          onChanged: (values) {
            setState(() {
              _signalConfidenceRange = values;
            });
          }),
    ]);
  }

  Widget _buildPnLRangeFilter() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('P&L Range',
            style: AppTheme.lightTheme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        Text('₹${_pnlRange.start.round()} - ₹${_pnlRange.end.round()}',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500)),
      ]),
      SizedBox(height: 1.h),
      RangeSlider(
          values: _pnlRange,
          min: -10000,
          max: 10000,
          divisions: 100,
          activeColor: AppTheme.lightTheme.primaryColor,
          inactiveColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          onChanged: (values) {
            setState(() {
              _pnlRange = values;
            });
          }),
    ]);
  }

  Widget _buildActionButtons() {
    return Row(children: [
      Expanded(
          child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  side: BorderSide(color: AppTheme.lightTheme.primaryColor)),
              child: Text('Cancel',
                  style: TextStyle(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500)))),
      SizedBox(width: 3.w),
      Expanded(
          child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h)),
              child: Text('Apply Filters',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)))),
    ]);
  }

  void _resetFilters() {
    setState(() {
      _selectedTradeType = 'All';
      _selectedPnLFilter = 'All';
      _signalConfidenceRange = RangeValues(0, 100);
      _pnlRange = RangeValues(-10000, 10000);
    });
  }

  void _applyFilters() {
    final filters = {
      'tradeType': _selectedTradeType,
      'pnlFilter': _selectedPnLFilter,
      'signalConfidenceRange': _signalConfidenceRange,
      'pnlRange': _pnlRange,
    };

    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }
}
