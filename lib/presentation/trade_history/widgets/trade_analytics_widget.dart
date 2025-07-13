import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TradeAnalyticsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> trades;

  const TradeAnalyticsWidget({
    Key? key,
    required this.trades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 85.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          _buildHandle(),
          _buildHeader(context),
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOverviewCards(),
                        SizedBox(height: 3.h),
                        _buildPnLChart(),
                        SizedBox(height: 3.h),
                        _buildTradeTypeChart(),
                        SizedBox(height: 3.h),
                        _buildPerformanceMetrics(),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppTheme.dividerLight, width: 1))),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Trade Analytics',
              style: AppTheme.lightTheme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textMediumEmphasisLight,
                  size: 24)),
        ]));
  }

  Widget _buildOverviewCards() {
    final totalTrades = trades.length;
    final profitableTrades =
        trades.where((t) => (t['pnl'] as double) > 0).length;
    final totalPnL =
        trades.fold<double>(0, (sum, t) => sum + (t['pnl'] as double));
    final winRate =
        totalTrades > 0 ? (profitableTrades / totalTrades * 100) : 0.0;

    return Row(children: [
      Expanded(
          child: _buildOverviewCard(
              'Total P&L',
              '₹${totalPnL.toStringAsFixed(2)}',
              totalPnL >= 0 ? AppTheme.successLight : AppTheme.errorLight,
              'trending_up')),
      SizedBox(width: 3.w),
      Expanded(
          child: _buildOverviewCard(
              'Win Rate',
              '${winRate.toStringAsFixed(1)}%',
              winRate >= 50 ? AppTheme.successLight : AppTheme.warningLight,
              'percent')),
    ]);
  }

  Widget _buildOverviewCard(
      String title, String value, Color color, String iconName) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title,
                style: AppTheme.lightTheme.textTheme.bodyMedium
                    ?.copyWith(color: AppTheme.textMediumEmphasisLight)),
            CustomIconWidget(iconName: iconName, color: color, size: 20),
          ]),
          SizedBox(height: 1.h),
          Text(value,
              style: AppTheme.lightTheme.textTheme.titleLarge
                  ?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ]));
  }

  Widget _buildPnLChart() {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('P&L Distribution',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 2.h),
          Container(
              height: 30.h,
              child: Semantics(
                  label: "Profit and Loss Distribution Bar Chart",
                  child: BarChart(BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: trades
                              .map((t) => (t['pnl'] as double).abs())
                              .reduce((a, b) => a > b ? a : b) *
                          1.2,
                      minY: -trades
                              .map((t) => (t['pnl'] as double).abs())
                              .reduce((a, b) => a > b ? a : b) *
                          1.2,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() < trades.length) {
                                      return Text(
                                          trades[value.toInt()]['symbol']
                                              as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall);
                                    }
                                    return Text('');
                                  })),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text('₹${value.toInt()}',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall);
                                  })),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false))),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      barGroups: trades.asMap().entries.map((entry) {
                        final index = entry.key;
                        final trade = entry.value;
                        final pnl = trade['pnl'] as double;

                        return BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                              toY: pnl,
                              color: pnl >= 0
                                  ? AppTheme.successLight
                                  : AppTheme.errorLight,
                              width: 4.w,
                              borderRadius: BorderRadius.circular(2)),
                        ]);
                      }).toList())))),
        ]));
  }

  Widget _buildTradeTypeChart() {
    final buyTrades = trades.where((t) => t['tradeType'] == 'BUY').length;
    final sellTrades = trades.where((t) => t['tradeType'] == 'SELL').length;

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Trade Type Distribution',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 2.h),
          Container(
              height: 25.h,
              child: Row(children: [
                Expanded(
                    child: Semantics(
                        label: "Trade Type Distribution Pie Chart",
                        child: PieChart(PieChartData(sections: [
                          PieChartSectionData(
                              value: buyTrades.toDouble(),
                              title: 'BUY\n$buyTrades',
                              color: AppTheme.successLight,
                              radius: 15.w,
                              titleStyle: AppTheme
                                  .lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                          PieChartSectionData(
                              value: sellTrades.toDouble(),
                              title: 'SELL\n$sellTrades',
                              color: AppTheme.errorLight,
                              radius: 15.w,
                              titleStyle: AppTheme
                                  .lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        ], centerSpaceRadius: 8.w, sectionsSpace: 2)))),
                SizedBox(width: 4.w),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                          'BUY Orders', AppTheme.successLight, buyTrades),
                      SizedBox(height: 1.h),
                      _buildLegendItem(
                          'SELL Orders', AppTheme.errorLight, sellTrades),
                    ]),
              ])),
        ]));
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(children: [
      Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      SizedBox(width: 2.w),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
        Text('$count trades',
            style: AppTheme.lightTheme.textTheme.bodySmall
                ?.copyWith(color: AppTheme.textMediumEmphasisLight)),
      ]),
    ]);
  }

  Widget _buildPerformanceMetrics() {
    final totalTrades = trades.length;
    final profitableTrades =
        trades.where((t) => (t['pnl'] as double) > 0).length;
    final avgProfit = trades
            .where((t) => (t['pnl'] as double) > 0)
            .fold<double>(0, (sum, t) => sum + (t['pnl'] as double)) /
        (profitableTrades > 0 ? profitableTrades : 1);
    final avgLoss = trades
            .where((t) => (t['pnl'] as double) < 0)
            .fold<double>(0, (sum, t) => sum + (t['pnl'] as double)) /
        ((totalTrades - profitableTrades) > 0
            ? (totalTrades - profitableTrades)
            : 1);

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Performance Metrics',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 2.h),
          _buildMetricRow('Total Trades', totalTrades.toString()),
          _buildMetricRow('Profitable Trades', profitableTrades.toString()),
          _buildMetricRow('Average Profit', '₹${avgProfit.toStringAsFixed(2)}'),
          _buildMetricRow('Average Loss', '₹${avgLoss.toStringAsFixed(2)}'),
          _buildMetricRow(
              'Profit Factor', (avgProfit / avgLoss.abs()).toStringAsFixed(2)),
        ]));
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.textMediumEmphasisLight)),
          Text(value,
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ]));
  }
}
