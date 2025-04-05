import 'package:eticket_atc/controller/authController.dart';
import 'package:eticket_atc/controller/ticketDetailsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TicketFormPage extends StatefulWidget {
  const TicketFormPage({super.key});

  @override
  _TicketFormPageState createState() => _TicketFormPageState();
}

class _TicketFormPageState extends State<TicketFormPage> {
  String ticketFor = "myself";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();
  late TicketDetailsController ticketController;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<TicketDetailsController>()) {
      ticketController = Get.put(TicketDetailsController());
    } else {
      ticketController = Get.find<TicketDetailsController>();
    }
  }

  void _handleMyself() {
    if (!authController.isAuthenticated.value) {
      // Pass current page data for redirect after login
      final redirectData = {"returnTo": "/ticketDetails"};
      context.push('/login', extra: redirectData);
      return;
    }

    // If already authenticated, go directly to ticket details
    context.push('/ticketDetails');
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final ticketData = {
        "passengerName": nameController.text,
        "phone": phoneController.text,
        "email": emailController.text,
      };

      ticketController.updateTicketFields(ticketData);
      context.push('/ticketDetails');
    }
  }

  Widget _buildRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<String>(
          value: "myself",
          groupValue: ticketFor,
          onChanged: (value) {
            setState(() {
              ticketFor = value!;
            });
          },
          activeColor: Colors.lightBlue[700],
        ),
        const Text("For Myself"),
        const SizedBox(width: 20),
        Radio<String>(
          value: "someoneElse",
          groupValue: ticketFor,
          onChanged: (value) {
            setState(() {
              ticketFor = value!;
            });
          },
          activeColor: Colors.lightBlue[700],
        ),
        const Text("For Someone Else"),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text("Ticket Details"),
        backgroundColor: Colors.lightBlue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRadioButtons(),
            const SizedBox(height: 20),
            if (ticketFor == "myself")
              Obx(() => ElevatedButton(
                    onPressed: _handleMyself,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[400],
                      foregroundColor: Colors.grey[100],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(authController.isAuthenticated.value
                        ? "Proceed"
                        : "Login"),
                  ))
            else
              Column(
                children: [
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.lightBlue),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.lightBlue),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Phone number is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email (optional)",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.lightBlue),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Proceed"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
