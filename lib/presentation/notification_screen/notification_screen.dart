import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/empty_notifications_widget.dart';
import './widgets/notification_card_widget.dart';
import './widgets/notification_filter_widget.dart';
import './widgets/notification_header_widget.dart';
import './widgets/notification_settings_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  String _selectedCategory = 'All';
  bool _showOnlyUnread = false;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _searchController.addListener(_filterNotifications);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    // Mock notification data
    _notifications = [
      {
        'id': '1',
        'type': 'Trade Alert',
        'title': 'RELIANCE Buy Signal',
        'message': 'AI detected strong buy signal for RELIANCE at ₹2,847.65',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'isRead': false,
        'priority': 'high',
        'symbol': 'RELIANCE',
        'confidence': 0.92,
        'action': 'buy',
        'price': 2847.65,
      },
      {
        'id': '2',
        'type': 'Market Update',
        'title': 'Market Opening Bell',
        'message': 'NSE opened with positive sentiment. Nifty up 0.8%',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': true,
        'priority': 'medium',
        'symbol': 'NIFTY',
      },
      {
        'id': '3',
        'type': 'AI Signal',
        'title': 'Lorentzian Strategy Alert',
        'message': 'TCS showing bullish pattern with 87% confidence',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
        'isRead': false,
        'priority': 'high',
        'symbol': 'TCS',
        'confidence': 0.87,
        'strategy': 'Lorentzian Distance Classifier',
      },
      {
        'id': '4',
        'type': 'System Message',
        'title': 'Portfolio Update',
        'message': 'Your portfolio gained 2.3% today. Total P&L: +₹14,567',
        'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
        'isRead': true,
        'priority': 'low',
        'pnl': 14567,
        'percentage': 2.3,
      },
      {
        'id': '5',
        'type': 'Trade Alert',
        'title': 'Stop Loss Triggered',
        'message': 'INFY position closed at ₹1,456.20 due to stop loss',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': false,
        'priority': 'high',
        'symbol': 'INFY',
        'action': 'sell',
        'price': 1456.20,
      },
    ];

    _filterNotifications();
  }

  void _filterNotifications() {
    setState(() {
      _filteredNotifications = _notifications.where((notification) {
        // Search filter
        if (_searchController.text.isNotEmpty) {
          final searchText = _searchController.text.toLowerCase();
          final matchesSearch = notification['title']
                  .toString()
                  .toLowerCase()
                  .contains(searchText) ||
              notification['message']
                  .toString()
                  .toLowerCase()
                  .contains(searchText) ||
              (notification['symbol'] ?? '')
                  .toString()
                  .toLowerCase()
                  .contains(searchText);
          if (!matchesSearch) return false;
        }

        // Category filter
        if (_selectedCategory != 'All' &&
            notification['type'] != _selectedCategory) {
          return false;
        }

        // Read/Unread filter
        if (_showOnlyUnread && notification['isRead'] == true) {
          return false;
        }

        return true;
      }).toList();

      // Sort by timestamp (newest first)
      _filteredNotifications.sort((a, b) =>
          (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
    });
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 2));

    // Add a new mock notification
    _notifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'Trade Alert',
      'title': 'New Signal Available',
      'message': 'Fresh AI signals generated for your watchlist',
      'timestamp': DateTime.now(),
      'isRead': false,
      'priority': 'medium',
    });

    _filterNotifications();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
    _filterNotifications();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    _filterNotifications();
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
    _filterNotifications();
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationSettingsWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            NotificationHeaderWidget(
              unreadCount: unreadCount,
              onSettingsTap: _showNotificationSettings,
              onMarkAllRead: _markAllAsRead,
            ),

            // Search and Filter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search notifications...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Filter options
                  NotificationFilterWidget(
                    selectedCategory: _selectedCategory,
                    showOnlyUnread: _showOnlyUnread,
                    onCategoryChanged: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _filterNotifications();
                    },
                    onUnreadToggle: (value) {
                      setState(() {
                        _showOnlyUnread = value;
                      });
                      _filterNotifications();
                    },
                  ),
                ],
              ),
            ),

            // Notifications list
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? EmptyNotificationsWidget(
                      searchQuery: _searchController.text,
                      selectedCategory: _selectedCategory,
                      showOnlyUnread: _showOnlyUnread,
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshNotifications,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: _filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = _filteredNotifications[index];

                          return NotificationCardWidget(
                            notification: notification,
                            onTap: () => _markAsRead(notification['id']),
                            onDelete: () =>
                                _deleteNotification(notification['id']),
                            onMarkAsRead: () => _markAsRead(notification['id']),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
