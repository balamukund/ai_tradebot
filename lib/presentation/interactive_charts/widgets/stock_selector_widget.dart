import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StockSelectorWidget extends StatefulWidget {
  final List<Map<String, dynamic>> watchlist;
  final String selectedStock;
  final Function(String) onStockChanged;

  const StockSelectorWidget({
    Key? key,
    required this.watchlist,
    required this.selectedStock,
    required this.onStockChanged,
  }) : super(key: key);

  @override
  State<StockSelectorWidget> createState() => _StockSelectorWidgetState();
}

class _StockSelectorWidgetState extends State<StockSelectorWidget> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.watchlist.indexWhere(
      (stock) => stock['symbol'] == widget.selectedStock,
    );
    if (currentIndex == -1) currentIndex = 0;

    _pageController = PageController(
      initialPage: currentIndex,
      viewportFraction: 0.85,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.watchlist.isEmpty) {
      return Container(
        height: 12.h,
        child: Center(
          child: Text(
            'No stocks in watchlist',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Container(
      height: 12.h,
      child: Column(
        children: [
          // Stock Cards
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
                widget.onStockChanged(widget.watchlist[index]['symbol']);
                HapticFeedback.selectionClick();
              },
              itemCount: widget.watchlist.length,
              itemBuilder: (context, index) {
                final stock = widget.watchlist[index];
                final isSelected = index == currentIndex;

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: isSelected ? 0.5.h : 1.h,
                  ),
                  child: _buildStockCard(stock, isSelected),
                );
              },
            ),
          ),

          // Page Indicators
          if (widget.watchlist.length > 1) _buildPageIndicators(),
        ],
      ),
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stock, bool isSelected) {
    final symbol = stock['symbol'] as String;
    final name = stock['name'] as String;
    final price = stock['price'] as double;
    final change = stock['change'] as double;
    final changePercent = stock['changePercent'] as double;
    final isPositive = change >= 0;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          final index = widget.watchlist.indexOf(stock);
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppTheme.lightTheme.shadowColor,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stock Symbol and Name
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbol,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme
                                    .lightTheme.textTheme.titleMedium?.color,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          name,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color:
                                AppTheme.lightTheme.textTheme.bodyMedium?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Market Status Indicator
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.getSuccessColor(true),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'LIVE',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.getSuccessColor(true),
                            fontWeight: FontWeight.w600,
                            fontSize: 8.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // Price and Change
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${price.toStringAsFixed(2)}',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isPositive
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.getErrorColor(true),
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName:
                                  isPositive ? 'trending_up' : 'trending_down',
                              color: isPositive
                                  ? AppTheme.getSuccessColor(true)
                                  : AppTheme.getErrorColor(true),
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: isPositive
                                    ? AppTheme.getSuccessColor(true)
                                    : AppTheme.getErrorColor(true),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '(${changePercent.toStringAsFixed(2)}%)',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: isPositive
                                    ? AppTheme.getSuccessColor(true)
                                    : AppTheme.getErrorColor(true),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Mini Chart Placeholder
                  Container(
                    width: 15.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: (isPositive
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getErrorColor(true))
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'show_chart',
                        color: isPositive
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.getErrorColor(true),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.watchlist.length,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            width: index == currentIndex ? 6.w : 2.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
