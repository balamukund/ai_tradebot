import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ApiKeyInputModalWidget extends StatefulWidget {
  final String brokerName;
  final Function(String apiKey, String apiSecret) onConnect;
  final VoidCallback onCancel;

  const ApiKeyInputModalWidget({
    Key? key,
    required this.brokerName,
    required this.onConnect,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ApiKeyInputModalWidget> createState() => _ApiKeyInputModalWidgetState();
}

class _ApiKeyInputModalWidgetState extends State<ApiKeyInputModalWidget> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _apiSecretController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isApiKeyVisible = false;
  bool _isApiSecretVisible = false;
  bool _isValidating = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 4.w,
          right: 4.w,
          top: 2.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 3.h),
            _buildForm(),
            SizedBox(height: 3.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Connect to ${widget.brokerName}',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: widget.onCancel,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Enter your API credentials to securely connect your brokerage account.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Your credentials are encrypted and stored securely on your device.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _apiKeyController,
            obscureText: !_isApiKeyVisible,
            decoration: InputDecoration(
              labelText: 'API Key',
              hintText: 'Enter your API key',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'vpn_key',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isApiKeyVisible = !_isApiKeyVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _isApiKeyVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'API Key is required';
              }
              if (value.length < 10) {
                return 'API Key must be at least 10 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: _apiSecretController,
            obscureText: !_isApiSecretVisible,
            decoration: InputDecoration(
              labelText: 'API Secret',
              hintText: 'Enter your API secret',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isApiSecretVisible = !_isApiSecretVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName:
                      _isApiSecretVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'API Secret is required';
              }
              if (value.length < 10) {
                return 'API Secret must be at least 10 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isValidating ? null : widget.onCancel,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: ElevatedButton(
            onPressed: _isValidating ? null : _handleConnect,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isValidating
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Validating...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Connect',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _handleConnect() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isValidating = true;
      });

      // Simulate validation delay
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onConnect(
          _apiKeyController.text.trim(),
          _apiSecretController.text.trim(),
        );
      });
    }
  }
}
