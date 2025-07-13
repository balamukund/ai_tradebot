import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AISignalsOverlayWidget extends StatefulWidget {
  final List<Map<String, dynamic>> signals;
  final List<Map<String, dynamic>> chartData;

  const AISignalsOverlayWidget({
    Key? key,
    required this.signals,
    required this.chartData,
  }) : super(key: key);

  @override
  State<AISignalsOverlayWidget> createState() => _AISignalsOverlayWidgetState();
}

class _AISignalsOverlayWidgetState extends State<AISignalsOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Map<String, dynamic>? selectedSignal;

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
    if (widget.signals.isEmpty) return Container();

    return Stack(
      children: [
        // Signal Markers
        ...widget.signals.map((signal) => _buildSignalMarker(signal)),

        // Signal Details Popup
        if (selectedSignal != null) _buildSignalDetails(),
      ],
    );
  }

  Widget _buildSignalMarker(Map<String, dynamic> signal) {
    final isBuySignal = signal['type'] == 'BUY';
    final confidence = signal['confidence'] as double;
    final position = _calculateSignalPosition(signal);

    return Positioned(
      left: position.dx - 15,
      top: position.dy - 15,
      child: GestureDetector(
        onTap: () => _showSignalDetails(signal),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 30,
                height: 30,
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
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: CustomIconWidget(
                        iconName: isBuySignal ? 'trending_up' : 'trending_down',
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    // Confidence indicator
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getConfidenceColor(confidence),
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
      ),
    );
  }

  Widget _buildSignalDetails() {
    final signal = selectedSignal!;
    final isBuySignal = signal['type'] == 'BUY';
    final confidence = signal['confidence'] as double;
    final price = signal['price'] as double;
    final reasoning = signal['reasoning'] as String;

    return Positioned(
      top: 10.h,
      left: 4.w,
      right: 4.w,
      child: GestureDetector(
        onTap: () => _hideSignalDetails(),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.shadowColor,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: (isBuySignal
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getErrorColor(true))
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName:
                              isBuySignal ? 'trending_up' : 'trending_down',
                          color: isBuySignal
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getErrorColor(true),
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${signal['type']} SIGNAL',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: isBuySignal
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.getErrorColor(true),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _hideSignalDetails,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.dividerColor
                            .withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color:
                            AppTheme.lightTheme.textTheme.bodyMedium?.color ??
                                Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Price and Confidence
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'Target Price',
                      '₹${price.toStringAsFixed(2)}',
                      CustomIconWidget(
                        iconName: 'attach_money',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildDetailItem(
                      'Confidence',
                      '${(confidence * 100).toStringAsFixed(0)}%',
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getConfidenceColor(confidence),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // AI Reasoning
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'psychology',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'AI Analysis',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      reasoning,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _shareSignal(signal),
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 16,
                      ),
                      label: Text('Share'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _executeSignal(signal),
                      icon: CustomIconWidget(
                        iconName: isBuySignal
                            ? 'add_shopping_cart'
                            : 'remove_shopping_cart',
                        color: Colors.white,
                        size: 16,
                      ),
                      label: Text(isBuySignal ? 'Buy Now' : 'Sell Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBuySignal
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.getErrorColor(true),
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

  Widget _buildDetailItem(String label, String value, Widget icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Offset _calculateSignalPosition(Map<String, dynamic> signal) {
    // This is a simplified calculation
    // In a real implementation, you'd calculate based on chart dimensions and data
    final screenWidth = 100.w;
    final screenHeight = 40.h;

    // Mock position calculation
    final xPosition = screenWidth * 0.3 + (widget.signals.indexOf(signal) * 60);
    final yPosition = screenHeight * 0.4;

    return Offset(xPosition, yPosition);
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return AppTheme.getSuccessColor(true);
    } else if (confidence >= 0.6) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.getErrorColor(true);
    }
  }

  void _showSignalDetails(Map<String, dynamic> signal) {
    setState(() {
      selectedSignal = signal;
    });
    HapticFeedback.lightImpact();
  }

  void _hideSignalDetails() {
    setState(() {
      selectedSignal = null;
    });
  }

  void _shareSignal(Map<String, dynamic> signal) {
    final isBuySignal = signal['type'] == 'BUY';
    final price = signal['price'] as double;
    final confidence = signal['confidence'] as double;

    final shareText = '''
🤖 AI Trading Signal Alert!

${isBuySignal ? '📈 BUY' : '📉 SELL'} Signal Generated
💰 Target Price: ₹${price.toStringAsFixed(2)}
🎯 Confidence: ${(confidence * 100).toStringAsFixed(0)}%
🧠 AI Analysis: ${signal['reasoning']}

#AITrading #StockMarket #TradingSignals
    ''';

    // In a real app, you'd use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signal shared successfully!'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );

    _hideSignalDetails();
  }

  void _executeSignal(Map<String, dynamic> signal) {
    final isBuySignal = signal['type'] == 'BUY';

    // Navigate to trade execution screen
    Navigator.pushNamed(
      context,
      '/trade-execution',
      arguments: {
        'signal': signal,
        'action': isBuySignal ? 'BUY' : 'SELL',
      },
    );

    _hideSignalDetails();
  }
}
