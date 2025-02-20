import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class TicketDetailsPage extends StatelessWidget {
  final Map<String, dynamic> ticketData;

  const TicketDetailsPage({super.key, required this.ticketData});

  @override
  Widget build(BuildContext context) {
    final passengerName = ticketData["passengerName"];
    final phone = ticketData["phone"];
    final busName = ticketData["busName"];
    final busNumber = ticketData["busNumber"];
    final List<String> bookedSeats =
        List<String>.from(ticketData["bookedSeats"]);
    final double ticketPrice = ticketData["ticketPrice"];
    final double totalPrice = ticketData["totalPrice"];

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(title: const Text("Your Ticket",)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ticket Downloaded Successfully!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30, thickness: 2),
            Text("Passenger Name: $passengerName",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Phone Number: $phone", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Bus Name: $busName", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Bus Number: $busNumber",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Seat Numbers: ${bookedSeats.join(', ')}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Ticket Price (per seat): ৳${ticketPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Total Price: ৳${totalPrice.toStringAsFixed(2)}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _generatePdf(ticketData, context);
              },
              child: const Text("Download Ticket"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdf(
      Map<String, dynamic> ticketData, BuildContext context) async {
    final pdf = pw.Document();

    // Add page with ticket details
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Ticket Downloaded Successfully!",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("Passenger Name: ${ticketData["passengerName"]}"),
              pw.SizedBox(height: 10),
              pw.Text("Phone Number: ${ticketData["phone"]}"),
              pw.SizedBox(height: 10),
              pw.Text("Bus Name: ${ticketData["busName"]}"),
               pw.SizedBox(height: 10),
              pw.Text("Bus Number: ${ticketData["busNumber"]}"),
               pw.SizedBox(height: 10),
              pw.Text("Seat Numbers: ${ticketData["bookedSeats"].join(', ')}"),
               pw.SizedBox(height: 10),
              pw.Text(
                  "Ticket Price (per seat): ৳${ticketData["ticketPrice"].toStringAsFixed(2)}"),
                   pw.SizedBox(height: 10),
              pw.Text(
                  "Total Price: ৳${ticketData["totalPrice"].toStringAsFixed(2)}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final file =
        File("${outputDir.path}/ticket_${ticketData["passengerName"]}.pdf");

    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ticket saved to device!")),
    );
  }
}
