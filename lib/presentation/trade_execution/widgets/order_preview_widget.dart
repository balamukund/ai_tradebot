import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OrderPreviewWidget extends StatelessWidget {
  final String orderType;
  final String symbol;
  final int quantity;
  final double price;
  final double? stopLoss;
  final double? target;
  final bool bracketOrderEnabled;
  final bool isPaperTrading;

  const OrderPreviewWidget({
    Key? key,
    required this.orderType,
    required this.symbol,
    required this.quantity,
    required this.price,
    this.stopLoss,
    this.target,
    required this.bracketOrderEnabled,
    required this.isPaperTrading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalValue = quantity * price;
    final brokerage = _calculateBrokerage(totalValue);
    final taxes = _calculateTaxes(totalValue);
    final totalCost = totalValue + brokerage + taxes;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaperTrading
              ? AppTheme.getWarningColor(true).withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order Preview',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              const Spacer(),
              if (isPaperTrading)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'PAPER TRADING',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getWarningColor(true),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildOrderSummary(),
          SizedBox(height: 2.h),
          _buildCostBreakdown(totalValue, brokerage, taxes, totalCost),
          if (bracketOrderEnabled && stopLoss != null && target != null) ...[
            SizedBox(height: 2.h),
            _buildRiskRewardAnalysis(),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Symbol', symbol),
          _buildSummaryRow('Order Type', orderType),
          _buildSummaryRow('Quantity', '$quantity shares'),
          _buildSummaryRow('Price', '₹${price.toStringAsFixed(2)}'),
          if (stopLoss != null)
            _buildSummaryRow('Stop-Loss', '₹${stopLoss!.toStringAsFixed(2)}'),
          if (target != null)
            _buildSummaryRow('Target', '₹${target!.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown(
      double totalValue, double brokerage, double taxes, double totalCost) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost Breakdown',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          _buildCostRow('Order Value', totalValue),
          _buildCostRow('Brokerage', brokerage),
          _buildCostRow('Taxes & Charges', taxes),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            height: 2.h,
          ),
          _buildCostRow('Total Cost', totalCost, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isTotal
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskRewardAnalysis() {
    if (stopLoss == null || target == null) return const SizedBox.shrink();

    final potentialLoss = (price - stopLoss!) * quantity;
    final potentialProfit = (target! - price) * quantity;
    final riskRewardRatio = potentialProfit / potentialLoss;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk-Reward Analysis',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Potential Loss',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '₹${potentialLoss.toStringAsFixed(2)}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getErrorColor(true),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Risk:Reward',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '1:${riskRewardRatio.toStringAsFixed(1)}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: riskRewardRatio >= 2
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.getWarningColor(true),
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
                      'Potential Profit',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '₹${potentialProfit.toStringAsFixed(2)}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getSuccessColor(true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateBrokerage(double orderValue) {
    // Simplified brokerage calculation (₹20 or 0.03% whichever is lower)
    return orderValue * 0.0003 > 20 ? 20 : orderValue * 0.0003;
  }

  double _calculateTaxes(double orderValue) {
    // Simplified tax calculation (STT + Transaction charges + GST)
    return orderValue * 0.001;
  }
}
