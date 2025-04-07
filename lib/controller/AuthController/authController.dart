import 'dart:convert';
import 'package:eticket_atc/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  // Observable for user data
  var userData = Rxn<Map<String, dynamic>>();
  var isAuthenticated = false.obs;
  var token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if user is already logged in when app starts
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    // Get token from AuthService
    final savedToken = await AuthService.getToken();
    if (savedToken != null) {
      token.value = savedToken;
      isAuthenticated.value = true;

      // Load user data from storage or API
      final savedUserData = await AuthService.getUserData();
      if (savedUserData != null) {
        userData.value = savedUserData;
      }
    }
  }

  Future<bool> login(String contactNumber, String password) async {
    try {
      final url =
          Uri.parse('https://e-ticketing-server.vercel.app/api/v1/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contactNumber': contactNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['data']?['accessToken'];

        // Save token
        if (accessToken != null) {
          token.value = accessToken;
          await AuthService.saveToken(accessToken);
          isAuthenticated.value = true;

          // Store basic user data
          final basicUserData = {
            'contactNumber': contactNumber,
            // You can add more fields from the response if needed
          };

          userData.value = basicUserData;
          await AuthService.saveUserData(basicUserData);

          // Fetch complete user profile
          await fetchUserProfile(contactNumber);

          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> fetchUserProfile(String contactNumber) async {
    if (!isAuthenticated.value) return;

    final url = Uri.parse(
      'https://e-ticketing-server.vercel.app/api/v1/passenger/get-passenger/$contactNumber',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': token.value,
          'Content-Type': 'application/json'
        },
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (userData.value != null && data['data'] != null) {
          final Map<String, dynamic> profileData =
              Map<String, dynamic>.from(data['data']);

          final updatedUserData = {...userData.value!, ...profileData};
          userData.value = updatedUserData;

          await AuthService.saveUserData(updatedUserData);
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    userData.value = null;
    isAuthenticated.value = false;
    token.value = '';
  }
}
