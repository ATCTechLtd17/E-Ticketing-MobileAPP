import 'package:eticket_atc/controller/AuthController/authController.dart';
import 'package:eticket_atc/controller/TicketController/ticketDetailsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TicketFormController extends GetxController {
  var ticketFor = "myself".obs;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  var nameError = RxnString(null);
  var phoneError = RxnString(null);
  late final AuthController authController;
  late final TicketDetailsController ticketController;

  @override
  void onInit() {
    super.onInit();
    // Get AuthController - use find or put with proper dependency management
    authController = Get.find<AuthController>();

    // Proper way to get or create TicketDetailsController
    if (Get.isRegistered<TicketDetailsController>()) {
      ticketController = Get.find<TicketDetailsController>();
    } else {
      ticketController = Get.put(TicketDetailsController());
    }
  }

  void handleMyself(BuildContext context) {
    if (!authController.isAuthenticated.value) {
      final redirectData = {"returnTo": "/ticketDetails"};
      context.push('/login', extra: redirectData);
      return;
    }
    context.push('/ticketDetails');
  }

  void validateFields() {
    nameError.value = null;
    phoneError.value = null;

    if (nameController.text.trim().isEmpty) {
      nameError.value = "Name is required";
    }

    if (phoneController.text.trim().isEmpty) {
      phoneError.value = "Phone number is required";
    }
  }

  void submitForm(BuildContext context) {
    validateFields();
    if (nameError.value == null && phoneError.value == null) {
      final ticketData = {
        "passengerName": nameController.text,
        "phone": phoneController.text,
        "email": emailController.text,
      };
      ticketController.updateTicketFields(ticketData);
      context.push('/ticketDetails');
    }
  }

  void setTicketFor(String value) {
    ticketFor.value = value;
    nameError.value = null;
    phoneError.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}

class TicketFormPage extends StatelessWidget {
  TicketFormPage({ super.key});

  final TicketFormController controller = Get.put(TicketFormController());

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
            // Moved the Obx to only wrap the specific widgets that need updating
            _buildFormSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    // Obx here only observes the ticketFor value
    return Obx(() {
      if (controller.ticketFor.value == "myself") {
        return ElevatedButton(
          onPressed: () => controller.handleMyself(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue[400],
            foregroundColor: Colors.grey[100],
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Separate Obx for the button text that depends on authentication state
          child: Obx(() => Text(controller.authController.isAuthenticated.value
              ? "Proceed"
              : "Login")),
        );
      } else {
        return Column(
          children: [
            const SizedBox(height: 10),
            // Each TextField that depends on an observable error gets its own Obx
            _buildTextField(
              labelText: "Name *",
              hintText: "Enter passenger's full name",
              controller: controller.nameController,
              errorTextObs: controller.nameError,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              labelText: "Phone Number *",
              hintText: "Enter valid phone number",
              controller: controller.phoneController,
              errorTextObs: controller.phoneError,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              labelText: "Email (optional)",
              hintText: "Enter email address if available",
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.submitForm(context),
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
        );
      }
    });
  }

  Widget _buildRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Obx wraps only the specific radio button that needs updating
        Obx(() => Radio<String>(
              value: "myself",
              groupValue: controller.ticketFor.value,
              onChanged: (value) => controller.setTicketFor(value!),
              activeColor: Colors.lightBlue[700],
            )),
        const Text("For Myself"),
        const SizedBox(width: 20),
        // Obx wraps only the specific radio button that needs updating
        Obx(() => Radio<String>(
              value: "someoneElse",
              groupValue: controller.ticketFor.value,
              onChanged: (value) => controller.setTicketFor(value!),
              activeColor: Colors.lightBlue[700],
            )),
        const Text("For Someone Else"),
      ],
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String hintText,
    required TextEditingController controller,
    RxnString? errorTextObs,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // If we have an error observable, wrap with Obx, otherwise return regular TextField
    if (errorTextObs != null) {
      return Obx(() => TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              errorText: errorTextObs.value,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.lightBlue),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              errorStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            keyboardType: keyboardType,
          ));
    } else {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.lightBlue),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: keyboardType,
      );
    }
  }
}
