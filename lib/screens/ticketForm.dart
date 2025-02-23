import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TicketFormPage extends StatefulWidget {
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
  String ticketFor = "myself"; // Default selection: "For Myself"

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
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

      context.push('/ticketDetails', extra: ticketData);
    }
  }

  void _navigateToLogin() {
    final ticketData = {
      "busName": widget.busName,
      "busNumber": widget.busNumber,
      "bookedSeats": widget.bookedSeats,
      "ticketPrice": widget.ticketPrice,
      "totalPrice": widget.ticketPrice * widget.bookedSeats.length,
    };

    
    context.push('/login', extra: ticketData);
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
              ElevatedButton(
                onPressed: _navigateToLogin,
                child: const Text("Login"),
              )
            else
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("Submit"),
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
