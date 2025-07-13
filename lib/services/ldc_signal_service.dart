import 'dart:math' as math;

/// Lorentzian Distance Classifier (LDC) Signal Service
/// Implements the machine learning strategy from Pine Script
class LDCSignalService {
  // Settings Object
  final LDCSettings settings;

  // Feature arrays for historical data
  final List<double> _f1Array = [];
  final List<double> _f2Array = [];
  final List<double> _f3Array = [];
  final List<double> _f4Array = [];
  final List<double> _f5Array = [];

  // Training labels array
  final List<int> _trainingLabels = [];

  // Predictions and distances
  final List<double> _predictions = [];
  final List<double> _distances = [];

  double _lastDistance = -1.0;
  int _prediction = 0;
  int _signal = 0; // -1: sell, 0: neutral, 1: buy

  LDCSignalService(this.settings);

  /// Calculate feature series based on feature type and parameters
  double calculateFeatureSeries(
      String featureType,
      List<double> prices,
      List<double> highs,
      List<double> lows,
      List<double> hlc3,
      int paramA,
      int paramB) {
    switch (featureType) {
      case "RSI":
        return _calculateRSI(prices, paramA);
      case "WT":
        return _calculateWT(hlc3, paramA, paramB);
      case "CCI":
        return _calculateCCI(hlc3, paramA);
      case "ADX":
        return _calculateADX(highs, lows, prices, paramA);
      default:
        return 0.0;
    }
  }

  /// Calculate Lorentzian Distance between current features and historical features
  double getLorentzianDistance(int index, FeatureSeries currentFeatures) {
    switch (settings.featureCount) {
      case 5:
        return math.log(1 + (currentFeatures.f1 - _f1Array[index]).abs()) +
            math.log(1 + (currentFeatures.f2 - _f2Array[index]).abs()) +
            math.log(1 + (currentFeatures.f3 - _f3Array[index]).abs()) +
            math.log(1 + (currentFeatures.f4 - _f4Array[index]).abs()) +
            math.log(1 + (currentFeatures.f5 - _f5Array[index]).abs());
      case 4:
        return math.log(1 + (currentFeatures.f1 - _f1Array[index]).abs()) +
            math.log(1 + (currentFeatures.f2 - _f2Array[index]).abs()) +
            math.log(1 + (currentFeatures.f3 - _f3Array[index]).abs()) +
            math.log(1 + (currentFeatures.f4 - _f4Array[index]).abs());
      case 3:
        return math.log(1 + (currentFeatures.f1 - _f1Array[index]).abs()) +
            math.log(1 + (currentFeatures.f2 - _f2Array[index]).abs()) +
            math.log(1 + (currentFeatures.f3 - _f3Array[index]).abs());
      case 2:
        return math.log(1 + (currentFeatures.f1 - _f1Array[index]).abs()) +
            math.log(1 + (currentFeatures.f2 - _f2Array[index]).abs());
      default:
        return 0.0;
    }
  }

