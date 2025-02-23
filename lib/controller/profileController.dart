import 'dart:convert';
import 'package:eticket_atc/models/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  var user = Rxn<UserModel>();
  var contactNumber = ''.obs;
  var purchaseCount = 0.obs;
  var canceledCount = 0.obs;

  Future<void> fetchUserData() async {
    if (contactNumber.value.isEmpty) {
      return;
    }

    final url = Uri.parse(
      'https://e-ticketing-server.vercel.app/api/v1/passenger/get-passenger/${contactNumber.value}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        print(jsonBody);

        user.value = UserModel.fromJson(jsonBody);
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
