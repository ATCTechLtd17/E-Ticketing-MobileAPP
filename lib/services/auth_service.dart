import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String apiUrl = 'https://e-ticketing-server.vercel.app/api/v1';
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: 'user_data', value: jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: 'user_data');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;

  }
  static Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_data');
  }
}
