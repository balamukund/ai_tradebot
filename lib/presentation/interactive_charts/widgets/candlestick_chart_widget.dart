import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CandlestickChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> chartData;
  final String selectedStock;
  final String timeframe;

  const CandlestickChartWidget({
    Key? key,
    required this.chartData,
    required this.selectedStock,
    required this.timeframe,
  }) : super(key: key);

  @override
  State<CandlestickChartWidget> createState() => _CandlestickChartWidgetState();
}

class _CandlestickChartWidgetState extends State<CandlestickChartWidget> {
  bool showCrosshair = false;
  Offset? crosshairPosition;
  Map<String, dynamic>? selectedCandle;

  @override
  Widget build(BuildContext context) {
    if (widget.chartData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'show_chart',
              color: AppTheme.lightTheme.textTheme.bodyMedium?.color ??
                  Colors.grey,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No chart data available',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stock Info Header
          _buildStockHeader(),
          SizedBox(height: 2.h),

          // Chart Area
          Expanded(
            child: GestureDetector(
              onLongPressStart: (details) => _showCrosshair(details),
              onLongPressMoveUpdate: (details) => _updateCrosshair(details),
              onLongPressEnd: (details) => _hideCrosshair(),
              child: Stack(
                children: [
                  // Main Chart
                  LineChart(
                    _buildChartData(),
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  ),

                  // Crosshair Overlay
                  if (showCrosshair && crosshairPosition != null)
                    _buildCrosshairOverlay(),
                ],
              ),
            ),
          ),

          // Price Info
          if (selectedCandle != null) _buildPriceInfo(),
        ],
      ),
    );
  }

  Widget _buildStockHeader() {
    final currentPrice = widget.chartData.isNotEmpty
        ? widget.chartData.last['close'] as double
        : 0.0;
    final previousPrice = widget.chartData.length > 1
        ? widget.chartData[widget.chartData.length - 2]['close'] as double
        : currentPrice;
    final change = currentPrice - previousPrice;
    final changePercent =
        previousPrice != 0 ? (change / previousPrice) * 100 : 0.0;
    final isPositive = change >= 0;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.selectedStock,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Text(
                    '₹${currentPrice.toStringAsFixed(2)}',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: isPositive
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.getErrorColor(true),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? AppTheme.getSuccessColor(true)
                              .withValues(alpha: 0.1)
                          : AppTheme.getErrorColor(true).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                          '${isPositive ? '+' : ''}${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)',
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
                  ),
                ],
              ),
            ],
          ),
        ),
        // Real-time indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(true),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                'LIVE',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.getSuccessColor(true),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  LineChartData _buildChartData() {
    final spots = widget.chartData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return FlSpot(index.toDouble(), (data['close'] as num).toDouble());
    }).toList();

    final minY = widget.chartData
        .map((e) => (e['low'] as num).toDouble())
        .reduce((a, b) => a < b ? a : b);
    final maxY = widget.chartData
        .map((e) => (e['high'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: (maxY - minY) / 5,
        verticalInterval: widget.chartData.length / 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppTheme.lightTheme.dividerColor,
          strokeWidth: 0.5,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: AppTheme.lightTheme.dividerColor,
          strokeWidth: 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: widget.chartData.length / 4,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < widget.chartData.length) {
                final date = widget.chartData[index]['timestamp'] as DateTime;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${date.day}/${date.month}',
                    style: AppTheme.lightTheme.textTheme.labelSmall,
                  ),
                );
              }
              return Container();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            interval: (maxY - minY) / 4,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '₹${value.toStringAsFixed(0)}',
                  style: AppTheme.lightTheme.textTheme.labelSmall,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      minX: 0,
      maxX: (widget.chartData.length - 1).toDouble(),
      minY: minY - padding,
      maxY: maxY + padding,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: AppTheme.lightTheme.primaryColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              if (index >= 0 && index < widget.chartData.length) {
                final data = widget.chartData[index];
                return LineTooltipItem(
                  '₹${(data['close'] as num).toStringAsFixed(2)}',
                  AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ) ??
                      TextStyle(),
                );
              }
              return null;
            }).toList();
          },
        ),
      ),
    );
  }

  Widget _buildCrosshairOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: CrosshairPainter(
          position: crosshairPosition!,
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildPriceInfo() {
    final data = selectedCandle!;
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lightTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildPriceItem('Open', data['open'] as double),
              ),
              Expanded(
                child: _buildPriceItem('High', data['high'] as double),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildPriceItem('Low', data['low'] as double),
              ),
              Expanded(
                child: _buildPriceItem('Close', data['close'] as double),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildPriceItem('Volume', (data['volume'] as num).toDouble(),
              isVolume: true),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String label, double value, {bool isVolume = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.textTheme.bodyMedium?.color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          isVolume ? _formatVolume(value) : '₹${value.toStringAsFixed(2)}',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 10000000) {
      return '${(volume / 10000000).toStringAsFixed(1)}Cr';
    } else if (volume >= 100000) {
      return '${(volume / 100000).toStringAsFixed(1)}L';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toStringAsFixed(0);
  }

  void _showCrosshair(LongPressStartDetails details) {
    setState(() {
      showCrosshair = true;
      crosshairPosition = details.localPosition;
      _updateSelectedCandle(details.localPosition);
    });
    HapticFeedback.mediumImpact();
  }

  void _updateCrosshair(LongPressMoveUpdateDetails details) {
    setState(() {
      crosshairPosition = details.localPosition;
      _updateSelectedCandle(details.localPosition);
    });
  }

  void _hideCrosshair() {
    setState(() {
      showCrosshair = false;
      crosshairPosition = null;
      selectedCandle = null;
    });
  }

  void _updateSelectedCandle(Offset position) {
    // Simple approximation - in a real app, you'd calculate the exact data point
    final index =
        (position.dx / (100.w - 6.w) * widget.chartData.length).round();
    if (index >= 0 && index < widget.chartData.length) {
      selectedCandle = widget.chartData[index];
    }
  }
}

class CrosshairPainter extends CustomPainter {
  final Offset position;
  final Color color;

  CrosshairPainter({required this.position, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Vertical line
    canvas.drawLine(
      Offset(position.dx, 0),
      Offset(position.dx, size.height),
      paint,
    );

    // Horizontal line
    canvas.drawLine(
      Offset(0, position.dy),
      Offset(size.width, position.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
