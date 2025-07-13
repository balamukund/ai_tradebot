import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/auth_header_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/forgot_password_widget.dart';
import './widgets/guest_mode_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_auth_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _rememberMe = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleAuthSuccess() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.tradingDashboard,
      (route) => false,
    );
  }

  void _handleAuthError(String error) {
    setState(() {
      _errorMessage = error;
      _isLoading = false;
    });
  }

  void _toggleRememberMe(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
      if (loading) _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with branding
              AuthHeaderWidget(),

              SizedBox(height: 4.h),

              // Error message display
              if (_errorMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  margin: EdgeInsets.only(bottom: 3.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Tab bar for Login/Register
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withAlpha(26),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onSurface,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Register'),
                      ],
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Login Tab
                          LoginFormWidget(
                            isLoading: _isLoading,
                            rememberMe: _rememberMe,
                            onLogin: _handleAuthSuccess,
                            onError: _handleAuthError,
                            onLoadingChanged: _setLoading,
                            onRememberMeChanged: _toggleRememberMe,
                          ),
                          // Register Tab
                          LoginFormWidget(
                            isRegister: true,
                            isLoading: _isLoading,
                            rememberMe: _rememberMe,
                            onLogin: _handleAuthSuccess,
                            onError: _handleAuthError,
                            onLoadingChanged: _setLoading,
                            onRememberMeChanged: _toggleRememberMe,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Biometric Authentication
              BiometricAuthWidget(
                onSuccess: _handleAuthSuccess,
                onError: _handleAuthError,
                isEnabled: !_isLoading,
              ),

              SizedBox(height: 3.h),

              // Social Authentication
              SocialAuthWidget(
                onSuccess: _handleAuthSuccess,
                onError: _handleAuthError,
                isEnabled: !_isLoading,
              ),

              SizedBox(height: 3.h),

              // Forgot Password
              ForgotPasswordWidget(
                isEnabled: !_isLoading,
              ),

              SizedBox(height: 4.h),

              // Guest Mode
              GuestModeWidget(
                onGuestMode: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.tradingDashboard,
                    (route) => false,
                    arguments: {'isGuest': true},
                  );
                },
                isEnabled: !_isLoading,
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
