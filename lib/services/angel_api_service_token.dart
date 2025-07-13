import 'package:dio/dio.dart';

class AngelApiService {
  final String apiKey;
  final Dio _dio = Dio();

  AngelApiService({required this.apiKey}) {
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
    _dio.options.baseUrl = 'https://apiconnect.angelbroking.com';
  }

  Future<Map<String, dynamic>> login({
    required String clientcode,
    required String password,
    required String totp,
  }) async {
    try {
      final response = await _dio.post(
        '/rest/auth/angelbroking/user/v1/loginByPassword',
        data: {
          'clientcode': clientcode,
          'password': password,
          'totp': totp,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> placeOrder({
    required String variety,
    required String tradingsymbol,
    required String symboltoken,
    required String transactiontype,
    required String exchange,
    required String ordertype,
    required String producttype,
    required String quantity,
    String? price,
    String? triggerprice,
  }) async {
    try {
      final response = await _dio.post(
        '/rest/secure/angelbroking/order/v1/placeOrder',
        data: {
          'variety': variety,
          'tradingsymbol': tradingsymbol,
          'symboltoken': symboltoken,
          'transactiontype': transactiontype,
          'exchange': exchange,
          'ordertype': ordertype,
          'producttype': producttype,
          'quantity': quantity,
          if (price != null) 'price': price,
          if (triggerprice != null) 'triggerprice': triggerprice,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Order placement failed: $e');
    }
  }
}