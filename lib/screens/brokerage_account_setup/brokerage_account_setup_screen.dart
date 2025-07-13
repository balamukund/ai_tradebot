
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';

class BrokerageAccountSetupScreen extends StatefulWidget {
  @override
  _BrokerageAccountSetupScreenState createState() => _BrokerageAccountSetupScreenState();
}

class _BrokerageAccountSetupScreenState extends State<BrokerageAccountSetupScreen> {
  final TextEditingController _clientCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('angel_client_code', _clientCodeController.text);
    await prefs.setString('angel_password', _passwordController.text);
    await prefs.setString('angel_api_key', _apiKeyController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Credentials saved')),
    );

    Navigator.pushNamed(context, AppRoutes.tradingDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Brokerage Account Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _clientCodeController,
              decoration: InputDecoration(labelText: 'Angel One Client Code'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(labelText: 'API Key'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCredentials,
              child: Text('Save & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
