import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> storeCredentials({
    required String clientCode,
    required String password,
    required String apiKey,
    required String totpSecret,
  }) async {
    await _storage.write(key: 'client_code', value: clientCode);
    await _storage.write(key: 'password', value: password);
    await _storage.write(key: 'api_key', value: apiKey);
    await _storage.write(key: 'totp_secret', value: totpSecret);
  }
}