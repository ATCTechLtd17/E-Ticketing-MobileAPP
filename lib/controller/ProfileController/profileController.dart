import 'dart:convert';
import 'dart:io';
import 'package:eticket_atc/controller/AuthController/authController.dart';
import 'package:eticket_atc/models/user_model.dart';
import 'package:eticket_atc/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  final _authController = Get.find<AuthController>();

  var user = Rxn<UserModel>();
  var purchaseCount = 0.obs;
  var canceledCount = 0.obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var updateSuccess = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final userData = _authController.userData.value;
    if (userData != null && userData.containsKey('contactNumber')) {
      fetchUserData(userData['contactNumber']);
    }
  }

  Future<void> fetchUserData(String contactNumber) async {
    if (contactNumber.isEmpty || !_authController.isAuthenticated.value) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final url = Uri.parse(
        'https://e-ticketing-server.vercel.app/api/v1/passenger/get-passenger/$contactNumber',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': _authController.token.value,
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final userData = jsonBody['data'];

        if (userData != null) {
          final Map<String, dynamic> typedUserData =
              Map<String, dynamic>.from(userData);
          user.value = UserModel.fromJson(typedUserData);

          await fetchPurchaseStatistics(contactNumber);
        } else {
          errorMessage.value = 'No user data found in the response';
        }
      } else {
        errorMessage.value =
            'Failed to fetch user data: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching user data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPurchaseStatistics(String contactNumber) async {
    if (!_authController.isAuthenticated.value) return;

    try {
      final url = Uri.parse(
        'https://e-ticketing-server.vercel.app/api/v1/booking/passenger-statistics/$contactNumber',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': _authController.token.value,
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        if (data != null) {
          purchaseCount.value = data['totalPurchase'] ?? 0;
          canceledCount.value = data['canceledCount'] ?? 0;
        }
      }
    } catch (e) {
      print('Error fetching purchase statistics: $e');
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updatedData) async {
    if (!_authController.isAuthenticated.value) return false;

    isUpdating.value = true;
    updateSuccess.value = false;
    errorMessage.value = '';

    try {
      if (user.value == null || user.value!.id.isEmpty) {
        errorMessage.value = 'User profile not loaded';
        isUpdating.value = false;
        return false;
      }

      final url = Uri.parse(
        'https://e-ticketing-server.vercel.app/api/v1/passenger/update-passenger/${user.value!.id}',
      );

      final response = await http.patch(
        url,
        headers: {
          'Authorization': _authController.token.value,
          'Content-Type': 'application/json'
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        if (user.value?.contactNumber != null) {
          await fetchUserData(user.value!.contactNumber);

          if (_authController.userData.value != null) {
            final Map<String, dynamic> updatedUserData = {
              ..._authController.userData.value!,
              ...updatedData
            };
            _authController.userData.value = updatedUserData;
            await AuthService.saveUserData(updatedUserData);
          }
        }
        updateSuccess.value = true;
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        errorMessage.value = errorData['message'] ?? 'Failed to update profile';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error updating profile: $e';
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> updateProfileWithImage(
      Map<String, dynamic> updatedData, File? imageFile) async {
    if (!_authController.isAuthenticated.value) return false;

    isUpdating.value = true;
    updateSuccess.value = false;
    errorMessage.value = '';

    try {
      if (user.value == null || user.value!.id.isEmpty) {
        errorMessage.value = 'User profile not loaded';
        isUpdating.value = false;
        return false;
      }

      if (imageFile != null) {
        final imageUrl = await uploadProfileImage(imageFile);
        if (imageUrl != null) {
          updatedData['profileImage'] = imageUrl;
        }
      }

      return await updateProfile(updatedData);
    } catch (e) {
      errorMessage.value = 'Error updating profile: $e';
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    if (!_authController.isAuthenticated.value) return null;

    try {
      final uploadUrl = Uri.parse(
        'https://e-ticketing-server.vercel.app/api/v1/upload/profile-image',
      );

      var request = http.MultipartRequest('POST', uploadUrl)
        ..headers.addAll({
          'Authorization': _authController.token.value,
        })
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data']['url'];
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    if (!_authController.isAuthenticated.value) return false;

    isUpdating.value = true;
    errorMessage.value = '';

    try {
      final url = Uri.parse(
        'https://e-ticketing-server.vercel.app/api/v1/auth/change-password',
      );

      final response = await http.post(
        url,
        headers: {
          'Authorization': _authController.token.value,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        errorMessage.value =
            errorData['message'] ?? 'Failed to change password';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error changing password: $e';
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserTickets(
      String contactNumber) async {
    if (!_authController.isAuthenticated.value) return [];

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final url = Uri.parse(
        'https://e-ticketing-server.vercel.app/api/v1/booking/passenger-bookings/$contactNumber',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': _authController.token.value,
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> tickets = jsonBody['data'] ?? [];

        return tickets
            .map((ticket) => Map<String, dynamic>.from(ticket))
            .toList();
      } else {
        errorMessage.value = 'Failed to fetch tickets: ${response.statusCode}';
        return [];
      }
    } catch (e) {
      errorMessage.value = 'Error fetching tickets: $e';
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  void clearErrors() {
    errorMessage.value = '';
  }
}
