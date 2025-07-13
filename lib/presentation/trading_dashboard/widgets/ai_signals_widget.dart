import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ldc_signal_service.dart';

class AISignalsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> signals;
  final List<LDCSignal> ldcSignals;
  final Function(Map<String, dynamic>) onSignalTap;
  final Function(LDCSignal)? onLDCSignalTap;

  const AISignalsWidget({
    Key? key,
    required this.signals,
    this.ldcSignals = const [],
    required this.onSignalTap,
    this.onLDCSignalTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allSignals = [...signals];
    final ldcSignalsForDisplay =
        ldcSignals.where((s) => !s.isNeutralSignal).toList();

    if (allSignals.isEmpty && ldcSignalsForDisplay.isEmpty) {
      return Container(
        height: 25.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'smart_toy',
                color: Colors.grey,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'No AI Signals',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              SizedBox(height: 1.h),
              Text(
                'AI is analyzing market conditions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 25.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allSignals.length + ldcSignalsForDisplay.length,
        itemBuilder: (context, index) {
          if (index < allSignals.length) {
            final signal = allSignals[index];
            return _buildSignalCard(context, signal);
          } else {
            final ldcSignal = ldcSignalsForDisplay[index - allSignals.length];
            return _buildLDCSignalCard(context, ldcSignal);
          }
        },
      ),
    );
  }

  Widget _buildSignalCard(BuildContext context, Map<String, dynamic> signal) {
    final symbol = signal["symbol"] as String;
    final signalType = signal["signal"] as String;
    final confidence = signal["confidence"] as int;
    final targetPrice = signal["targetPrice"] as double;
    final currentPrice = signal["currentPrice"] as double;
    final timeframe = signal["timeframe"] as String;
    final riskLevel = signal["riskLevel"] as String;

    final isBuySignal = signalType == "BUY";
    final potentialReturn =
        ((targetPrice - currentPrice) / currentPrice * 100).abs();

    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Card(
        child: InkWell(
          onTap: () => onSignalTap(signal),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      symbol,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: isBuySignal
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.getErrorColor(true),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        signalType,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.getAccentColor(true),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Confidence: $confidence%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: confidence / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    confidence >= 80
                        ? AppTheme.getSuccessColor(true)
                        : confidence >= 60
                            ? AppTheme.getWarningColor(true)
                            : AppTheme.getErrorColor(true),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        Text(
                          '₹${currentPrice.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    CustomIconWidget(
                      iconName: isBuySignal ? 'arrow_forward' : 'arrow_back',
                      color: isBuySignal
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.getErrorColor(true),
                      size: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Target',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        Text(
                          '₹${targetPrice.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSignalDetail(context, 'Potential',
                        '${potentialReturn.toStringAsFixed(1)}%'),
                    _buildSignalDetail(context, 'Timeframe', timeframe),
                    _buildSignalDetail(context, 'Risk', riskLevel),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLDCSignalCard(BuildContext context, LDCSignal signal) {
    final isBuySignal = signal.isBuySignal;

    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () => onLDCSignalTap?.call(signal),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  (isBuySignal
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.getErrorColor(true))
                      .withValues(alpha: 0.05),
                  Theme.of(context).cardColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'precision_manufacturing',
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'LDC',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 0.25.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ML',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: isBuySignal
                                  ? AppTheme.getSuccessColor(true)
                                  : AppTheme.getErrorColor(true),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              signal.signalType,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'psychology',
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'ML Confidence: ${signal.confidence.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey[300],
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: signal.confidence / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: LinearGradient(
                            colors: [
                              signal.confidence >= 80
                                  ? AppTheme.getSuccessColor(true)
                                  : signal.confidence >= 60
                                      ? AppTheme.getWarningColor(true)
                                      : AppTheme.getErrorColor(true),
                              (signal.confidence >= 80
                                      ? AppTheme.getSuccessColor(true)
                                      : signal.confidence >= 60
                                          ? AppTheme.getWarningColor(true)
                                          : AppTheme.getErrorColor(true))
                                  .withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLDCMetric(context, 'Prediction',
                          signal.prediction.toStringAsFixed(0)),
                      _buildLDCMetric(context, 'Features',
                          '${signal.features.f1.toStringAsFixed(1)}'),
                      _buildLDCMetric(context, 'Kernel',
                          signal.kernelEstimate.toStringAsFixed(2)),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      _buildFilterChip(
                          context, 'Vol', signal.filters.volatility),
                      SizedBox(width: 1.w),
                      _buildFilterChip(context, 'Reg', signal.filters.regime),
                      SizedBox(width: 1.w),
                      _buildFilterChip(context, 'ADX', signal.filters.adx),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: signal.filters.all
                              ? AppTheme.getSuccessColor(true)
                                  .withValues(alpha: 0.1)
                              : AppTheme.getWarningColor(true)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: signal.filters.all
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.getWarningColor(true),
                          ),
                        ),
                        child: Text(
                          signal.filters.all ? 'All Filters OK' : 'Filtered',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: signal.filters.all
                                        ? AppTheme.getSuccessColor(true)
                                        : AppTheme.getWarningColor(true),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignalDetail(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildLDCMetric(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.25.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
            : AppTheme.getErrorColor(true).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: isActive
              ? AppTheme.getSuccessColor(true)
              : AppTheme.getErrorColor(true),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.getErrorColor(true),
              fontWeight: FontWeight.w500,
              fontSize: 8.sp,
            ),
      ),
    );
  }
}