  /// Main LDC signal generation method
  LDCSignal generateSignal(List<Map<String, double>> marketData) {
    if (marketData.length < settings.maxBarsBack) {
      return LDCSignal.neutral();
    }

    // Calculate current features
    final latest = marketData.last;
    final prices = marketData.map((e) => e['close']!).toList();
    final highs = marketData.map((e) => e['high']!).toList();
    final lows = marketData.map((e) => e['low']!).toList();
    final hlc3 = marketData
        .map((e) => (e['high']! + e['low']! + e['close']!) / 3)
        .toList();

    final currentFeatures = FeatureSeries(
      f1: calculateFeatureSeries(settings.f1String, prices, highs, lows, hlc3,
          settings.f1ParamA, settings.f1ParamB),
      f2: calculateFeatureSeries(settings.f2String, prices, highs, lows, hlc3,
          settings.f2ParamA, settings.f2ParamB),
      f3: calculateFeatureSeries(settings.f3String, prices, highs, lows, hlc3,
          settings.f3ParamA, settings.f3ParamB),
      f4: calculateFeatureSeries(settings.f4String, prices, highs, lows, hlc3,
          settings.f4ParamA, settings.f4ParamB),
      f5: calculateFeatureSeries(settings.f5String, prices, highs, lows, hlc3,
          settings.f5ParamA, settings.f5ParamB),
    );

    // Add current features to arrays
    _f1Array.add(currentFeatures.f1);
    _f2Array.add(currentFeatures.f2);
    _f3Array.add(currentFeatures.f3);
    _f4Array.add(currentFeatures.f4);
    _f5Array.add(currentFeatures.f5);

    // Calculate training label (price direction after 4 bars)
    if (marketData.length >= 5) {
      final currentPrice = latest['close']!;
      final futurePrice = marketData[marketData.length - 5]['close']!;
      final label = futurePrice < currentPrice
          ? -1
          : futurePrice > currentPrice
              ? 1
              : 0;
      _trainingLabels.add(label);
    }

    // Perform nearest neighbors search with Lorentzian distance
    _performNearestNeighborsSearch(currentFeatures);

    // Apply filters
    final filters = _applyFilters(marketData);

    // Generate final signal
    final signal = _prediction > 0 && filters.all
        ? 1
        : _prediction < 0 && filters.all
            ? -1
            : _signal;

    return LDCSignal(
      signal: signal,
      confidence: _calculateConfidence(),
      prediction: _prediction.toDouble(),
      features: currentFeatures,
      filters: filters,
      kernelEstimate: _calculateKernelEstimate(prices),
    );
  }

  /// Approximate Nearest Neighbors Search with Lorentzian Distance
  void _performNearestNeighborsSearch(FeatureSeries currentFeatures) {
    _lastDistance = -1.0;
    final maxIndex =
        math.min(settings.maxBarsBack - 1, _trainingLabels.length - 1);

    for (int i = 0; i < maxIndex; i++) {
      if (i % 4 != 0) continue; // Chronological spacing

      final distance = getLorentzianDistance(i, currentFeatures);

      if (distance >= _lastDistance) {
        _lastDistance = distance;
        _distances.add(distance);
        _predictions.add(_trainingLabels[i].toDouble());

        if (_predictions.length > settings.neighborsCount) {
          _lastDistance = _distances[(settings.neighborsCount * 3 / 4).round()];
          _distances.removeAt(0);
          _predictions.removeAt(0);
        }
      }
    }

    _prediction = _predictions.fold(0.0, (sum, pred) => sum + pred).round();
  }

  /// Apply various filters to the signal
  LDCFilters _applyFilters(List<Map<String, double>> marketData) {
    final volatilityFilter = settings.filterSettings.useVolatilityFilter
        ? _calculateVolatilityFilter(marketData)
        : true;
    final regimeFilter = settings.filterSettings.useRegimeFilter
        ? _calculateRegimeFilter(marketData)
        : true;
    final adxFilter = settings.filterSettings.useAdxFilter
        ? _calculateADXFilter(marketData)
        : true;

    return LDCFilters(
      volatility: volatilityFilter,
      regime: regimeFilter,
      adx: adxFilter,
      all: volatilityFilter && regimeFilter && adxFilter,
    );
  }

  // Technical indicator calculations
  double _calculateRSI(List<double> prices, int period) {
    if (prices.length < period + 1) return 50.0;

    double gainSum = 0.0;
    double lossSum = 0.0;

    for (int i = prices.length - period; i < prices.length; i++) {
      final change = prices[i] - prices[i - 1];
      if (change > 0) {
        gainSum += change;
      } else {
        lossSum -= change;
      }
    }

    final avgGain = gainSum / period;
    final avgLoss = lossSum / period;

    if (avgLoss == 0) return 100.0;

    final rs = avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }

  double _calculateWT(List<double> hlc3, int period1, int period2) {
    // Simplified Williams %R calculation
    if (hlc3.length < period1) return 0.0;

    final esa = _calculateEMA(hlc3, period1);
    final d = _calculateEMA(hlc3.map((x) => (x - esa).abs()).toList(), period1);
    final ci = (hlc3.last - esa) / (0.015 * d);

    return _calculateEMA([ci], period2);
  }

