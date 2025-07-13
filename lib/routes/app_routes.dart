import 'package:flutter/material.dart';
import '../presentation/brokerage_account_setup/brokerage_account_setup.dart';
import '../presentation/trading_dashboard/trading_dashboard.dart';
import '../presentation/trade_execution/trade_execution.dart';
import '../presentation/trade_history/trade_history.dart';
import '../presentation/interactive_charts/interactive_charts.dart';
import '../presentation/ai_strategy_settings/ai_strategy_settings.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/notification_screen/notification_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String authenticationScreen = '/authentication-screen';
  static const String notificationScreen = '/notification-screen';
  static const String brokerageAccountSetup = '/brokerage-account-setup';
  static const String tradingDashboard = '/trading-dashboard';
  static const String tradeExecution = '/trade-execution';
  static const String tradeHistory = '/trade-history';
  static const String interactiveCharts = '/interactive-charts';
  static const String aiStrategySettings = '/ai-strategy-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    authenticationScreen: (context) => const AuthenticationScreen(),
    notificationScreen: (context) => const NotificationScreen(),
    brokerageAccountSetup: (context) => const BrokerageAccountSetup(),
    tradingDashboard: (context) => const TradingDashboard(),
    tradeExecution: (context) => const TradeExecution(),
    tradeHistory: (context) => const TradeHistory(),
    interactiveCharts: (context) => const InteractiveCharts(),
    aiStrategySettings: (context) => const AiStrategySettings(),
  };
}
