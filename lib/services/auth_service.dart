import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();
  static const _keyToken = 'jwt';


  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<bool> isTokenValid() async {
    String? token = await getToken();
    if (token == null) return false;
    bool isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  static Future<void> logout() async {
    await _storage.delete(key: _keyToken);
  }
}