  double _calculateCCI(List<double> hlc3, int period) {
    if (hlc3.length < period) return 0.0;

    final sma =
        hlc3.sublist(hlc3.length - period).reduce((a, b) => a + b) / period;
    final meanDeviation = hlc3
            .sublist(hlc3.length - period)
            .map((x) => (x - sma).abs())
            .reduce((a, b) => a + b) /
        period;

    return (hlc3.last - sma) / (0.015 * meanDeviation);
  }

  double _calculateADX(
      List<double> highs, List<double> lows, List<double> closes, int period) {
    // Simplified ADX calculation
    if (highs.length < period + 1) return 0.0;

    final trueRanges = <double>[];
    final plusDMs = <double>[];
    final minusDMs = <double>[];

    for (int i = 1; i < highs.length; i++) {
      final tr = math.max(
          highs[i] - lows[i],
          math.max((highs[i] - closes[i - 1]).abs(),
              (lows[i] - closes[i - 1]).abs()));
      trueRanges.add(tr);

      final plusDM = highs[i] - highs[i - 1] > lows[i - 1] - lows[i]
          ? math.max(highs[i] - highs[i - 1], 0)
          : 0;
      final minusDM = lows[i - 1] - lows[i] > highs[i] - highs[i - 1]
          ? math.max(lows[i - 1] - lows[i], 0)
          : 0;

      plusDMs.add(plusDM.toDouble());
      minusDMs.add(minusDM.toDouble());
    }

    final atr =
        trueRanges.sublist(trueRanges.length - period).reduce((a, b) => a + b) /
            period;
    final plusDI =
        (plusDMs.sublist(plusDMs.length - period).reduce((a, b) => a + b) /
                period) /
            atr *
            100;
    final minusDI =
        (minusDMs.sublist(minusDMs.length - period).reduce((a, b) => a + b) /
                period) /
            atr *
            100;

    final dx = ((plusDI - minusDI).abs() / (plusDI + minusDI)) * 100;
    return dx;
  }

  double _calculateEMA(List<double> values, int period) {
    if (values.isEmpty) return 0.0;
    if (values.length == 1) return values.first;

    final multiplier = 2.0 / (period + 1);
    double ema = values.first;

    for (int i = 1; i < values.length; i++) {
      ema = (values[i] * multiplier) + (ema * (1 - multiplier));
    }

    return ema;
  }

  double _calculateConfidence() {
    if (_predictions.isEmpty) return 0.0;

    final totalPredictions = _predictions.length;
    final agreementCount = _predictions
        .where((p) => (_prediction > 0 && p > 0) || (_prediction < 0 && p < 0))
        .length;

    return (agreementCount / totalPredictions) * 100;
  }

  double _calculateKernelEstimate(List<double> prices) {
    // Simplified Nadaraya-Watson Kernel Regression
    if (prices.length < settings.kernelSettings.lookbackWindow)
      return prices.last;

    final window =
        prices.sublist(prices.length - settings.kernelSettings.lookbackWindow);
    return window.reduce((a, b) => a + b) / window.length;
  }

  bool _calculateVolatilityFilter(List<Map<String, double>> marketData) {
    // Simplified volatility filter
    if (marketData.length < 10) return true;

    final prices = marketData.map((e) => e['close']!).toList();
    final returns = <double>[];

    for (int i = 1; i < prices.length; i++) {
      returns.add((prices[i] - prices[i - 1]) / prices[i - 1]);
    }

    final volatility = _calculateStandardDeviation(returns);
    return volatility < 0.05; // 5% volatility threshold
  }

  bool _calculateRegimeFilter(List<Map<String, double>> marketData) {
    if (marketData.length < 20) return true;

    final prices = marketData.map((e) => e['close']!).toList();
    final sma20 =
        prices.sublist(prices.length - 20).reduce((a, b) => a + b) / 20;

    return (prices.last - sma20) / sma20 >
        settings.filterSettings.regimeThreshold;
  }

  bool _calculateADXFilter(List<Map<String, double>> marketData) {
    if (marketData.length < 15) return true;

    final highs = marketData.map((e) => e['high']!).toList();
    final lows = marketData.map((e) => e['low']!).toList();
    final closes = marketData.map((e) => e['close']!).toList();

    final adx = _calculateADX(highs, lows, closes, 14);
    return adx > settings.filterSettings.adxThreshold;
  }

