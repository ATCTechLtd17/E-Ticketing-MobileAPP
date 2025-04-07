import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RegisterController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs; 
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final passwordController = TextEditingController();
  var selectedGender = ''.obs;

   Rxn<DateTime> birthdate = Rxn<DateTime>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
