import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ldc_signal_service.dart';

class LDCIndicatorsOverlayWidget extends StatefulWidget {
  final List<Map<String, double>> chartData;
  final LDCSignal? currentSignal;
  final LDCSettings settings;
  final bool showKernelEstimate;
  final bool showPredictions;
  final bool showFeatures;

  const LDCIndicatorsOverlayWidget({
    Key? key,
    required this.chartData,
    this.currentSignal,
    required this.settings,
    this.showKernelEstimate = true,
    this.showPredictions = true,
    this.showFeatures = false,
  }) : super(key: key);

  @override
  State<LDCIndicatorsOverlayWidget> createState() =>
      _LDCIndicatorsOverlayWidgetState();
}

class _LDCIndicatorsOverlayWidgetState extends State<LDCIndicatorsOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chartData.isEmpty) return Container();

    return Stack(
      children: [
        // Kernel Regression Line
        if (widget.showKernelEstimate && widget.currentSignal != null)
          _buildKernelRegressionLine(),

        // LDC Signal Markers
        if (widget.currentSignal != null &&
            !widget.currentSignal!.isNeutralSignal)
          _buildLDCSignalMarker(),

        // Prediction Confidence Indicator
        if (widget.showPredictions && widget.currentSignal != null)
          _buildPredictionIndicator(),

        // Feature Values Overlay
        if (widget.showFeatures && widget.currentSignal != null)
          _buildFeatureOverlay(),

        // Filter Status Indicators
        if (widget.currentSignal != null) _buildFilterStatusIndicators(),
      ],
    );
  }

  Widget _buildKernelRegressionLine() {
    // Simplified kernel regression visualization
    return Positioned.fill(
      child: CustomPaint(
        painter: KernelRegressionPainter(
          chartData: widget.chartData,
          kernelEstimate: widget.currentSignal!.kernelEstimate,
          color: widget.currentSignal!.isBuySignal
              ? AppTheme.getSuccessColor(true).withValues(alpha: 0.6)
              : AppTheme.getErrorColor(true).withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildLDCSignalMarker() {
    final signal = widget.currentSignal!;
    final isBuySignal = signal.isBuySignal;

    return Positioned(
      right: 4.w,
      top: 20.h,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isBuySignal
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.getErrorColor(true),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isBuySignal
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.getErrorColor(true))
                        .withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: CustomIconWidget(
                      iconName: 'precision_manufacturing',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(signal.confidence),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPredictionIndicator() {
    final signal = widget.currentSignal!;

    return Positioned(
      top: 4.h,
      left: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: signal.isBuySignal
                ? AppTheme.getSuccessColor(true)
                : AppTheme.getErrorColor(true),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'psychology',
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'LDC Prediction',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  signal.signalType,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: signal.isBuySignal
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.getErrorColor(true),
                      ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${signal.confidence.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getConfidenceColor(signal.confidence),
                      ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Container(
              width: 20.w,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                widthFactor: signal.confidence / 100,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(signal.confidence),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureOverlay() {
    final features = widget.currentSignal!.features;

    return Positioned(
      bottom: 4.h,
      left: 4.w,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'tune',
                  color: Theme.of(context).colorScheme.secondary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Feature Values',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            if (widget.settings.featureCount >= 1)
              _buildFeatureValue(widget.settings.f1String, features.f1),
            if (widget.settings.featureCount >= 2)
              _buildFeatureValue(widget.settings.f2String, features.f2),
            if (widget.settings.featureCount >= 3)
              _buildFeatureValue(widget.settings.f3String, features.f3),
            if (widget.settings.featureCount >= 4)
              _buildFeatureValue(widget.settings.f4String, features.f4),
            if (widget.settings.featureCount >= 5)
              _buildFeatureValue(widget.settings.f5String, features.f5),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureValue(String name, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.25.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            value.toStringAsFixed(2),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterStatusIndicators() {
    final filters = widget.currentSignal!.filters;

    return Positioned(
      top: 4.h,
      right: 4.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildFilterIndicator('Volatility', filters.volatility),
          SizedBox(height: 0.5.h),
          _buildFilterIndicator('Regime', filters.regime),
          SizedBox(height: 0.5.h),
          _buildFilterIndicator('ADX', filters.adx),
        ],
      ),
    );
  }

  Widget _buildFilterIndicator(String name, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
            : AppTheme.getErrorColor(true).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive
              ? AppTheme.getSuccessColor(true)
              : AppTheme.getErrorColor(true),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.getErrorColor(true),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            name,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.getErrorColor(true),
                ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) {
      return AppTheme.getSuccessColor(true);
    } else if (confidence >= 60) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.getErrorColor(true);
    }
  }
}

class KernelRegressionPainter extends CustomPainter {
  final List<Map<String, double>> chartData;
  final double kernelEstimate;
  final Color color;

  KernelRegressionPainter({
    required this.chartData,
    required this.kernelEstimate,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (chartData.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Simplified kernel regression line
    final points = <Offset>[];
    for (int i = 0; i < chartData.length; i++) {
      final x = (i / (chartData.length - 1)) * size.width;
      final y = size.height * 0.5; // Simplified to middle line
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);

    // Draw confidence band
    final bandPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final bandPath = Path();
    if (points.isNotEmpty) {
      bandPath.moveTo(points.first.dx, points.first.dy - 20);
      for (int i = 0; i < points.length; i++) {
        bandPath.lineTo(points[i].dx, points[i].dy - 20);
      }
      for (int i = points.length - 1; i >= 0; i--) {
        bandPath.lineTo(points[i].dx, points[i].dy + 20);
      }
      bandPath.close();
    }

    canvas.drawPath(bandPath, bandPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
