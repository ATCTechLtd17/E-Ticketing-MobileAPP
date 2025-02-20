import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:eticket_atc/controller/registrationController.dart';

class LoginPage extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());

  LoginPage({super.key});

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.lightBlue),
      ),
    );
  }

  Future<void> loginUser() async {
    try {
      registerController.isLoading.value = true;
      final url =
          Uri.parse('https://e-ticketing-server.vercel.app/api/v1/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contactNumber':
              registerController.contactNumberController.text.trim(),
          'password': registerController.passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Login successful!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Login failed! ${response.body}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        "An error occurred: $error",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      registerController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/regi.png',
                colorBlendMode: BlendMode.darken,
                width: 300,
              ),
              const SizedBox(height: 20),
              // Phone Number Input Field
              TextField(
                controller: registerController.contactNumberController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration('Phone Number'),
              ),
              const SizedBox(height: 10),
              // Password Input Field
              Obx(() => TextField(
                    controller: registerController.passwordController,
                    obscureText: !registerController.isPasswordVisible.value,
                    decoration: _buildInputDecoration('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(registerController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: registerController.togglePasswordVisibility,
                      ),
                    ),
                  )),
              const SizedBox(height: 20),

              // Login Button
              Obx(() => ElevatedButton(
                    onPressed:
                        registerController.isLoading.value ? null : loginUser,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: registerController.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Login'),
                  )),

              // Forgot Password Button
              TextButton(
                onPressed: () {
                  // Navigate to the forgot password screen (add your own logic here)
                  Get.snackbar(
                    "Forgot Password",
                    "Redirecting to forgot password screen",
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
                child: const Text('Forgot Password?'),
              ),

              // Sign Up Button
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Don’t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
