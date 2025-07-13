import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ldc_signal_service.dart';
import '../../../widgets/custom_icon_widget.dart';

class LDCStrategyCardWidget extends StatefulWidget {
  final bool enabled;
  final LDCSettings settings;
  final Function(bool) onToggle;
  final Function(LDCSettings) onSettingsChanged;

  const LDCStrategyCardWidget({
    super.key,
    required this.enabled,
    required this.settings,
    required this.onToggle,
    required this.onSettingsChanged,
  });

  @override
  State<LDCStrategyCardWidget> createState() => _LDCStrategyCardWidgetState();
}

class _LDCStrategyCardWidgetState extends State<LDCStrategyCardWidget> {
  bool _isExpanded = false;
  late LDCSettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: widget.enabled
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1)
                        : Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'precision_manufacturing',
                    color: widget.enabled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lorentzian Distance Classifier',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: widget.enabled
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Advanced ML algorithm using k-nearest neighbors with Lorentzian distance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: widget.enabled,
                  onChanged: widget.onToggle,
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Strategy Info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'How LDC Works',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'LDC uses Lorentzian distance instead of Euclidean distance to account for market "warping" effects from major economic events, providing more accurate pattern recognition in volatile conditions.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context: context,
                    label: 'Neighbors',
                    value: _currentSettings.neighborsCount.toString(),
                    icon: 'group',
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildStatItem(
                    context: context,
                    label: 'Features',
                    value: _currentSettings.featureCount.toString(),
                    icon: 'tune',
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildStatItem(
                    context: context,
                    label: 'Lookback',
                    value: _currentSettings.maxBarsBack.toString(),
                    icon: 'history',
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Expand/Collapse Button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  _isExpanded
                      ? 'Hide Advanced Settings'
                      : 'Show Advanced Settings',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ),

            // Advanced Settings
            if (_isExpanded) ...[
              SizedBox(height: 2.h),
              _buildAdvancedSettings(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String label,
    required String value,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 0.25.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // General Settings Section
        _buildSectionHeader('General Settings'),
        SizedBox(height: 1.h),

        _buildSliderSetting(
          'Neighbors Count',
          'Number of nearest neighbors to consider',
          _currentSettings.neighborsCount.toDouble(),
          1,
          50,
          (value) {
            _updateSettings(
                _currentSettings.copyWith(neighborsCount: value.round()));
          },
        ),

        _buildSliderSetting(
          'Feature Count',
          'Number of features to use for ML predictions',
          _currentSettings.featureCount.toDouble(),
          2,
          5,
          (value) {
            _updateSettings(
                _currentSettings.copyWith(featureCount: value.round()));
          },
        ),

        SizedBox(height: 2.h),

        // Feature Engineering Section
        _buildSectionHeader('Feature Engineering'),
        SizedBox(height: 1.h),

        _buildFeatureSelector(1, _currentSettings.f1String,
            _currentSettings.f1ParamA, _currentSettings.f1ParamB),
        _buildFeatureSelector(2, _currentSettings.f2String,
            _currentSettings.f2ParamA, _currentSettings.f2ParamB),
        if (_currentSettings.featureCount >= 3)
          _buildFeatureSelector(3, _currentSettings.f3String,
              _currentSettings.f3ParamA, _currentSettings.f3ParamB),
        if (_currentSettings.featureCount >= 4)
          _buildFeatureSelector(4, _currentSettings.f4String,
              _currentSettings.f4ParamA, _currentSettings.f4ParamB),
        if (_currentSettings.featureCount >= 5)
          _buildFeatureSelector(5, _currentSettings.f5String,
              _currentSettings.f5ParamA, _currentSettings.f5ParamB),

        SizedBox(height: 2.h),

        // Filter Settings Section
        _buildSectionHeader('Filters'),
        SizedBox(height: 1.h),

        _buildSwitchSetting(
          'Volatility Filter',
          'Filter signals based on market volatility',
          _currentSettings.filterSettings.useVolatilityFilter,
          (value) {
            _updateSettings(_currentSettings.copyWith(
              filterSettings: _currentSettings.filterSettings
                  .copyWith(useVolatilityFilter: value),
            ));
          },
        ),

        _buildSwitchSetting(
          'Regime Filter',
          'Filter signals based on market regime',
          _currentSettings.filterSettings.useRegimeFilter,
          (value) {
            _updateSettings(_currentSettings.copyWith(
              filterSettings: _currentSettings.filterSettings
                  .copyWith(useRegimeFilter: value),
            ));
          },
        ),

        _buildSwitchSetting(
          'ADX Filter',
          'Filter signals based on ADX trend strength',
          _currentSettings.filterSettings.useAdxFilter,
          (value) {
            _updateSettings(_currentSettings.copyWith(
              filterSettings:
                  _currentSettings.filterSettings.copyWith(useAdxFilter: value),
            ));
          },
        ),

        SizedBox(height: 2.h),

        // Kernel Settings Section
        _buildSectionHeader('Kernel Regression'),
        SizedBox(height: 1.h),

        _buildSwitchSetting(
          'Use Kernel Filter',
          'Apply Nadaraya-Watson kernel regression filter',
          _currentSettings.kernelSettings.useKernelFilter,
          (value) {
            _updateSettings(_currentSettings.copyWith(
              kernelSettings: _currentSettings.kernelSettings
                  .copyWith(useKernelFilter: value),
            ));
          },
        ),

        _buildSliderSetting(
          'Lookback Window',
          'Number of bars for kernel estimation',
          _currentSettings.kernelSettings.lookbackWindow.toDouble(),
          3,
          50,
          (value) {
            _updateSettings(_currentSettings.copyWith(
              kernelSettings: _currentSettings.kernelSettings
                  .copyWith(lookbackWindow: value.round()),
            ));
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    String description,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              value.round().toString(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        SizedBox(height: 1.h),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget _buildFeatureSelector(
      int featureNum, String currentType, int paramA, int paramB) {
    final features = ['RSI', 'WT', 'CCI', 'ADX'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feature $featureNum',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: currentType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          ),
          items: features.map((feature) {
            return DropdownMenuItem(
              value: feature,
              child: Text(feature),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _updateFeature(featureNum, value, paramA, paramB);
            }
          },
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: paramA.toString(),
                decoration: InputDecoration(
                  labelText: 'Parameter A',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final param = int.tryParse(value) ?? paramA;
                  _updateFeature(featureNum, currentType, param, paramB);
                },
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: TextFormField(
                initialValue: paramB.toString(),
                decoration: InputDecoration(
                  labelText: 'Parameter B',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final param = int.tryParse(value) ?? paramB;
                  _updateFeature(featureNum, currentType, paramA, param);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  void _updateFeature(int featureNum, String type, int paramA, int paramB) {
    switch (featureNum) {
      case 1:
        _updateSettings(_currentSettings.copyWith(
          f1String: type,
          f1ParamA: paramA,
          f1ParamB: paramB,
        ));
        break;
      case 2:
        _updateSettings(_currentSettings.copyWith(
          f2String: type,
          f2ParamA: paramA,
          f2ParamB: paramB,
        ));
        break;
      case 3:
        _updateSettings(_currentSettings.copyWith(
          f3String: type,
          f3ParamA: paramA,
          f3ParamB: paramB,
        ));
        break;
      case 4:
        _updateSettings(_currentSettings.copyWith(
          f4String: type,
          f4ParamA: paramA,
          f4ParamB: paramB,
        ));
        break;
      case 5:
        _updateSettings(_currentSettings.copyWith(
          f5String: type,
          f5ParamA: paramA,
          f5ParamB: paramB,
        ));
        break;
    }
  }

  void _updateSettings(LDCSettings newSettings) {
    setState(() {
      _currentSettings = newSettings;
    });
    widget.onSettingsChanged(newSettings);
  }
}

// Extension to add copyWith methods
extension LDCSettingsExtension on LDCSettings {
  LDCSettings copyWith({
    double? source,
    int? neighborsCount,
    int? maxBarsBack,
    int? featureCount,
    int? colorCompression,
    bool? showExits,
    bool? useDynamicExits,
    String? f1String,
    int? f1ParamA,
    int? f1ParamB,
    String? f2String,
    int? f2ParamA,
    int? f2ParamB,
    String? f3String,
    int? f3ParamA,
    int? f3ParamB,
    String? f4String,
    int? f4ParamA,
    int? f4ParamB,
    String? f5String,
    int? f5ParamA,
    int? f5ParamB,
    LDCFilterSettings? filterSettings,
    LDCKernelSettings? kernelSettings,
  }) {
    return LDCSettings(
      source: source ?? this.source,
      neighborsCount: neighborsCount ?? this.neighborsCount,
      maxBarsBack: maxBarsBack ?? this.maxBarsBack,
      featureCount: featureCount ?? this.featureCount,
      colorCompression: colorCompression ?? this.colorCompression,
      showExits: showExits ?? this.showExits,
      useDynamicExits: useDynamicExits ?? this.useDynamicExits,
      f1String: f1String ?? this.f1String,
      f1ParamA: f1ParamA ?? this.f1ParamA,
      f1ParamB: f1ParamB ?? this.f1ParamB,
      f2String: f2String ?? this.f2String,
      f2ParamA: f2ParamA ?? this.f2ParamA,
      f2ParamB: f2ParamB ?? this.f2ParamB,
      f3String: f3String ?? this.f3String,
      f3ParamA: f3ParamA ?? this.f3ParamA,
      f3ParamB: f3ParamB ?? this.f3ParamB,
      f4String: f4String ?? this.f4String,
      f4ParamA: f4ParamA ?? this.f4ParamA,
      f4ParamB: f4ParamB ?? this.f4ParamB,
      f5String: f5String ?? this.f5String,
      f5ParamA: f5ParamA ?? this.f5ParamA,
      f5ParamB: f5ParamB ?? this.f5ParamB,
      filterSettings: filterSettings ?? this.filterSettings,
      kernelSettings: kernelSettings ?? this.kernelSettings,
    );
  }
}

extension LDCFilterSettingsExtension on LDCFilterSettings {
  LDCFilterSettings copyWith({
    bool? useVolatilityFilter,
    bool? useRegimeFilter,
    bool? useAdxFilter,
    double? regimeThreshold,
    int? adxThreshold,
  }) {
    return LDCFilterSettings(
      useVolatilityFilter: useVolatilityFilter ?? this.useVolatilityFilter,
      useRegimeFilter: useRegimeFilter ?? this.useRegimeFilter,
      useAdxFilter: useAdxFilter ?? this.useAdxFilter,
      regimeThreshold: regimeThreshold ?? this.regimeThreshold,
      adxThreshold: adxThreshold ?? this.adxThreshold,
    );
  }
}

extension LDCKernelSettingsExtension on LDCKernelSettings {
  LDCKernelSettings copyWith({
    bool? useKernelFilter,
    bool? showKernelEstimate,
    bool? useKernelSmoothing,
    int? lookbackWindow,
    double? relativeWeighting,
    int? regressionLevel,
    int? lag,
  }) {
    return LDCKernelSettings(
      useKernelFilter: useKernelFilter ?? this.useKernelFilter,
      showKernelEstimate: showKernelEstimate ?? this.showKernelEstimate,
      useKernelSmoothing: useKernelSmoothing ?? this.useKernelSmoothing,
      lookbackWindow: lookbackWindow ?? this.lookbackWindow,
      relativeWeighting: relativeWeighting ?? this.relativeWeighting,
      regressionLevel: regressionLevel ?? this.regressionLevel,
      lag: lag ?? this.lag,
    );
  }
}
