import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:totp/totp.dart' show Totp;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ai_tradebot/theme/app_theme.dart';
import 'package:ai_tradebot/services/angel_api_service_token.dart';
import './widgets/ai_suggestions_widget.dart';
import './widgets/confirmation_dialog_widget.dart';
import './widgets/order_preview_widget.dart';
import './widgets/order_type_selector_widget.dart';
import './widgets/price_input_widget.dart';
import './widgets/quantity_input_widget.dart';

// Mock CustomIconWidget (replace with actual implementation from app_export.dart)
class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final double size;
  final Color color;

  const CustomIconWidget({
    Key? key,
    required this.iconName,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.close, size: size, color: color);
  }
}

class TradeExecution extends StatefulWidget {
  const TradeExecution({Key? key}) : super(key: key);

  @override
  State<TradeExecution> createState() => _TradeExecutionState();
}

class _TradeExecutionState extends State<TradeExecution>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Form controllers
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stopLossController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  // State variables
  String _selectedOrderType = 'MARKET';
  bool _bracketOrderEnabled = false;
  bool _trailingStopEnabled = false;
  bool _profitBookingEnabled = true;
  bool _isLoading = false;
  bool _isPaperTrading = true;
  bool _isLoggedIn = false;
  String? _errorMessage;

  // Angel One API credentials (replace with secure storage in production)
  String _clientCode = 'YOUR_CLIENT_CODE'; // Replace with actual client code
  String _password = 'YOUR_PASSWORD'; // Replace with actual password
  String _apiKey = 'YOUR_API_KEY'; // Replace with actual API key
  String? _totpSecret;
  String? _accessToken;
  late AngelApiService _angelApiService;

  // WebSocket for real-time market data
  WebSocketChannel? _webSocketChannel;
  Map<String, dynamic> _realTimeData = {};

  // Mock data (updated in real-time via WebSocket)
  Map<String, dynamic> _stockData = {
    "symbol": "RELIANCE",
    "currentPrice": 2847.50,
    "bidPrice": 2847.25,
    "askPrice": 2847.75,
    "change": 23.50,
    "changePercent": 0.83,
    "volume": 1234567,
    "lastUpdated": DateTime.now().toIso8601String(),
  };

  // Mock AI suggestions (replace with actual API)
  Map<String, dynamic> _aiSuggestions = {
    "recommendedStopLoss": 2820.00,
    "recommendedTarget": 2890.00,
    "volatilityScore": 0.65,
    "riskLevel": "Medium",
    "confidence": 0.78,
    "reasoning": "Based on 20-day volatility and support/resistance levels",
  };

  // Portfolio data
  Map<String, dynamic> _portfolioData = {
    "availableFunds": 125000.00,
    "totalPortfolio": 500000.00,
    "maxPositionSize": 50000.00,
    "currentHoldings": 0,
  };

  // Instrument list for token mapping
  List<Map<String, dynamic>> _instrumentList = [];
  static const String _instrumentsUrl =
      'https://margincalculator.angelbroking.com/OpenAPI_File/files/OpenAPIScripMaster.json';

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    _slideController.forward();

    // Initialize Angel API service
    _angelApiService = AngelApiService(
      apiKey: _apiKey,
    );

    // Load instruments and initialize
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInstruments();
      _initializeAngelTrade();
      _connectWebSocket();
    });
  }

  // Initialize Angel One login with secure storage
  Future<void> _initializeAngelTrade() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storage = FlutterSecureStorage();
      _clientCode = await storage.read(key: 'client_code') ?? 'YOUR_CLIENT_CODE';
      _password = await storage.read(key: 'password') ?? 'YOUR_PASSWORD';
      _apiKey = await storage.read(key: 'api_key') ?? 'YOUR_API_KEY';
      _totpSecret = await storage.read(key: 'totp_secret') ?? 'YOUR_TOTP_SECRET';

      final totp = Totp(secret: _totpSecret);
      final totpCode = totp.now();

      final loginResponse = await _angelApiService.login(
        clientcode: _clientCode,
        password: _password,
        totp: totpCode,
      );

      if (loginResponse['status'] == true) {
        _accessToken = loginResponse['data']['jwtToken'];
        await storage.write(key: 'access_token', value: _accessToken!);
        setState(() {
          _isLoggedIn = true;
          _initializeDefaultValues();
        });
        print('✅ Login successful');
      } else {
        setState(() {
          _errorMessage = 'Login failed: ${loginResponse['message']}';
        });
        print('⚠️ Login failed: ${loginResponse['message']}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login error: $e';
      });
      print('⚠️ Login error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Load instrument list
  Future<void> _loadInstruments() async {
    try {
      final dio = Dio();
      final resp = await dio.get(_instrumentsUrl);
      final data = resp.data as List;
      _instrumentList = data
          .map((e) => {
                "symbol": e["symbol"].toString(),
                "token": e["token"].toString(),
              })
          .toList();
      if (mounted) {
        setState(() {
          print('🎯 Instruments loaded: ${_instrumentList.length}');
        });
      }
    } catch (e) {
      print('⚠️ Instrument load failed: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load instruments: $e';
        });
      }
    }
  }

  // Connect to Angel One WebSocket
  Future<void> _connectWebSocket() async {
    if (!_isLoggedIn || _accessToken == null) return;

    try {
      _webSocketChannel = WebSocketChannel.connect(
        Uri.parse('wss://smartapi.angelbroking.com/websocket?jwtToken=$_accessToken'),
      );

      final subscriptionMessage = {
        "action": "subscribe",
        "params": {
          "mode": "FULL",
          "scrips": "NSE:RELIANCE-EQ",
        },
      };
      _webSocketChannel!.sink.add(jsonEncode(subscriptionMessage));

      _webSocketChannel!.stream.listen(
        (data) {
          try {
            final decodedData = jsonDecode(data);
            if (mounted) {
              setState(() {
                _realTimeData = {
                  "symbol": decodedData['symbol'] ?? _stockData['symbol'],
                  "currentPrice": decodedData['ltp']?.toDouble() ?? _stockData['currentPrice'],
                  "bidPrice": decodedData['bidPrice']?.toDouble() ?? _stockData['bidPrice'],
                  "askPrice": decodedData['askPrice']?.toDouble() ?? _stockData['askPrice'],
                  "change": decodedData['change']?.toDouble() ?? _stockData['change'],
                  "changePercent": decodedData['changePercent']?.toDouble() ?? _stockData['changePercent'],
                  "volume": decodedData['volume']?.toInt() ?? _stockData['volume'],
                  "lastUpdated": DateTime.now().toIso8601String(),
                };
                _stockData = _realTimeData;
                _priceController.text = _stockData['currentPrice'].toStringAsFixed(2);
              });
            }
          } catch (e) {
            print('⚠️ WebSocket data parse error: $e');
          }
        },
        onError: (error) {
          print('⚠️ WebSocket error: $error');
          if (mounted) {
            setState(() {
              _errorMessage = 'WebSocket error: $error';
            });
          }
        },
        onDone: () {
          print('⚠️ WebSocket closed');
        },
      );
    } catch (e) {
      print('⚠️ WebSocket connection error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'WebSocket connection error: $e';
        });
      }
    }
  }

  // Fetch trading signals
  Future<Map<String, dynamic>> _fetchTradingSignals() async {
    // Replace with actual signal source (e.g., API or algorithm)
    return {
      "symbol": "RELIANCE",
      "action": "BUY",
      "price": _stockData["currentPrice"],
      "quantity": 10,
      "stopLoss": _aiSuggestions["recommendedStopLoss"],
      "target": _aiSuggestions["recommendedTarget"],
      "confidence": 0.78,
    };
  }

  // Execute trade based on signals
  Future<void> _executeTradeFromSignals() async {
    if (!_isLoggedIn || _accessToken == null) {
      _showErrorDialog('Please log in to execute trades.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final signals = await _fetchTradingSignals();
      final symbol = signals['symbol'];
      final action = signals['action'];
      final price = signals['price']?.toDouble();
      final quantity = signals['quantity']?.toInt();
      final stopLoss = signals['stopLoss']?.toDouble();
      final target = signals['target']?.toDouble();

      setState(() {
        _selectedOrderType = action == 'BUY' ? 'BUY' : 'SELL';
        _quantityController.text = quantity.toString();
        _priceController.text = price.toStringAsFixed(2);
        _stopLossController.text = stopLoss?.toStringAsFixed(2) ?? '';
        _targetController.text = target?.toStringAsFixed(2) ?? '';
      });

      if (!_validateOrder()) return;

      bool confirmed = await _showConfirmationDialog();
      if (!confirmed) return;

      final token = _instrumentList
          .firstWhere(
            (instrument) => instrument['symbol'] == symbol,
            orElse: () => {"token": null},
          )['token'];
      if (token == null) {
        _showErrorDialog('Token not found for $symbol');
        return;
      }

      final orderResponse = await _angelApiService.placeOrder(
        variety: _bracketOrderEnabled ? 'BRACKET' : 'NORMAL',
        tradingsymbol: symbol,
        symboltoken: token,
        transactiontype: _selectedOrderType,
        exchange: 'NSE',
        ordertype: _selectedOrderType,
        producttype: _isPaperTrading ? 'DELIVERY' : 'INTRADAY',
        quantity: quantity.toString(),
        price: _selectedOrderType != 'MARKET' ? price.toString() : "0",
        triggerprice: _bracketOrderEnabled ? stopLoss.toString() : null,
      );

      if (orderResponse['status'] == true) {
        _showSuccessDialog();
        print('✅ Order placed: $orderResponse');
      } else {
        _showErrorDialog('Order failed: ${orderResponse['message']}');
        print('⚠️ Order failed: ${orderResponse['message']}');
      }
    } catch (e) {
      _showErrorDialog('Order placement failed: $e');
      print('⚠️ Order placement error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _initializeDefaultValues() {
    _quantityController.text = "10";
    _priceController.text = _stockData["currentPrice"].toString();
    _stopLossController.text = _aiSuggestions["recommendedStopLoss"].toString();
    _targetController.text = _aiSuggestions["recommendedTarget"].toString();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _stopLossController.dispose();
    _targetController.dispose();
    _webSocketChannel?.sink.close();
    super.dispose();
  }

  void _onOrderTypeChanged(String orderType) {
    setState(() {
      _selectedOrderType = orderType.toUpperCase();
      if (orderType == 'MARKET') {
        _priceController.text = _stockData["currentPrice"].toStringAsFixed(2);
      }
    });
  }

  void _adjustPrice(bool increase) {
    double currentPrice = double.tryParse(_priceController.text) ?? 0;
    double adjustment = increase ? 0.25 : -0.25;
    double newPrice = currentPrice + adjustment;
    _priceController.text = newPrice.toStringAsFixed(2);
  }

  void _calculatePositionSize(double percentage) {
    double portfolioValue = _portfolioData["totalPortfolio"] as double;
    double targetAmount = portfolioValue * (percentage / 100);
    double currentPrice = double.tryParse(_priceController.text) ?? 1;
    int quantity = (targetAmount / currentPrice).floor();
    _quantityController.text = quantity.toString();
  }

  Future<void> _placeOrder() async {
    if (!_validateOrder()) return;

    bool confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final symbol = _stockData['symbol'];
      final token = _instrumentList
          .firstWhere(
            (instrument) => instrument['symbol'] == symbol,
            orElse: () => {"token": null},
          )['token'];
      if (token == null) {
        _showErrorDialog('Token not found for $symbol');
        return;
      }

      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final price = double.tryParse(_priceController.text) ?? 0;
      final stopLoss = double.tryParse(_stopLossController.text);
      final target = double.tryParse(_targetController.text);

      final orderResponse = await _angelApiService.placeOrder(
        variety: _bracketOrderEnabled ? 'BRACKET' : 'NORMAL',
        tradingsymbol: symbol,
        symboltoken: token,
        transactiontype: _selectedOrderType,
        exchange: 'NSE',
        ordertype: _selectedOrderType,
        producttype: _isPaperTrading ? 'DELIVERY' : 'INTRADAY',
        quantity: quantity.toString(),
        price: _selectedOrderType != 'MARKET' ? price.toString() : "0",
        triggerprice: _bracketOrderEnabled ? stopLoss.toString() : null,
      );

      if (orderResponse['status'] == true) {
        _showSuccessDialog();
        print('✅ Order placed: $orderResponse');
      } else {
        _showErrorDialog('Order failed: ${orderResponse['message']}');
        print('⚠️ Order failed: ${orderResponse['message']}');
      }
    } catch (e) {
      _showErrorDialog('Order placement failed: $e');
      print('⚠️ Order placement error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateOrder() {
    double quantity = double.tryParse(_quantityController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0;
    double totalValue = quantity * price;
    double availableFunds = _portfolioData["availableFunds"] as double;

    if (!_isLoggedIn) {
      _showErrorDialog('Please log in to place orders.');
      return false;
    }

    if (quantity <= 0) {
      _showErrorDialog('Please enter a valid quantity');
      return false;
    }

    if (price <= 0 && _selectedOrderType != 'MARKET') {
      _showErrorDialog('Please enter a valid price');
      return false;
    }

    if (totalValue > availableFunds) {
      _showErrorDialog(
          'Insufficient funds. Available: ₹${availableFunds.toStringAsFixed(2)}');
      return false;
    }

    return true;
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmationDialogWidget(
            orderType: _selectedOrderType,
            symbol: _stockData["symbol"] as String,
            quantity: int.tryParse(_quantityController.text) ?? 0,
            price: double.tryParse(_priceController.text) ?? 0,
            isPaperTrading: _isPaperTrading,
            onConfirm: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Order Placed Successfully',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: TXN${DateTime.now().millisecondsSinceEpoch}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            if (_isPaperTrading)
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.getWarningColor(true).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Paper Trading Mode - No real money involved',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getWarningColor(true),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/trade-history');
            },
            child: const Text('View Trade History'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.getErrorColor(true),
          ),
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: _isLoading && !_isLoggedIn
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: AlertDialog(
                    title: Text('Error', style: AppTheme.lightTheme.textTheme.titleLarge),
                    content: Text(_errorMessage!, style: AppTheme.lightTheme.textTheme.bodyMedium),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                            _initializeAngelTrade();
                          });
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                        SlideTransition(
                          position: _slideAnimation,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: 90.h,
                                minHeight: 60.h,
                              ),
                              child: GestureDetector(
                                onTap: () {}, // Prevent tap through
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildHeader(),
                                      Flexible(
                                        child: SingleChildScrollView(
                                          padding: EdgeInsets.all(4.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildStockInfo(),
                                              SizedBox(height: 3.h),
                                              OrderTypeSelectorWidget(
                                                selectedType: _selectedOrderType,
                                                onTypeChanged: _onOrderTypeChanged,
                                              ),
                                              SizedBox(height: 3.h),
                                              QuantityInputWidget(
                                                controller: _quantityController,
                                                portfolioData: _portfolioData,
                                                currentPrice:
                                                    double.tryParse(_priceController.text) ?? 0,
                                                onPositionSizeCalculated: _calculatePositionSize,
                                              ),
                                              SizedBox(height: 3.h),
                                              PriceInputWidget(
                                                controller: _priceController,
                                                orderType: _selectedOrderType,
                                                stockData: _stockData,
                                                onPriceAdjusted: _adjustPrice,
                                              ),
                                              SizedBox(height: 3.h),
                                              AiSuggestionsWidget(
                                                suggestions: _aiSuggestions,
                                                stopLossController: _stopLossController,
                                                targetController: _targetController,
                                              ),
                                              SizedBox(height: 3.h),
                                              _buildAdvancedOptions(),
                                              SizedBox(height: 3.h),
                                              OrderPreviewWidget(
                                                orderType: _selectedOrderType,
                                                symbol: _stockData["symbol"] as String,
                                                quantity:
                                                    int.tryParse(_quantityController.text) ?? 0,
                                                price:
                                                    double.tryParse(_priceController.text) ?? 0,
                                                stopLoss: double.tryParse(_stopLossController.text),
                                                target: double.tryParse(_targetController.text),
                                                bracketOrderEnabled: _bracketOrderEnabled,
                                                isPaperTrading: _isPaperTrading,
                                              ),
                                              SizedBox(height: 3.h),
                                              _buildPlaceOrderButton(),
                                              SizedBox(height: 3.h),
                                              _buildExecuteSignalButton(),
                                              SizedBox(height: 2.h),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Spacer(),
          Text(
            'Trade Execution',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: CustomIconWidget(
              iconName: 'close',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo() {
    final change = _stockData["change"] as double;
    final changePercent = _stockData["changePercent"] as double;
    final isPositive = change >= 0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _stockData["symbol"] as String,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '₹${(_stockData["currentPrice"] as double).toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppTheme.getSuccessColor(true).withOpacity(0.1)
                      : AppTheme.getErrorColor(true).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isPositive
                        ? AppTheme.getSuccessColor(true)
                        : AppTheme.getErrorColor(true),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isPositive
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.getErrorColor(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Options',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          _buildToggleOption(
            'Bracket Order',
            'Automatically set stop-loss and target',
            _bracketOrderEnabled,
            (value) => setState(() => _bracketOrderEnabled = value),
          ),
          SizedBox(height: 1.h),
          _buildToggleOption(
            'Trailing Stop-Loss',
            'Adjust stop-loss as price moves favorably',
            _trailingStopEnabled,
            (value) => setState(() => _trailingStopEnabled = value),
          ),
          SizedBox(height: 1.h),
          _buildToggleOption(
            'Auto Profit Booking',
            'Book profits at target price automatically',
            _profitBookingEnabled,
            (value) => setState(() => _profitBookingEnabled = value),
          ),
          SizedBox(height: 1.h),
          _buildToggleOption(
            'Paper Trading Mode',
            'Practice trading without real money',
            _isPaperTrading,
            (value) => setState(() => _isPaperTrading = value),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _placeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isPaperTrading
              ? AppTheme.getWarningColor(true)
              : AppTheme.lightTheme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : Text(
                _isPaperTrading ? 'Place Paper Order' : 'Place Order',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildExecuteSignalButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _executeTradeFromSignals,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Execute Trade from Signals',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}