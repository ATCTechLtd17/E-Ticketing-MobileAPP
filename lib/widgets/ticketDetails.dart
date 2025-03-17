/*
import 'package:eticket_atc/controller/ticketDetailsController.dart';
import 'package:eticket_atc/widgets/microwidgets/pdfGenerate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDetailsPage extends StatelessWidget {
  const TicketDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketController = Get.find<TicketDetailsController>();
    final ticketData = ticketController.ticketData;

    final passengerName = ticketData["passengerName"] ?? "";
    final phone = ticketData["phone"] ?? "";
    final fromCity = ticketData["fromCity"] ?? "";
    final toCity = ticketData["toCity"] ?? "";
    final issueDate = ticketData["issueDate"] ?? "";
    final journeyDate = ticketData["journeyDate"] ?? "";
    final boardingPoint = ticketData["boardingPoint"] ?? "";
    final droppingPoint = ticketData["droppingPoint"] ?? "";
    final departureTime = ticketData["departureTime"] ?? "";
    final seatNumbers = ticketData["seatNumbers"] ?? [];
    final originalPrice = ticketData["originalPrice"] ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Your Ticket")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/6/6a/Metrobus_logo.png',
                        width: 80,
                        errorBuilder: (ctx, _, __) => const SizedBox(),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Hanif Enterprise",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Dhaka, Bangladesh"),
                      const Text("01707034372"),
                    ],
                  ),
                  Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=YourTicketID',
                    width: 80,
                    errorBuilder: (ctx, _, __) => const SizedBox(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRowText(
                        "From:", fromCity, "Journey Date:", journeyDate),
                    _buildRowText("Boarding:", boardingPoint, "Departure:",
                        departureTime),
                    _buildRowText("Issue Date:", issueDate, "To:", toCity),
                    _buildRowText("Dropping:", droppingPoint, "", ""),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Passenger:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(passengerName, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              const Text(
                "Contact:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(phone, style: const TextStyle(fontSize: 14)),

              const SizedBox(height: 16),

              Text("Seat: ${seatNumbers.join(', ')}",
                  style: const TextStyle(fontSize: 14)),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Powered by\nwww.actechltd.com"),
                  Text("Contact Us\nactechlimited@gmail.com"),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                "Terms & Conditions:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              _buildBullet(
                  "This ticket has been issued by actechltd.com on behalf of the bus operator."),
              _buildBullet("Please carry a printed copy of this e-ticket."),
              _buildBullet(
                  "Please reach the boarding point 15 minutes prior to departure."),
              const SizedBox(height: 6),
              const Text(
                "THIS TICKET IS NON-TRANSFERABLE / NON-CANCELLABLE. IT CANNOT BE CHANGED / EXCHANGED.",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),

              const SizedBox(height: 16),

              const Text(
                "Payment Details:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Ticket Price: $originalPrice"),
                  const Text('fysy'),
                  Text("Issued On: $issueDate"),
                  Text("Date of Journey: $journeyDate"),
                ],
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    await GeneratePDF.createTicketPDF(ticketData);
                  },
                  child: const Text("Download Ticket"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowText(
      String title1, String value1, String title2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title1 $value1", style: const TextStyle(fontSize: 12)),
          (title2.isNotEmpty && value2.isNotEmpty)
              ? Text("$title2 $value2", style: const TextStyle(fontSize: 12))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(fontSize: 12)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}
*/

import 'package:eticket_atc/controller/ticketDetailsController.dart';
import 'package:eticket_atc/widgets/microwidgets/pdfGenerate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDetailsPage extends StatelessWidget {

  const TicketDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure TicketDetailsController is registered
    if (!Get.isRegistered<TicketDetailsController>()) {
      Get.put(TicketDetailsController());
    }

    final TicketDetailsController ticketController =
        Get.find<TicketDetailsController>();

    // Initialize with extra data if provided
   

    return Scaffold(
      appBar: AppBar(title: const Text("Your Ticket")),
      body: Obx(() {
        if (ticketController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ticketData = ticketController.ticketData;

        final passengerName = ticketData["passengerName"] ?? "";
        final phone = ticketData["phone"] ?? "";
        final fromCity = ticketData["fromCity"] ?? "";
        final toCity = ticketData["toCity"] ?? "";
        final issueDate = ticketData["issueDate"] ?? "";
        final journeyDate = ticketData["journeyDate"] ?? "";
        final boardingPoint = ticketData["boardingPoint"] ?? "";
        final droppingPoint = ticketData["droppingPoint"] ?? "";
        final departureTime = ticketData["departureTime"] ?? "";
        final seatNumbers = ticketData["seatNumbers"] ?? [];
        final originalPrice = ticketData["originalPrice"] ?? "";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/6/6a/Metrobus_logo.png',
                          width: 80,
                          errorBuilder: (ctx, _, __) => const SizedBox(),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          ticketData["busName"] ?? "Hanif Enterprise",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Dhaka, Bangladesh"),
                        const Text("01707034372"),
                      ],
                    ),
                    Image.network(
                      'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=YourTicketID',
                      width: 80,
                      errorBuilder: (ctx, _, __) => const SizedBox(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRowText(
                          "From:", fromCity, "Journey Date:", journeyDate),
                      _buildRowText("Boarding:", boardingPoint, "Departure:",
                          departureTime),
                      _buildRowText("Issue Date:", issueDate, "To:", toCity),
                      _buildRowText("Dropping:", droppingPoint, "", ""),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Passenger:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(passengerName, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                const Text(
                  "Contact:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(phone, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                Text(
                    "Seat: ${seatNumbers is List ? seatNumbers.join(', ') : seatNumbers}",
                    style: const TextStyle(fontSize: 14)),
                if (ticketData["busType"] != null &&
                    ticketData["coachType"] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                        "Bus Type: ${ticketData["busType"]} | Coach Type: ${ticketData["coachType"]}",
                        style: const TextStyle(fontSize: 14)),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Powered by\nwww.actechltd.com"),
                    Text("Contact Us\nactechlimited@gmail.com"),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Terms & Conditions:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                _buildBullet(
                    "This ticket has been issued by actechltd.com on behalf of the bus operator."),
                _buildBullet("Please carry a printed copy of this e-ticket."),
                _buildBullet(
                    "Please reach the boarding point 15 minutes prior to departure."),
                const SizedBox(height: 6),
                const Text(
                  "THIS TICKET IS NON-TRANSFERABLE / NON-CANCELLABLE. IT CANNOT BE CHANGED / EXCHANGED.",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Payment Details:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Ticket Price: $originalPrice"),
                    const Text('fysy'),
                    Text("Issued On: $issueDate"),
                    Text("Date of Journey: $journeyDate"),
                  ],
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      await GeneratePDF.createTicketPDF(ticketData);
                    },
                    child: const Text("Download Ticket"),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRowText(
      String title1, String value1, String title2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title1 $value1", style: const TextStyle(fontSize: 12)),
          (title2.isNotEmpty && value2.isNotEmpty)
              ? Text("$title2 $value2", style: const TextStyle(fontSize: 12))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(fontSize: 12)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}
