import 'dart:convert';
import 'package:eticket_atc/widgets/microwidgets/SearchForm/dtaePick.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:eticket_atc/controller/registrationController.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());

  RegisterPage({super.key});

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

Future<void> registerUser(BuildContext context) async {
    print("Register button clicked!");
    if (registerController.birthdate.value == null ||
        registerController.selectedGender.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      registerController.isLoading.value = true;
      print("Sending request...");

      final url =
          Uri.parse('https://e-ticketing-server.vercel.app/api/v1/auth/signup');

      
      final payload = jsonEncode({
        'fullName': registerController.nameController.text.trim(),
        'email': registerController.emailController.text.trim(),
        'contactNumber': registerController.contactNumberController.text.trim(),
        'emergencyContactNumber':
            registerController.emergencyContactController.text.trim(),
        'dateOfBirth': registerController.birthdate.value!.toIso8601String(),
        'gender': registerController.selectedGender.value.toUpperCase(),
        'password': registerController.passwordController.text.trim(),
      });
      

      
      print("Request Payload: $payload");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

     
      print("Response received: ${response.body}");

      if (response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Registration successful!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

       
        registerController.nameController.clear();
        registerController.emailController.clear();
        registerController.contactNumberController.clear();
        registerController.emergencyContactController.clear();
        registerController.passwordController.clear();
        registerController.birthdate.value = null;
        registerController.selectedGender.value = '';

        context.go('/login');
      } else {
        Get.snackbar(
          "Error",
          "Registration failed: ${jsonDecode(response.body)['message'] ?? 'Unknown error'}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      print("Error: $error");
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: registerController.nameController,
                      decoration: _buildInputDecoration('Full Name'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: registerController.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration('Email'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: registerController.contactNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: _buildInputDecoration('Contact Number'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: registerController.emergencyContactController,
                      keyboardType: TextInputType.phone,
                      decoration:
                          _buildInputDecoration('Emergency Contact Number'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

             
              Row(
                children: [
                  Expanded(
                    child: Obx(() => DatePick(
                          label: 'Birthdate',
                          selectedDate: registerController.birthdate.value,
                          onDateSelected: (date) {
                            registerController.birthdate.value = date;
                          },
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        )),
                  ),
                  
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(() => DropdownButtonFormField<String>(
                          value: registerController.selectedGender.value.isEmpty
                              ? null
                              : registerController.selectedGender.value,
                          decoration: _buildInputDecoration("Gender"),
                          hint: const Text("Select Gender"),
                          onChanged: (value) {
                            registerController.selectedGender.value = value!;
                            print(
                                "Selected gender: ${registerController.selectedGender.value}");
                          },
                          items: ['Male', 'Female', 'Other']
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),

           
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

              Obx(() => ElevatedButton(
                    onPressed: registerController.isLoading.value
                        ? null
                        :() => registerUser(context),
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
                        : const Text('Register'),
                  )),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
