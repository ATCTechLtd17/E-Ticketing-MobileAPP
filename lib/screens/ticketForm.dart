import 'package:eticket_atc/widgets/ticketDetails.dart';
import 'package:flutter/material.dart';

class TicketFormPage extends StatefulWidget {
  // Expect extra data from the previous page.
  final List<String> bookedSeats;
  final String busName;
  final String busNumber;
  final double ticketPrice;

  const TicketFormPage({
    super.key,
    required this.bookedSeats,
    required this.busName,
    required this.busNumber,
    required this.ticketPrice,
  });

  @override
  _TicketFormPageState createState() => _TicketFormPageState();
}

class _TicketFormPageState extends State<TicketFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Build ticket data using the entered form data and passed extras.
      final ticketData = {
        "passengerName": nameController.text,
        "phone": phoneController.text,
        "email": emailController.text,
        "busName": widget.busName,
        "busNumber": widget.busNumber,
        "bookedSeats": widget.bookedSeats,
        "ticketPrice": widget.ticketPrice,
        "totalPrice": widget.ticketPrice * widget.bookedSeats.length,
      };

      // Navigate to TicketDetailsPage.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicketDetailsPage(ticketData: ticketData),
        ),
      );
    }
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
      appBar: AppBar(title: const Text("Enter Your Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
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
              // Phone Number Field
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  }
                  return null;
                },
              ),
              // Email Field (optional)
              TextFormField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: "Email (optional)"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
