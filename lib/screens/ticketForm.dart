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

  // Get the AuthController instance
  final AuthController authController = Get.find<AuthController>();
  // Initialize TicketDetailsController
  late TicketDetailsController ticketController;

  @override
  void initState() {
    super.initState();

    // Initialize TicketDetailsController
    if (!Get.isRegistered<TicketDetailsController>()) {
      ticketController = Get.put(TicketDetailsController());
    } else {
      ticketController = Get.find<TicketDetailsController>();
    }

    // Add listener to the authentication status
    // This will automatically navigate to ticket details when auth state changes
    ever(authController.isAuthenticated, (isAuthenticated) {
      if (isAuthenticated && ticketFor == "myself") {
        // Small delay to ensure everything is loaded properly
        Future.delayed(Duration(milliseconds: 100), () {
          context.push('/ticketDetails');
        });
      }
    });
  }

  void _handleMyself() {
    // Check if user is authenticated
    if (!authController.isAuthenticated.value) {
      // Navigate to login page if not authenticated
      context.push('/login');
      return;
    }

    // If already authenticated, proceed to ticket details page
    context.push('/ticketDetails');
  }

  // Modified _submitForm method
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create ticket data
      final ticketData = {
        "passengerName": nameController.text,
        "phone": phoneController.text,
        "email": emailController.text,
      };

      // Update data directly using the initialized controller
      ticketController.updateTicketFields(ticketData);

      // Navigate to next page without passing data
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
      appBar: AppBar(title: const Text("Ticket Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRadioButtons(),
            const SizedBox(height: 20),
            if (ticketFor == "myself")
              Obx(() => ElevatedButton(
                    onPressed: _handleMyself,
                    child: Text(authController.isAuthenticated.value
                        ? "Proceed"
                        : "Login"),
                  ))
            else
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Proceed"),
              ),
            if (ticketFor == "someoneElse")
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      decoration:
                          const InputDecoration(labelText: "Phone Number"),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      decoration:
                          const InputDecoration(labelText: "Email (optional)"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
