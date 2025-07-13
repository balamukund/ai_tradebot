import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_signals_overlay_widget.dart';
import './widgets/candlestick_chart_widget.dart';
import './widgets/chart_bottom_sheet_widget.dart';
import './widgets/chart_toolbar_widget.dart';
import './widgets/stock_selector_widget.dart';
import './widgets/technical_indicators_widget.dart';

class InteractiveCharts extends StatefulWidget {
  const InteractiveCharts({Key? key}) : super(key: key);

  @override
  State<InteractiveCharts> createState() => _InteractiveChartsState();
}

class _InteractiveChartsState extends State<InteractiveCharts>
    with TickerProviderStateMixin {
  // Controllers and Animation
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Chart Data and State
  String selectedStock = 'RELIANCE';
  String selectedTimeframe = '1D';
  bool showVolume = true;
  bool showRSI = true;
  bool showMACD = true;
  bool showAISignals = true;
  bool isLandscape = false;

  // Bottom Sheet Controller
  final DraggableScrollableController _bottomSheetController =
      DraggableScrollableController();

  // Mock Chart Data
  final List<Map<String, dynamic>> chartData = [
    {
      'timestamp': DateTime.now().subtract(Duration(days: 30)),
      'open': 2450.0,
      'high': 2480.0,
      'low': 2430.0,
      'close': 2470.0,
      'volume': 1250000,
    },
    {
      'timestamp': DateTime.now().subtract(Duration(days: 29)),
      'open': 2470.0,
      'high': 2490.0,
      'low': 2460.0,
      'close': 2485.0,
      'volume': 1180000,
    },
    {
      'timestamp': DateTime.now().subtract(Duration(days: 28)),
      'open': 2485.0,
      'high': 2510.0,
      'low': 2475.0,
      'close': 2495.0,
      'volume': 1320000,
    },
    {
      'timestamp': DateTime.now().subtract(Duration(days: 27)),
      'open': 2495.0,
      'high': 2520.0,
      'low': 2485.0,
      'close': 2505.0,
      'volume': 1450000,
    },
    {
      'timestamp': DateTime.now().subtract(Duration(days: 26)),
      'open': 2505.0,
      'high': 2530.0,
      'low': 2495.0,
      'close': 2515.0,
      'volume': 1380000,
    },
  ];

  // Mock AI Signals
  final List<Map<String, dynamic>> aiSignals = [
    {
      'type': 'BUY',
      'price': 2470.0,
      'timestamp': DateTime.now().subtract(Duration(days: 25)),
      'confidence': 0.85,
      'reasoning': 'Strong bullish momentum with RSI oversold recovery',
    },
    {
      'type': 'SELL',
      'price': 2515.0,
      'timestamp': DateTime.now().subtract(Duration(days: 20)),
      'confidence': 0.78,
      'reasoning': 'Resistance level reached with bearish divergence',
    },
  ];

  // Mock Watchlist
  final List<Map<String, dynamic>> watchlist = [
    {
      'symbol': 'RELIANCE',
      'name': 'Reliance Industries',
      'price': 2515.0,
      'change': 25.0,
      'changePercent': 1.01,
    },
    {
      'symbol': 'TCS',
      'name': 'Tata Consultancy Services',
      'price': 3650.0,
      'change': -15.0,
      'changePercent': -0.41,
    },
    {
      'symbol': 'INFY',
      'name': 'Infosys Limited',
      'price': 1450.0,
      'change': 12.0,
      'changePercent': 0.83,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _bottomSheetController.dispose();
    super.dispose();
  }

  void _onStockChanged(String stock) {
    setState(() {
      selectedStock = stock;
    });
    HapticFeedback.lightImpact();
  }

  void _onTimeframeChanged(String timeframe) {
    setState(() {
      selectedTimeframe = timeframe;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleIndicator(String indicator) {
    setState(() {
      switch (indicator) {
        case 'volume':
          showVolume = !showVolume;
          break;
        case 'rsi':
          showRSI = !showRSI;
          break;
        case 'macd':
          showMACD = !showMACD;
          break;
        case 'signals':
          showAISignals = !showAISignals;
          break;
      }
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          isLandscape = orientation == Orientation.landscape;
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Stock Selector
                StockSelectorWidget(
                  watchlist: watchlist,
                  selectedStock: selectedStock,
                  onStockChanged: _onStockChanged,
                ),

                // Chart Toolbar
                ChartToolbarWidget(
                  selectedTimeframe: selectedTimeframe,
                  onTimeframeChanged: _onTimeframeChanged,
                  showVolume: showVolume,
                  showRSI: showRSI,
                  showMACD: showMACD,
                  showAISignals: showAISignals,
                  onToggleIndicator: _toggleIndicator,
                ),

                // Main Chart Area
                Expanded(
                  child: Stack(
                    children: [
                      // Chart Container
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.shadowColor,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Main Candlestick Chart
                            Expanded(
                              flex: isLandscape ? 4 : 3,
                              child: CandlestickChartWidget(
                                chartData: chartData,
                                selectedStock: selectedStock,
                                timeframe: selectedTimeframe,
                              ),
                            ),

                            // Volume Chart
                            if (showVolume)
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  child: _buildVolumeChart(),
                                ),
                              ),

                            // Technical Indicators
                            if (showRSI || showMACD)
                              Expanded(
                                flex: isLandscape ? 2 : 1,
                                child: TechnicalIndicatorsWidget(
                                  showRSI: showRSI,
                                  showMACD: showMACD,
                                  chartData: chartData,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // AI Signals Overlay
                      if (showAISignals)
                        AISignalsOverlayWidget(
                          signals: aiSignals,
                          chartData: chartData,
                        ),
                    ],
                  ),
                ),

                // Bottom Navigation Tabs
                if (!isLandscape) _buildBottomTabs(),
              ],
            ),
          );
        },
      ),
      bottomSheet: isLandscape
          ? null
          : ChartBottomSheetWidget(
              controller: _bottomSheetController,
              onIndicatorToggle: _toggleIndicator,
              showVolume: showVolume,
              showRSI: showRSI,
              showMACD: showMACD,
              showAISignals: showAISignals,
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Interactive Charts',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.primaryColor,
      elevation: 2,
      actions: [
        IconButton(
          onPressed: () => _showSearchDialog(),
          icon: CustomIconWidget(
            iconName: 'search',
            color: Colors.white,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: () => _showAlertDialog(),
          icon: CustomIconWidget(
            iconName: 'notifications',
            color: Colors.white,
            size: 24,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value),
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: Colors.white,
            size: 24,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'fullscreen',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'fullscreen',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text('Fullscreen'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text('Export Chart'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVolumeChart() {
    return Container(
      height: 15.h,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: chartData
              .map((e) => (e['volume'] as num).toDouble())
              .reduce((a, b) => a > b ? a : b),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: chartData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (data['volume'] as num).toDouble(),
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.6),
                  width: 2.w,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'show_chart',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            text: 'Charts',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            text: 'Analysis',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            text: 'Settings',
          ),
        ],
        labelColor: AppTheme.lightTheme.primaryColor,
        unselectedLabelColor: AppTheme.lightTheme.textTheme.bodyMedium?.color,
        indicatorColor: AppTheme.lightTheme.primaryColor,
        onTap: (index) => _handleTabChange(index),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Stocks'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter stock symbol...',
            prefixIcon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            if (value.isNotEmpty) {
              _onStockChanged(value.toUpperCase());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Price Alert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Alert Price',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Alert Type'),
              items: ['Above', 'Below']
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Price alert created successfully')),
              );
            },
            child: Text('Create Alert'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'fullscreen':
        // Toggle fullscreen mode
        HapticFeedback.mediumImpact();
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chart exported successfully')),
        );
        break;
    }
  }

  void _handleTabChange(int index) {
    HapticFeedback.selectionClick();
    switch (index) {
      case 0:
        // Charts tab - already on charts screen
        break;
      case 1:
        Navigator.pushNamed(context, '/trading-dashboard');
        break;
      case 2:
        Navigator.pushNamed(context, '/ai-strategy-settings');
        break;
    }
  }
}
