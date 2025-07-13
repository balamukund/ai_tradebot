import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/trade_analytics_widget.dart';
import './widgets/trade_card_widget.dart';

class TradeHistory extends StatefulWidget {
  const TradeHistory({Key? key}) : super(key: key);

  @override
  State<TradeHistory> createState() => _TradeHistoryState();
}

class _TradeHistoryState extends State<TradeHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isSearching = false;
  bool _isMultiSelectMode = false;
  String _selectedDateRange = 'All Time';
  String _searchQuery = '';
  List<String> _selectedTradeIds = [];

  // Mock trade data
  final List<Map<String, dynamic>> _allTrades = [
    {
      "id": "TXN001",
      "symbol": "RELIANCE",
      "companyName": "Reliance Industries Ltd",
      "tradeType": "BUY",
      "quantity": 50,
      "price": 2450.75,
      "currentPrice": 2485.30,
      "pnl": 1727.50,
      "pnlPercentage": 1.41,
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "signalConfidence": 85,
      "aiSignal": "Strong Buy",
      "executionTime": "09:15:23",
      "orderType": "Market",
      "status": "Executed",
      "notes": "",
    },
    {
      "id": "TXN002",
      "symbol": "TCS",
      "companyName": "Tata Consultancy Services",
      "tradeType": "SELL",
      "quantity": 25,
      "price": 3680.25,
      "currentPrice": 3645.80,
      "pnl": -861.25,
      "pnlPercentage": -0.94,
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "signalConfidence": 78,
      "aiSignal": "Sell",
      "executionTime": "10:45:12",
      "orderType": "Limit",
      "status": "Executed",
      "notes": "Stop loss triggered",
    },
    {
      "id": "TXN003",
      "symbol": "HDFC",
      "companyName": "HDFC Bank Limited",
      "tradeType": "BUY",
      "quantity": 75,
      "price": 1580.50,
      "currentPrice": 1595.25,
      "pnl": 1106.25,
      "pnlPercentage": 0.93,
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "signalConfidence": 92,
      "aiSignal": "Strong Buy",
      "executionTime": "11:30:45",
      "orderType": "Market",
      "status": "Executed",
      "notes": "",
    },
    {
      "id": "TXN004",
      "symbol": "INFY",
      "companyName": "Infosys Limited",
      "tradeType": "SELL",
      "quantity": 40,
      "price": 1420.75,
      "currentPrice": 1435.20,
      "pnl": -578.00,
      "pnlPercentage": -1.02,
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "signalConfidence": 68,
      "aiSignal": "Weak Sell",
      "executionTime": "14:20:18",
      "orderType": "Stop Loss",
      "status": "Executed",
      "notes": "Risk management exit",
    },
    {
      "id": "TXN005",
      "symbol": "WIPRO",
      "companyName": "Wipro Limited",
      "tradeType": "BUY",
      "quantity": 100,
      "price": 425.30,
      "currentPrice": 431.85,
      "pnl": 655.00,
      "pnlPercentage": 1.54,
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "signalConfidence": 81,
      "aiSignal": "Buy",
      "executionTime": "15:45:33",
      "orderType": "Market",
      "status": "Executed",
      "notes": "AI pattern match",
    },
  ];

  List<Map<String, dynamic>> _filteredTrades = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredTrades = List.from(_allTrades);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreTrades();
    }
  }

  Future<void> _loadMoreTrades() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshTrades() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredTrades = List.from(_allTrades);
    });
  }

  void _filterTrades(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredTrades = List.from(_allTrades);
      } else {
        _filteredTrades = _allTrades.where((trade) {
          final symbol = (trade['symbol'] as String).toLowerCase();
          final company = (trade['companyName'] as String).toLowerCase();
          final searchLower = query.toLowerCase();
          return symbol.contains(searchLower) || company.contains(searchLower);
        }).toList();
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            FilterBottomSheetWidget(onApplyFilters: (filters) {
              // Apply filters logic
              _applyFilters(filters);
            }));
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filteredTrades = _allTrades.where((trade) {
        bool matchesType = filters['tradeType'] == 'All' ||
            trade['tradeType'] == filters['tradeType'];
        bool matchesPnL = true;

        if (filters['pnlFilter'] == 'Profit') {
          matchesPnL = (trade['pnl'] as double) > 0;
        } else if (filters['pnlFilter'] == 'Loss') {
          matchesPnL = (trade['pnl'] as double) < 0;
        }

        return matchesType && matchesPnL;
      }).toList();
    });
  }

  void _showTradeAnalytics() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => TradeAnalyticsWidget(trades: _allTrades));
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedTradeIds.clear();
      }
    });
  }

  void _selectTrade(String tradeId) {
    setState(() {
      if (_selectedTradeIds.contains(tradeId)) {
        _selectedTradeIds.remove(tradeId);
      } else {
        _selectedTradeIds.add(tradeId);
      }
    });
  }

  void _exportTrades() {
    // Export functionality
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exporting trades...'),
        backgroundColor: AppTheme.lightTheme.primaryColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: Column(children: [
          _buildTabBar(),
          _buildSearchAndFilter(),
          _buildDateRangeSelector(),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            _buildAllTradesTab(),
            _buildProfitTradesTab(),
            _buildLossTradesTab(),
          ])),
        ]),
        floatingActionButton: _buildFloatingActionButton());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Search trades...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none),
                onChanged: _filterTrades)
            : Text('Trade History',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          if (_isMultiSelectMode) ...[
            TextButton(
                onPressed: _selectedTradeIds.isNotEmpty ? _exportTrades : null,
                child: Text('Export (${_selectedTradeIds.length})',
                    style: TextStyle(color: Colors.white))),
            IconButton(
                onPressed: _toggleMultiSelect,
                icon: CustomIconWidget(
                    iconName: 'close', color: Colors.white, size: 24)),
          ] else ...[
            IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      _filterTrades('');
                    }
                  });
                },
                icon: CustomIconWidget(
                    iconName: _isSearching ? 'close' : 'search',
                    color: Colors.white,
                    size: 24)),
            IconButton(
                onPressed: _showFilterBottomSheet,
                icon: CustomIconWidget(
                    iconName: 'filter_list', color: Colors.white, size: 24)),
            PopupMenuButton<String>(
                icon: CustomIconWidget(
                    iconName: 'more_vert', color: Colors.white, size: 24),
                onSelected: (value) {
                  switch (value) {
                    case 'multi_select':
                      _toggleMultiSelect();
                      break;
                    case 'export_all':
                      _exportTrades();
                      break;
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'multi_select',
                          child: Row(children: [
                            CustomIconWidget(
                                iconName: 'check_box',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20),
                            SizedBox(width: 2.w),
                            Text('Multi Select'),
                          ])),
                      PopupMenuItem(
                          value: 'export_all',
                          child: Row(children: [
                            CustomIconWidget(
                                iconName: 'download',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20),
                            SizedBox(width: 2.w),
                            Text('Export All'),
                          ])),
                    ]),
          ],
        ]);
  }

  Widget _buildTabBar() {
    return Container(
        child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.lightTheme.primaryColor,
            unselectedLabelColor: AppTheme.textMediumEmphasisLight,
            indicatorColor: AppTheme.lightTheme.primaryColor,
            indicatorWeight: 3,
            tabs: [
          Tab(text: 'All Trades'),
          Tab(text: 'Profits'),
          Tab(text: 'Losses'),
        ]));
  }

  Widget _buildSearchAndFilter() {
    if (_isSearching) return SizedBox.shrink();

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(children: [
          Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppTheme.dividerLight, width: 1)),
                  child: Row(children: [
                    CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.textMediumEmphasisLight,
                        size: 20),
                    SizedBox(width: 2.w),
                    Text('Search trades...',
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                                color: AppTheme.textMediumEmphasisLight)),
                  ]))),
          SizedBox(width: 3.w),
          GestureDetector(
              onTap: _showFilterBottomSheet,
              child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: CustomIconWidget(
                      iconName: 'tune', color: Colors.white, size: 20))),
        ]));
  }

  Widget _buildDateRangeSelector() {
    return DateRangeSelectorWidget(
        selectedRange: _selectedDateRange,
        onRangeChanged: (range) {
          setState(() {
            _selectedDateRange = range;
          });
        });
  }

  Widget _buildAllTradesTab() {
    return _buildTradesList(_filteredTrades);
  }

  Widget _buildProfitTradesTab() {
    final profitTrades =
        _filteredTrades.where((trade) => (trade['pnl'] as double) > 0).toList();
    return _buildTradesList(profitTrades);
  }

  Widget _buildLossTradesTab() {
    final lossTrades =
        _filteredTrades.where((trade) => (trade['pnl'] as double) < 0).toList();
    return _buildTradesList(lossTrades);
  }

  Widget _buildTradesList(List<Map<String, dynamic>> trades) {
    if (trades.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
        onRefresh: _refreshTrades,
        color: AppTheme.lightTheme.primaryColor,
        child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            itemCount: trades.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == trades.length) {
                return _buildLoadingIndicator();
              }

              final trade = trades[index];
              return TradeCardWidget(
                  trade: trade,
                  isSelected: _selectedTradeIds.contains(trade['id']),
                  isMultiSelectMode: _isMultiSelectMode,
                  onTap: () {
                    if (_isMultiSelectMode) {
                      _selectTrade(trade['id'] as String);
                    } else {
                      _showTradeDetails(trade);
                    }
                  },
                  onLongPress: () {
                    if (!_isMultiSelectMode) {
                      HapticFeedback.mediumImpact();
                      _toggleMultiSelect();
                      _selectTrade(trade['id'] as String);
                    }
                  },
                  onSwipeRight: () => _showTradeActions(trade));
            }));
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomIconWidget(
          iconName: 'trending_up',
          color: AppTheme.textMediumEmphasisLight,
          size: 64),
      SizedBox(height: 2.h),
      Text('No trades found',
          style: AppTheme.lightTheme.textTheme.headlineSmall
              ?.copyWith(color: AppTheme.textMediumEmphasisLight)),
      SizedBox(height: 1.h),
      Text('Start trading to see your history here',
          style: AppTheme.lightTheme.textTheme.bodyMedium
              ?.copyWith(color: AppTheme.textMediumEmphasisLight),
          textAlign: TextAlign.center),
      SizedBox(height: 3.h),
      ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/trading-dashboard');
          },
          child: Text('Start Trading')),
    ]));
  }

  Widget _buildLoadingIndicator() {
    return Container(
        padding: EdgeInsets.all(4.w),
        child: Center(
            child: CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor)));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: _showTradeAnalytics,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
            iconName: 'analytics', color: Colors.white, size: 24));
  }

  void _showTradeDetails(Map<String, dynamic> trade) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildTradeDetailsSheet(trade));
  }

  Widget _buildTradeDetailsSheet(Map<String, dynamic> trade) {
    return Container(
        height: 80.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                  color: AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(2))),
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailHeader(trade),
                        SizedBox(height: 3.h),
                        _buildDetailSection('Order Details', [
                          _buildDetailRow('Order ID', trade['id'] as String),
                          _buildDetailRow(
                              'Order Type', trade['orderType'] as String),
                          _buildDetailRow('Execution Time',
                              trade['executionTime'] as String),
                          _buildDetailRow('Status', trade['status'] as String),
                        ]),
                        SizedBox(height: 2.h),
                        _buildDetailSection('AI Signal Information', [
                          _buildDetailRow(
                              'Signal', trade['aiSignal'] as String),
                          _buildDetailRow(
                              'Confidence', '${trade['signalConfidence']}%'),
                        ]),
                        SizedBox(height: 2.h),
                        _buildDetailSection('Notes', [
                          TextField(
                              decoration: InputDecoration(
                                  hintText: 'Add notes for this trade...',
                                  border: OutlineInputBorder()),
                              maxLines: 3,
                              controller: TextEditingController(
                                  text: trade['notes'] as String)),
                        ]),
                        SizedBox(height: 3.h),
                        Row(children: [
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'))),
                          SizedBox(width: 3.w),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    // Share trade functionality
                                    Navigator.pop(context);
                                  },
                                  child: Text('Share'))),
                        ]),
                      ]))),
        ]));
  }

  Widget _buildDetailHeader(Map<String, dynamic> trade) {
    final isProfit = (trade['pnl'] as double) > 0;

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: isProfit
                ? AppTheme.successLight.withValues(alpha: 0.1)
                : AppTheme.errorLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(trade['symbol'] as String,
                  style: AppTheme.lightTheme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(trade['companyName'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium
                      ?.copyWith(color: AppTheme.textMediumEmphasisLight)),
            ]),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: trade['tradeType'] == 'BUY'
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(trade['tradeType'] as String,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ]),
          SizedBox(height: 2.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('P&L',
                  style: AppTheme.lightTheme.textTheme.bodySmall
                      ?.copyWith(color: AppTheme.textMediumEmphasisLight)),
              Text('₹${(trade['pnl'] as double).toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: isProfit
                          ? AppTheme.successLight
                          : AppTheme.errorLight,
                      fontWeight: FontWeight.bold)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('Quantity',
                  style: AppTheme.lightTheme.textTheme.bodySmall
                      ?.copyWith(color: AppTheme.textMediumEmphasisLight)),
              Text('${trade['quantity']} shares',
                  style: AppTheme.lightTheme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ]),
          ]),
        ]));
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      SizedBox(height: 1.h),
      ...children,
    ]);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.textMediumEmphasisLight)),
          Text(value,
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ]));
  }

  void _showTradeActions(Map<String, dynamic> trade) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24),
                  title: Text('View Details'),
                  onTap: () {
                    Navigator.pop(context);
                    _showTradeDetails(trade);
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'note_add',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24),
                  title: Text('Add Notes'),
                  onTap: () {
                    Navigator.pop(context);
                    // Add notes functionality
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24),
                  title: Text('Share Trade'),
                  onTap: () {
                    Navigator.pop(context);
                    // Share functionality
                  }),
            ])));
  }
}
