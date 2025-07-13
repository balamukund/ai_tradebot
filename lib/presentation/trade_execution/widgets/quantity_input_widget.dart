import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuantityInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Map<String, dynamic> portfolioData;
  final double currentPrice;
  final ValueChanged<double> onPositionSizeCalculated;

  const QuantityInputWidget({
    Key? key,
    required this.controller,
    required this.portfolioData,
    required this.currentPrice,
    required this.onPositionSizeCalculated,
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
          Text(
            'Quantity',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter quantity',
                    suffixText: 'shares',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  children: [
                    _buildQuickQuantityButton('+10', () {
                      int current = int.tryParse(controller.text) ?? 0;
                      controller.text = (current + 10).toString();
                    }),
                    SizedBox(height: 1.h),
                    _buildQuickQuantityButton('-10', () {
                      int current = int.tryParse(controller.text) ?? 0;
                      if (current >= 10) {
                        controller.text = (current - 10).toString();
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Position Size Calculator',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildPositionSizeButton('1%', 1),
              SizedBox(width: 2.w),
              _buildPositionSizeButton('2%', 2),
              SizedBox(width: 2.w),
              _buildPositionSizeButton('5%', 5),
              SizedBox(width: 2.w),
              _buildPositionSizeButton('10%', 10),
            ],
          ),
          SizedBox(height: 2.h),
          _buildPortfolioInfo(),
        ],
      ),
    );
  }

  Widget _buildQuickQuantityButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          minimumSize: Size.zero,
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildPositionSizeButton(String label, double percentage) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onPositionSizeCalculated(percentage),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          minimumSize: Size.zero,
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildPortfolioInfo() {
    final quantity = int.tryParse(controller.text) ?? 0;
    final totalValue = quantity * currentPrice;
    final portfolioPercentage =
        totalValue / (portfolioData["totalPortfolio"] as double) * 100;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Value:',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '₹${totalValue.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio %:',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '${portfolioPercentage.toStringAsFixed(2)}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: portfolioPercentage > 10
                      ? AppTheme.getWarningColor(true)
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Funds:',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '₹${(portfolioData["availableFunds"] as double).toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
