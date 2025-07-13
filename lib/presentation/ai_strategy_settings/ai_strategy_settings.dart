import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../services/ldc_signal_service.dart';
import './widgets/advanced_settings_card_widget.dart';
import './widgets/ai_confidence_card_widget.dart';
import './widgets/ldc_strategy_card_widget.dart';
import './widgets/market_hours_card_widget.dart';
import './widgets/paper_trading_card_widget.dart';
import './widgets/profit_target_card_widget.dart';
import './widgets/risk_management_card_widget.dart';
import './widgets/strategy_toggle_card_widget.dart';

class AiStrategySettings extends StatefulWidget {
  const AiStrategySettings({super.key});

  @override
  State<AiStrategySettings> createState() => _AiStrategySettingsState();
}

class _AiStrategySettingsState extends State<AiStrategySettings> {
  // Risk Management Settings
  double maxDailyLossPercentage = 2.0;
  double positionSizingLimit = 10.0;
  double stopLossBuffer = 1.5;

  // AI Confidence Settings
  double aiConfidenceThreshold = 75.0;

  // Strategy Toggles
  bool rsiMomentumEnabled = true;
  bool macdCrossoverEnabled = true;
  bool patternRecognitionEnabled = false;
  bool volumeAnalysisEnabled = true;
  bool ldcStrategyEnabled = false;

  // LDC Strategy Settings
  LDCSettings ldcSettings = const LDCSettings(
    filterSettings: LDCFilterSettings(),
    kernelSettings: LDCKernelSettings(),
  );

  // Profit Target Settings
  double profitTargetPercentage = 1.2;
  bool trailingStopEnabled = true;
  double trailingStopPercentage = 0.8;

  // Market Hours Settings
  bool preMarketTradingEnabled = false;
  TimeOfDay marketStartTime = const TimeOfDay(hour: 9, minute: 15);
  TimeOfDay marketEndTime = const TimeOfDay(hour: 15, minute: 30);

  // Paper Trading
  bool paperTradingEnabled = false;

  // Advanced Settings
  bool advancedSettingsExpanded = false;
  int lookbackPeriod = 20;
  double clusteringSensitivity = 0.7;

