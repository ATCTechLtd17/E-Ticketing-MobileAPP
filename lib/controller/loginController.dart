import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final contactNumberController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    contactNumberController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
