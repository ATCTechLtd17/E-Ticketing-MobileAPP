import 'dart:convert';
import 'package:eticket_atc/models/user_model.dart';
import 'package:eticket_atc/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  var user = Rxn<UserModel>();
  var purchaseCount = 0.obs;
  var canceledCount = 0.obs;

  Future<void> fetchUserData(String contactNumber) async {
    if (contactNumber.isEmpty) {
      return;
    }

    final url = Uri.parse(
      'https://e-ticketing-server.vercel.app/api/v1/passenger/get-passenger/$contactNumber',
    );

    try {
      String? token = await AuthService.getToken();
      print(token);
      if( token == null){
        print('no token');
        return;
      }

      final response = await http.get(url,
      headers: {'Authorization':token,
      'Content-Type':'application/json'
      },
      );

     if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        print(jsonBody);

        final userData = jsonBody['data']; 

        if (userData != null) {
          print(userData);
          user.value = UserModel.fromJson(userData);
        } else {
          print('No user data found in the response.');
        }
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
