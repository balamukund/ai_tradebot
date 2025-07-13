import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/active_positions_widget.dart';
import './widgets/ai_signals_widget.dart';
import './widgets/performance_metrics_widget.dart';
import './widgets/portfolio_summary_card.dart';

class TradingDashboard extends StatefulWidget {
  const TradingDashboard({Key? key}) : super(key: key);

  @override
  State<TradingDashboard> createState() => _TradingDashboardState();
}

class _TradingDashboardState extends State<TradingDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  bool _isMarketOpen = true;
  bool _isConnected = true;

  // Mock data for trading dashboard
  final Map<String, dynamic> portfolioData = {
    "totalPnL": 12450.75,
    "dailyPerformance": 2.3,
    "profitTarget": 1.5,
    "currentProgress": 2.3,
    "totalValue": 545000.00,
    "dayChange": 12450.75,
    "dayChangePercent": 2.3,
  };

  final List<Map<String, dynamic>> performanceMetrics = [
    {
      "title": "Today's Trades",
      "value": "8",
      "subtitle": "Executed",
      "color": "success",
    },
    {
      "title": "Weekly Performance",
      "value": "+7.2%",
      "subtitle": "This Week",
      "color": "success",
    },
    {
      "title": "Risk Exposure",
      "value": "Medium",
      "subtitle": "Current Level",
      "color": "warning",
    },
  ];

  final List<Map<String, dynamic>> activePositions = [
    {
      "symbol": "RELIANCE",
      "entryPrice": 2450.50,
      "currentPrice": 2485.75,
      "quantity": 50,
      "pnl": 1762.50,
      "pnlPercent": 1.44,
      "stopLoss": 2400.00,
      "target": 2500.00,
    },
    {
      "symbol": "TCS",
      "entryPrice": 3650.25,
      "currentPrice": 3598.40,
      "quantity": 25,
      "pnl": -1296.25,
      "pnlPercent": -1.42,
      "stopLoss": 3580.00,
      "target": 3750.00,
    },
    {
      "symbol": "HDFC BANK",
      "entryPrice": 1580.75,
      "currentPrice": 1595.20,
      "quantity": 75,
      "pnl": 1083.75,
      "pnlPercent": 0.91,
      "stopLoss": 1550.00,
      "target": 1620.00,
    },
  ];

  final List<Map<String, dynamic>> aiSignals = [
    {
      "symbol": "INFY",
      "signal": "BUY",
      "confidence": 87,
      "targetPrice": 1450.00,
      "currentPrice": 1385.50,
      "reasoning":
          "Strong bullish momentum with RSI oversold recovery and positive MACD crossover",
      "timeframe": "Intraday",
      "riskLevel": "Low",
    },
    {
      "symbol": "WIPRO",
      "signal": "SELL",
      "confidence": 73,
      "targetPrice": 420.00,
      "currentPrice": 445.25,
      "reasoning":
          "Bearish divergence detected with volume confirmation and resistance at key levels",
      "timeframe": "Short Term",
      "riskLevel": "Medium",
    },
    {
      "symbol": "ICICI BANK",
      "signal": "BUY",
      "confidence": 92,
      "targetPrice": 980.00,
      "currentPrice": 925.75,
      "reasoning":
          "Breakout above resistance with strong volume and positive sector sentiment",
      "timeframe": "Swing",
      "riskLevel": "Low",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _showNewTradeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Trade',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 3.h),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'trending_up',
                      color: AppTheme.getSuccessColor(true),
                      size: 24,
                    ),
                    title: const Text('Manual Trade'),
                    subtitle: const Text('Execute trade manually'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToScreen('/trade-execution');
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: AppTheme.getAccentColor(true),
                      size: 24,
                    ),
                    title: const Text('AI Recommended'),
                    subtitle: const Text('Execute AI signal'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToScreen('/ai-strategy-settings');
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'analytics',
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                    title: const Text('View Charts'),
                    subtitle: const Text('Analyze before trading'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToScreen('/interactive-charts');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'AI TradeBot',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _isMarketOpen
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.getErrorColor(true),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _isMarketOpen ? 'OPEN' : 'CLOSED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: _isConnected ? 'wifi' : 'wifi_off',
              color: _isConnected
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.getErrorColor(true),
              size: 20,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Charts'),
            Tab(text: 'Trades'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildChartsTab(),
          _buildTradesTab(),
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewTradeDialog,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 20,
        ),
        label: const Text('New Trade'),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portfolio Summary Card
            PortfolioSummaryCard(
              portfolioData: portfolioData,
              isRefreshing: _isRefreshing,
            ),
            SizedBox(height: 3.h),

            // Performance Metrics
            PerformanceMetricsWidget(
              metrics: performanceMetrics,
            ),
            SizedBox(height: 3.h),

            // Active Positions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Positions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => _navigateToScreen('/trade-history'),
                  child: const Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            ActivePositionsWidget(
              positions: activePositions,
              onModifyStopLoss: (symbol) {
                // Handle modify stop loss
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Modify stop loss for \$symbol')),
                );
              },
              onBookProfit: (symbol) {
                // Handle book profit
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Book profit for \$symbol')),
                );
              },
              onClosePosition: (symbol) {
                // Handle close position
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Close position for \$symbol')),
                );
              },
            ),
            SizedBox(height: 3.h),

            // AI Signals Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AI Signals',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => _navigateToScreen('/ai-strategy-settings'),
                  child: const Text('Settings'),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            AISignalsWidget(
              signals: aiSignals,
              onSignalTap: (signal) {
                _showSignalDetails(signal);
              },
            ),
            SizedBox(height: 10.h), // Extra space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildChartsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'show_chart',
            color: Theme.of(context).primaryColor,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Interactive Charts',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Tap to view detailed charts',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () => _navigateToScreen('/interactive-charts'),
            child: const Text('Open Charts'),
          ),
        ],
      ),
    );
  }

  Widget _buildTradesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: Theme.of(context).primaryColor,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Trade History',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'View your trading history',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () => _navigateToScreen('/trade-history'),
            child: const Text('View History'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 3.h),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'account_balance',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            title: const Text('Brokerage Account'),
            subtitle: const Text('Manage your trading account'),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: Colors.grey,
              size: 20,
            ),
            onTap: () => _navigateToScreen('/brokerage-account-setup'),
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'smart_toy',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            title: const Text('AI Strategy'),
            subtitle: const Text('Configure AI trading parameters'),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: Colors.grey,
              size: 20,
            ),
            onTap: () => _navigateToScreen('/ai-strategy-settings'),
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'notifications',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            title: const Text('Notifications'),
            subtitle: const Text('Manage alerts and notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'security',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            title: const Text('Security'),
            subtitle: const Text('Biometric authentication'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'dark_mode',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle theme'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  void _showSignalDetails(Map<String, dynamic> signal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          signal["symbol"] as String,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: (signal["signal"] as String) == "BUY"
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.getErrorColor(true),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            signal["signal"] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    _buildSignalDetailRow(
                        'Confidence', '${signal["confidence"]}%'),
                    _buildSignalDetailRow('Current Price',
                        '₹${(signal["currentPrice"] as double).toStringAsFixed(2)}'),
                    _buildSignalDetailRow('Target Price',
                        '₹${(signal["targetPrice"] as double).toStringAsFixed(2)}'),
                    _buildSignalDetailRow(
                        'Timeframe', signal["timeframe"] as String),
                    _buildSignalDetailRow(
                        'Risk Level', signal["riskLevel"] as String),
                    SizedBox(height: 3.h),
                    Text(
                      'AI Reasoning',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      signal["reasoning"] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Dismiss'),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToScreen('/trade-execution');
                            },
                            child: const Text('Execute Trade'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
