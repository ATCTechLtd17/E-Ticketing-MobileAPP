import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final contactNumberController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

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
