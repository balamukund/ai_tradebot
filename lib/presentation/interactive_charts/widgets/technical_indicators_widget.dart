import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TechnicalIndicatorsWidget extends StatelessWidget {
  final bool showRSI;
  final bool showMACD;
  final List<Map<String, dynamic>> chartData;

  const TechnicalIndicatorsWidget({
    Key? key,
    required this.showRSI,
    required this.showMACD,
    required this.chartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showRSI && !showMACD) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: [
          if (showRSI) ...[
            Expanded(child: _buildRSIChart()),
            if (showMACD) SizedBox(height: 1.h),
          ],
          if (showMACD) Expanded(child: _buildMACDChart()),
        ],
      ),
    );
  }

  Widget _buildRSIChart() {
    final rsiData = _calculateRSI();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightTheme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // RSI Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Text(
                  'RSI (14)',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  rsiData.isNotEmpty ? rsiData.last.toStringAsFixed(1) : '0.0',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: _getRSIColor(rsiData.isNotEmpty ? rsiData.last : 50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // RSI Chart
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: value == 30 || value == 70
                          ? AppTheme.getWarningColor(true)
                              .withValues(alpha: 0.5)
                          : AppTheme.lightTheme.dividerColor,
                      strokeWidth: value == 30 || value == 70 ? 1 : 0.5,
                      dashArray: value == 30 || value == 70 ? [5, 5] : null,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.toInt().toString(),
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (rsiData.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: rsiData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.lightTheme.primaryColor,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(enabled: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMACDChart() {
    final macdData = _calculateMACD();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightTheme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // MACD Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Text(
                  'MACD (12,26,9)',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                if (macdData.isNotEmpty)
                  Text(
                    macdData.last['macd']?.toStringAsFixed(2) ?? '0.00',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: _getMACDColor(macdData.last['macd'] ?? 0.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),

          // MACD Chart
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: value == 0
                          ? AppTheme.lightTheme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.5) ??
                              Colors.grey
                          : AppTheme.lightTheme.dividerColor,
                      strokeWidth: value == 0 ? 1 : 0.5,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.toStringAsFixed(1),
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (macdData.length - 1).toDouble(),
                  lineBarsData: [
                    // MACD Line
                    LineChartBarData(
                      spots: macdData.asMap().entries.map((entry) {
                        return FlSpot(
                            entry.key.toDouble(), entry.value['macd'] ?? 0.0);
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.lightTheme.primaryColor,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                    // Signal Line
                    LineChartBarData(
                      spots: macdData.asMap().entries.map((entry) {
                        return FlSpot(
                            entry.key.toDouble(), entry.value['signal'] ?? 0.0);
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.getWarningColor(true),
                      barWidth: 1.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(enabled: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<double> _calculateRSI() {
    if (chartData.length < 14) return [];

    List<double> rsiValues = [];
    List<double> gains = [];
    List<double> losses = [];

    // Calculate price changes
    for (int i = 1; i < chartData.length; i++) {
      final change = (chartData[i]['close'] as num).toDouble() -
          (chartData[i - 1]['close'] as num).toDouble();
      gains.add(change > 0 ? change : 0);
      losses.add(change < 0 ? -change : 0);
    }

    // Calculate RSI for each period
    for (int i = 13; i < gains.length; i++) {
      final avgGain = gains.sublist(i - 13, i + 1).reduce((a, b) => a + b) / 14;
      final avgLoss =
          losses.sublist(i - 13, i + 1).reduce((a, b) => a + b) / 14;

      if (avgLoss == 0) {
        rsiValues.add(100);
      } else {
        final rs = avgGain / avgLoss;
        final rsi = 100 - (100 / (1 + rs));
        rsiValues.add(rsi);
      }
    }

    return rsiValues;
  }

  List<Map<String, double>> _calculateMACD() {
    if (chartData.length < 26) return [];

    List<Map<String, double>> macdData = [];
    List<double> prices =
        chartData.map((e) => (e['close'] as num).toDouble()).toList();

    // Calculate EMAs
    List<double> ema12 = _calculateEMA(prices, 12);
    List<double> ema26 = _calculateEMA(prices, 26);

    // Calculate MACD line
    List<double> macdLine = [];
    for (int i = 0; i < ema12.length && i < ema26.length; i++) {
      macdLine.add(ema12[i] - ema26[i]);
    }

    // Calculate Signal line (9-period EMA of MACD)
    List<double> signalLine = _calculateEMA(macdLine, 9);

    // Combine data
    for (int i = 0; i < macdLine.length && i < signalLine.length; i++) {
      macdData.add({
        'macd': macdLine[i],
        'signal': signalLine[i],
        'histogram': macdLine[i] - signalLine[i],
      });
    }

    return macdData;
  }

  List<double> _calculateEMA(List<double> prices, int period) {
    if (prices.length < period) return [];

    List<double> ema = [];
    double multiplier = 2.0 / (period + 1);

    // First EMA is SMA
    double sma = prices.sublist(0, period).reduce((a, b) => a + b) / period;
    ema.add(sma);

    // Calculate subsequent EMAs
    for (int i = period; i < prices.length; i++) {
      double currentEma =
          (prices[i] * multiplier) + (ema.last * (1 - multiplier));
      ema.add(currentEma);
    }

    return ema;
  }

  Color _getRSIColor(double rsi) {
    if (rsi >= 70) {
      return AppTheme.getErrorColor(true); // Overbought
    } else if (rsi <= 30) {
      return AppTheme.getSuccessColor(true); // Oversold
    } else {
      return AppTheme.lightTheme.primaryColor; // Neutral
    }
  }

  Color _getMACDColor(double macd) {
    return macd >= 0
        ? AppTheme.getSuccessColor(true)
        : AppTheme.getErrorColor(true);
  }
}
