import 'package:eticket_atc/controller/AuthController/authController.dart';
import 'package:eticket_atc/controller/AuthController/loginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  final Map<String, dynamic>? redirectData;
  final LoginController loginController = Get.put(LoginController());
  final AuthController authController = Get.find<AuthController>();

  LoginPage({super.key, this.redirectData});

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

  Future<void> loginUser(BuildContext context) async {
    try {
      loginController.isLoading.value = true;

      // Use the AuthController for login
      final success = await authController.login(
        loginController.contactNumberController.text.trim(),
        loginController.passwordController.text,
      );

      if (success) {
        Get.snackbar(
          "Success",
          "Login successful!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Check if we need to redirect to a specific page after login
        if (redirectData != null) {
          Future.delayed(const Duration(milliseconds: 300), () {
            context.go('/ticketDetails', extra: redirectData);
          });
        } else {
          // Only navigate to home if there's no redirection needed
          context.go('/');
        }
      } else {
        Get.snackbar(
          "Error",
          "Login failed! Please check your credentials.",
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
      loginController.isLoading.value = false;
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
              TextField(
                controller: loginController.contactNumberController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration('Phone Number'),
              ),
              const SizedBox(height: 10),
              Obx(() => TextField(
                    controller: loginController.passwordController,
                    obscureText: !loginController.isPasswordVisible.value,
                    decoration: _buildInputDecoration('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: loginController.togglePasswordVisibility,
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                    onPressed: loginController.isLoading.value
                        ? null
                        : () => loginUser(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.lightBlue,
                    ),
                    child: loginController.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Login',
                            style: TextStyle(color: Colors.white)),
                  )),
             /* TextButton(
                onPressed: () {
                  Get.snackbar(
                    "Forgot Password",
                    "Redirecting to forgot password screen",
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
                child: const Text('Forgot Password?',
                    style: TextStyle(color: Colors.lightBlue)),
              ),*/
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text("Don't have an account? Sign up",
                    style: TextStyle(color: Colors.lightBlue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
