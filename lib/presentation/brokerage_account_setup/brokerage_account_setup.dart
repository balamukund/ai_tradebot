import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/api_key_input_modal_widget.dart';
import './widgets/broker_selection_card_widget.dart';
import './widgets/security_info_modal_widget.dart';

class BrokerageAccountSetup extends StatefulWidget {
  const BrokerageAccountSetup({Key? key}) : super(key: key);

  @override
  State<BrokerageAccountSetup> createState() => _BrokerageAccountSetupState();
}

class _BrokerageAccountSetupState extends State<BrokerageAccountSetup>
    with TickerProviderStateMixin {
  int currentStep = 1;
  final int totalSteps = 3;
  bool isPaperTradingEnabled = false;
  String? selectedBroker;
  Map<String, bool> brokerConnectionStatus = {
    'zerodha': false,
    'angel_one': false,
  };
  bool isConnecting = false;
  String? connectionError;

  final List<Map<String, dynamic>> brokerData = [
    {
      "id": "zerodha",
      "name": "Zerodha Kite",
      "logo": "https://zerodha.com/static/images/logo.svg",
      "features": ["Real-time Data", "Auto Trading", "Portfolio Sync"],
      "description": "India's largest discount broker with advanced API",
      "isConnected": false,
      "accountBalance": "₹0.00",
      "tradingPermissions": ["Equity", "F&O", "Currency"],
    },
    {
      "id": "angel_one",
      "name": "Angel One SmartAPI",
      "logo": "https://www.angelone.in/images/logo.png",
      "features": ["Smart Orders", "Real-time Analytics", "Multi-segment"],
      "description": "Comprehensive trading platform with AI insights",
      "isConnected": false,
      "accountBalance": "₹0.00",
      "tradingPermissions": ["Equity", "Derivatives", "Commodity"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    SizedBox(height: 3.h),
                    _buildBrokerSelectionSection(),
                    SizedBox(height: 3.h),
                    _buildPaperTradingToggle(),
                    SizedBox(height: 4.h),
                    _buildContinueButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
          size: 24,
        ),
      ),
      title: Text(
        'Brokerage Setup',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      actions: [
        TextButton(
          onPressed: _showSecurityInfoModal,
          child: Text(
            'Learn More',
            style: TextStyle(
              color: AppTheme.lightTheme.appBarTheme.foregroundColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step $currentStep of $totalSteps',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect Your Broker',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Securely connect your brokerage account to enable automated trading and real-time portfolio sync.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (connectionError != null) ...[
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.getErrorColor(true).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.getErrorColor(true).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error_outline',
                  color: AppTheme.getErrorColor(true),
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    connectionError!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getErrorColor(true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBrokerSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Broker',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brokerData.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final broker = brokerData[index];
            final isConnected = brokerConnectionStatus[broker["id"]] ?? false;

            return BrokerSelectionCardWidget(
              brokerData: broker,
              isConnected: isConnected,
              isConnecting: isConnecting && selectedBroker == broker["id"],
              onConnect: () => _handleBrokerConnection(broker),
              onDisconnect: () => _handleBrokerDisconnection(broker["id"]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaperTradingToggle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paper Trading Mode',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Test strategies without real money. Perfect for beginners.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isPaperTradingEnabled,
            onChanged: (value) {
              setState(() {
                isPaperTradingEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool hasConnectedBroker =
        brokerConnectionStatus.values.any((status) => status);

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: hasConnectedBroker ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasConnectedBroker
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Continue to Trading',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleBrokerConnection(Map<String, dynamic> broker) {
    setState(() {
      selectedBroker = broker["id"];
      connectionError = null;
    });

    _showApiKeyInputModal(broker);
  }

  void _handleBrokerDisconnection(String brokerId) {
    setState(() {
      brokerConnectionStatus[brokerId] = false;
      // Update broker data
      final brokerIndex = brokerData.indexWhere((b) => b["id"] == brokerId);
      if (brokerIndex != -1) {
        brokerData[brokerIndex]["isConnected"] = false;
        brokerData[brokerIndex]["accountBalance"] = "₹0.00";
      }
    });
  }

  void _showApiKeyInputModal(Map<String, dynamic> broker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApiKeyInputModalWidget(
        brokerName: broker["name"],
        onConnect: (apiKey, apiSecret) =>
            _connectBroker(broker["id"], apiKey, apiSecret),
        onCancel: () {
          setState(() {
            selectedBroker = null;
            isConnecting = false;
          });
        },
      ),
    );
  }

  void _showSecurityInfoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SecurityInfoModalWidget(),
    );
  }

  Future<void> _connectBroker(
      String brokerId, String apiKey, String apiSecret) async {
    setState(() {
      isConnecting = true;
      connectionError = null;
    });

    try {
      // Simulate API connection
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation - in real app, validate with actual broker API
      if (apiKey.isEmpty || apiSecret.isEmpty) {
        throw Exception('Invalid API credentials');
      }

      // Mock successful connection
      setState(() {
        brokerConnectionStatus[brokerId] = true;
        isConnecting = false;
        selectedBroker = null;
        currentStep = 2;

        // Update broker data with mock account info
        final brokerIndex = brokerData.indexWhere((b) => b["id"] == brokerId);
        if (brokerIndex != -1) {
          brokerData[brokerIndex]["isConnected"] = true;
          brokerData[brokerIndex]["accountBalance"] = "₹1,25,000.00";
        }
      });

      Navigator.pop(context); // Close modal

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Successfully connected to ${brokerData.firstWhere((b) => b["id"] == brokerId)["name"]}'),
          backgroundColor: AppTheme.getSuccessColor(true),
        ),
      );
    } catch (e) {
      setState(() {
        isConnecting = false;
        connectionError = e.toString().replaceAll('Exception: ', '');
        selectedBroker = null;
      });
      Navigator.pop(context); // Close modal
    }
  }

  void _handleContinue() {
    Navigator.pushNamed(context, '/trading-dashboard');
  }
}