  // Mock data for strategy performance
  final List<Map<String, dynamic>> strategyPerformance = [
    {
      "name": "RSI Momentum",
      "winRate": 68.5,
      "avgProfit": 1.2,
      "totalTrades": 145,
      "status": "active"
    },
    {
      "name": "MACD Crossover",
      "winRate": 72.3,
      "avgProfit": 1.4,
      "totalTrades": 98,
      "status": "active"
    },
    {
      "name": "Pattern Recognition",
      "winRate": 61.2,
      "avgProfit": 1.8,
      "totalTrades": 67,
      "status": "inactive"
    },
    {
      "name": "Volume Analysis",
      "winRate": 75.1,
      "avgProfit": 1.1,
      "totalTrades": 203,
      "status": "active"
    },
    {
      "name": "Lorentzian Distance Classifier",
      "winRate": 78.4,
      "avgProfit": 1.6,
      "totalTrades": 89,
      "status": "inactive"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'AI Strategy Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _showResetDialog(),
            child: Text(
              'Reset',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Paper Trading Card - Prominently displayed
            PaperTradingCardWidget(
              paperTradingEnabled: paperTradingEnabled,
              onToggle: (value) {
                setState(() {
                  paperTradingEnabled = value;
                });
                _showConfirmationDialog(
                    'Paper Trading ${value ? 'Enabled' : 'Disabled'}');
              },
            ),
            SizedBox(height: 3.h),

            // LDC Strategy Card - New advanced strategy
            LDCStrategyCardWidget(
              enabled: ldcStrategyEnabled,
              settings: ldcSettings,
              onToggle: (value) {
                setState(() {
                  ldcStrategyEnabled = value;
                });
                _showStrategyRestartDialog('Lorentzian Distance Classifier');
              },
              onSettingsChanged: (newSettings) {
                setState(() {
                  ldcSettings = newSettings;
                });
              },
            ),
            SizedBox(height: 3.h),

            // Risk Management Section
            RiskManagementCardWidget(
              maxDailyLossPercentage: maxDailyLossPercentage,
              positionSizingLimit: positionSizingLimit,
              stopLossBuffer: stopLossBuffer,
              onMaxDailyLossChanged: (value) {
                setState(() {
                  maxDailyLossPercentage = value;
                });
              },
              onPositionSizingChanged: (value) {
                setState(() {
                  positionSizingLimit = value;
                });
              },
              onStopLossBufferChanged: (value) {
                setState(() {
                  stopLossBuffer = value;
                });
              },
            ),
            SizedBox(height: 3.h),

            // AI Confidence Section
            AiConfidenceCardWidget(
              confidenceThreshold: aiConfidenceThreshold,
              onThresholdChanged: (value) {
                setState(() {
                  aiConfidenceThreshold = value;
                });
              },
            ),
            SizedBox(height: 3.h),

            // Strategy Toggles Section (Updated to include LDC)
            StrategyToggleCardWidget(
              strategies: strategyPerformance,
              rsiEnabled: rsiMomentumEnabled,
              macdEnabled: macdCrossoverEnabled,
              patternEnabled: patternRecognitionEnabled,
              volumeEnabled: volumeAnalysisEnabled,
              ldcEnabled: ldcStrategyEnabled,
              onRsiToggle: (value) {
                setState(() {
                  rsiMomentumEnabled = value;
                });
                _showStrategyRestartDialog('RSI Momentum');
              },
              onMacdToggle: (value) {
                setState(() {
                  macdCrossoverEnabled = value;
                });
                _showStrategyRestartDialog('MACD Crossover');
              },
              onPatternToggle: (value) {
                setState(() {
                  patternRecognitionEnabled = value;
                });
                _showStrategyRestartDialog('Pattern Recognition');
              },
              onVolumeToggle: (value) {
                setState(() {
                  volumeAnalysisEnabled = value;
                });
                _showStrategyRestartDialog('Volume Analysis');
              },
              onLdcToggle: (value) {
                setState(() {
                  ldcStrategyEnabled = value;
                });
                _showStrategyRestartDialog('Lorentzian Distance Classifier');
              },
            ),
            SizedBox(height: 3.h),

            // Profit Target Section
            ProfitTargetCardWidget(
              profitTargetPercentage: profitTargetPercentage,
              trailingStopEnabled: trailingStopEnabled,
              trailingStopPercentage: trailingStopPercentage,
              onProfitTargetChanged: (value) {
                setState(() {
                  profitTargetPercentage = value;
                });
              },
              onTrailingStopToggle: (value) {
                setState(() {
                  trailingStopEnabled = value;
                });
              },
              onTrailingStopPercentageChanged: (value) {
                setState(() {
                  trailingStopPercentage = value;
                });
              },
            ),
            SizedBox(height: 3.h),

            // Market Hours Section
            MarketHoursCardWidget(
              preMarketEnabled: preMarketTradingEnabled,
              marketStartTime: marketStartTime,
              marketEndTime: marketEndTime,
              onPreMarketToggle: (value) {
                setState(() {
                  preMarketTradingEnabled = value;
                });
              },
              onStartTimeChanged: (time) {
                setState(() {
                  marketStartTime = time;
                });
              },
              onEndTimeChanged: (time) {
                setState(() {
                  marketEndTime = time;
                });
              },
            ),
            SizedBox(height: 3.h),

            // Advanced Settings Section
            AdvancedSettingsCardWidget(
              isExpanded: advancedSettingsExpanded,
              lookbackPeriod: lookbackPeriod,
              clusteringSensitivity: clusteringSensitivity,
              onExpandToggle: () {
                setState(() {
                  advancedSettingsExpanded = !advancedSettingsExpanded;
                });
              },
              onLookbackPeriodChanged: (value) {
                setState(() {
                  lookbackPeriod = value.round();
                });
              },
              onClusteringSensitivityChanged: (value) {
                setState(() {
                  clusteringSensitivity = value;
                });
              },
            ),
            SizedBox(height: 3.h),

            // Apply Changes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showApplyChangesDialog(),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Changes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Setting Updated',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showStrategyRestartDialog(String strategyName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Strategy Update',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            '$strategyName strategy will restart with new settings. This may take a few moments.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showApplyChangesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Apply Changes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to apply these changes? This will restart all active trading strategies.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _applyChanges();
              },
              child: Text(
                'Apply',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reset to Defaults',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'This will reset all settings to their default values. Are you sure?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetToDefaults();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(
                'Reset',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _applyChanges() {
    // Simulate applying changes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Settings applied successfully. Strategies are restarting...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      maxDailyLossPercentage = 2.0;
      positionSizingLimit = 10.0;
      stopLossBuffer = 1.5;
      aiConfidenceThreshold = 75.0;
      rsiMomentumEnabled = true;
      macdCrossoverEnabled = true;
      patternRecognitionEnabled = false;
      volumeAnalysisEnabled = true;
      ldcStrategyEnabled = false;
      ldcSettings = const LDCSettings(
        filterSettings: LDCFilterSettings(),
        kernelSettings: LDCKernelSettings(),
      );
      profitTargetPercentage = 1.2;
      trailingStopEnabled = true;
      trailingStopPercentage = 0.8;
      preMarketTradingEnabled = false;
      marketStartTime = const TimeOfDay(hour: 9, minute: 15);
      marketEndTime = const TimeOfDay(hour: 15, minute: 30);
      paperTradingEnabled = false;
      advancedSettingsExpanded = false;
      lookbackPeriod = 20;
      clusteringSensitivity = 0.7;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Settings reset to defaults',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
