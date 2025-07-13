import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final Map<String, dynamic> portfolioData;
  final bool isRefreshing;

  const PortfolioSummaryCard({
    Key? key,
    required this.portfolioData,
    required this.isRefreshing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPnL = portfolioData["totalPnL"] as double;
    final dailyPerformance = portfolioData["dailyPerformance"] as double;
    final profitTarget = portfolioData["profitTarget"] as double;
    final currentProgress = portfolioData["currentProgress"] as double;
    final totalValue = portfolioData["totalValue"] as double;

    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Portfolio Value',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isRefreshing)
                  SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: Colors.white,
                    size: 20,
                  ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              '₹${totalValue.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: totalPnL >= 0 ? 'arrow_upward' : 'arrow_downward',
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '₹${totalPnL.abs().toStringAsFixed(2)} (${dailyPerformance.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Target Progress',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${currentProgress.toStringAsFixed(1)}% / ${profitTarget.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (currentProgress / profitTarget).clamp(0.0, 1.0),
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentProgress >= profitTarget
                      ? AppTheme.getSuccessColor(true)
                      : Colors.white,
                ),
                minHeight: 1.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