  double _calculateStandardDeviation(List<double> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((x) => (x - mean) * (x - mean));
    final variance = squaredDiffs.reduce((a, b) => a + b) / values.length;

    return math.sqrt(variance);
  }
}

// Data classes
class LDCSettings {
  final double source;
  final int neighborsCount;
  final int maxBarsBack;
  final int featureCount;
  final int colorCompression;
  final bool showExits;
  final bool useDynamicExits;

  // Feature settings
  final String f1String;
  final int f1ParamA;
  final int f1ParamB;
  final String f2String;
  final int f2ParamA;
  final int f2ParamB;
  final String f3String;
  final int f3ParamA;
  final int f3ParamB;
  final String f4String;
  final int f4ParamA;
  final int f4ParamB;
  final String f5String;
  final int f5ParamA;
  final int f5ParamB;

  final LDCFilterSettings filterSettings;
  final LDCKernelSettings kernelSettings;

  const LDCSettings({
    this.source = 0.0,
    this.neighborsCount = 8,
    this.maxBarsBack = 2000,
    this.featureCount = 5,
    this.colorCompression = 1,
    this.showExits = false,
    this.useDynamicExits = false,
    this.f1String = "RSI",
    this.f1ParamA = 14,
    this.f1ParamB = 1,
    this.f2String = "WT",
    this.f2ParamA = 10,
    this.f2ParamB = 11,
    this.f3String = "CCI",
    this.f3ParamA = 20,
    this.f3ParamB = 1,
    this.f4String = "ADX",
    this.f4ParamA = 20,
    this.f4ParamB = 2,
    this.f5String = "RSI",
    this.f5ParamA = 9,
    this.f5ParamB = 1,
    required this.filterSettings,
    required this.kernelSettings,
  });
}

class LDCFilterSettings {
  final bool useVolatilityFilter;
  final bool useRegimeFilter;
  final bool useAdxFilter;
  final double regimeThreshold;
  final int adxThreshold;

  const LDCFilterSettings({
    this.useVolatilityFilter = true,
    this.useRegimeFilter = true,
    this.useAdxFilter = false,
    this.regimeThreshold = -0.1,
    this.adxThreshold = 20,
  });
}

class LDCKernelSettings {
  final bool useKernelFilter;
  final bool showKernelEstimate;
  final bool useKernelSmoothing;
  final int lookbackWindow;
  final double relativeWeighting;
  final int regressionLevel;
  final int lag;

  const LDCKernelSettings({
    this.useKernelFilter = true,
    this.showKernelEstimate = true,
    this.useKernelSmoothing = false,
    this.lookbackWindow = 8,
    this.relativeWeighting = 8.0,
    this.regressionLevel = 25,
    this.lag = 2,
  });
}

class FeatureSeries {
  final double f1;
  final double f2;
  final double f3;
  final double f4;
  final double f5;

  const FeatureSeries({
    required this.f1,
    required this.f2,
    required this.f3,
    required this.f4,
    required this.f5,
  });
}

class LDCFilters {
  final bool volatility;
  final bool regime;
  final bool adx;
  final bool all;

  const LDCFilters({
    required this.volatility,
    required this.regime,
    required this.adx,
    required this.all,
  });
}

class LDCSignal {
  final int signal; // -1: sell, 0: neutral, 1: buy
  final double confidence;
  final double prediction;
  final FeatureSeries features;
  final LDCFilters filters;
  final double kernelEstimate;

  const LDCSignal({
    required this.signal,
    required this.confidence,
    required this.prediction,
    required this.features,
    required this.filters,
    required this.kernelEstimate,
  });

  factory LDCSignal.neutral() {
    return LDCSignal(
      signal: 0,
      confidence: 0.0,
      prediction: 0.0,
      features: const FeatureSeries(f1: 0, f2: 0, f3: 0, f4: 0, f5: 0),
      filters: const LDCFilters(
          volatility: false, regime: false, adx: false, all: false),
      kernelEstimate: 0.0,
    );
  }

  String get signalType => signal > 0
      ? 'BUY'
      : signal < 0
          ? 'SELL'
          : 'NEUTRAL';

  bool get isBuySignal => signal > 0;
  bool get isSellSignal => signal < 0;
  bool get isNeutralSignal => signal == 0;
}
