import 'package:eticket_atc/controller/TicketController/ticketDetailsController.dart';
import 'package:eticket_atc/widgets/microwidgets/pdfGenerate.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/bulletPoint.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/journeyDetails.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/passengerInfo.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/seatDetails.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/sectionTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDetailsPage extends StatelessWidget {
  final bool showBookButton;

  const TicketDetailsPage({super.key, this.showBookButton = false});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TicketDetailsController>()) {
      Get.put(TicketDetailsController());
    }

    final TicketDetailsController ticketDetailsController =
        Get.find<TicketDetailsController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Your Ticket"),
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
      ),
      body: Obx(() {
        if (ticketDetailsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.lightBlue,
            ),
          );
        }

        if (ticketDetailsController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ticketDetailsController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[200],
                    ),
                    onPressed: () =>
                        ticketDetailsController.refreshTicketData(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final ticketData = ticketDetailsController.ticketData;

        // Extract ticket information
        final passengerName =
            ticketDetailsController.getStringValue("passengerName");
        final email = ticketDetailsController.getStringValue("email");
        final phone = ticketDetailsController.getStringValue("phone");
        final gender = ticketDetailsController.getStringValue("gender");
        final fromCity = ticketDetailsController.getStringValue("fromCity");
        final toCity = ticketDetailsController.getStringValue("toCity");
        final issueDate = ticketDetailsController.getStringValue("issueDate");
        final journeyDate =
            ticketDetailsController.getStringValue("journeyDate");
        final boardingPoint =
            ticketDetailsController.getStringValue("boardingPoint");
        final droppingPoint =
            ticketDetailsController.getStringValue("droppingPoint");
        final departureTime =
            ticketDetailsController.getStringValue("departureTime");
        final arrivalTime =
            ticketDetailsController.getStringValue("arrivalTime");
        final seatNumbers = ticketDetailsController.getListValue("seatNumbers");
        final totalPrice =
            ticketDetailsController.getStringValue("totalPrice");
        final busName = ticketDetailsController.getStringValue("busName",
            defaultValue: "Hanif Enterprise");
        final busType = ticketDetailsController.getStringValue("busType");
        final coachType = ticketDetailsController.getStringValue("coachType");
        final ticketId = ticketDetailsController.getStringValue("ticketId");
        final transactionId =
            ticketDetailsController.getStringValue("transactionId");

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Booking status notification
              if (ticketDetailsController.bookingSuccess.value)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Ticket Booked Successfully!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (ticketId.isNotEmpty)
                        Text("Ticket ID: $ticketId",
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                      if (transactionId.isNotEmpty)
                        Text("Transaction ID: $transactionId",
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),

              // Booking error notification
              if (ticketDetailsController.bookingError.value.isNotEmpty &&
                  !ticketDetailsController.bookingSuccess.value)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    "Booking Error: ${ticketDetailsController.bookingError.value}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Ticket content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue[100]!, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200]!,
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ticket header with new color scheme
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/6/6a/Metrobus_logo.png',
                                width: 80,
                                height: 40,
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, _, __) => Container(
                                  width: 80,
                                  height: 40,
                                  color: Colors.grey[50],
                                  child: const Center(child: Text("Logo")),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                busName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Dhaka, Bangladesh",
                                style: TextStyle(color: Colors.white),
                              ),
                              const Text(
                                "01707034372",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                              ticketId.isNotEmpty
                                  ? 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$ticketId'
                                  : 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=PendingTicket',
                              width: 80,
                              height: 80,
                              errorBuilder: (ctx, _, __) => Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.grey[50],
                                ),
                                child: const Center(child: Text("QR Code")),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Journey Info Card
                    JourneyDetails(
                      fromCity: fromCity,
                      toCity: toCity,
                      boardingPoint: boardingPoint,
                      droppingPoint: droppingPoint,
                      journeyDate: journeyDate,
                      departureTime: departureTime,
                      arrivalTime: arrivalTime,
                      busType: busType,
                      coachType: coachType,
                    ),
                    const SizedBox(height: 20),

                    // Passenger Info
                    const SizedBox(height: 8),

                    PassengerInfo(
                      passengerName: passengerName,
                      email: email,
                      phone: phone,
                      gender: gender,
                    ),

                    const SizedBox(height: 20),
                    const SizedBox(height: 20),

                    
                    const SizedBox(height: 8),
                    // Replace the original seat information section:


                    SeatDetails(
                      seatNumbers: seatNumbers,
                      totalPrice: totalPrice,
                      issueDate: issueDate,
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Powered by\nwww.actechltd.com",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          Text("Contact Us\nactechlimited@gmail.com",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Terms & Conditions
                    const SectionTitleWidget(title: "Terms & Conditions"),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.lightBlue.shade200),
                      ),
                      child: Column(
                        children: [
                          BulletPointWidget(
                            text:
                                "This ticket has been issued by actechltd.com on behalf of the bus operator.",
                          ),
                          BulletPointWidget(
                            text:
                                "Please carry a printed copy of this e-ticket.",
                          ),
                          BulletPointWidget(
                            text:
                                "Please reach the boarding point 15 minutes prior to departure.",
                          ),
                          BulletPointWidget(
                            text:
                                "THIS TICKET IS NON-TRANSFERABLE / NON-CANCELLABLE. IT CANNOT BE CHANGED / EXCHANGED.",
                            isHighlighted: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showBookButton &&
                            !ticketDetailsController.bookingSuccess.value)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: ticketDetailsController.isBooking.value
                                  ? null
                                  : () => _handleBookTicket(
                                      ticketDetailsController),
                              icon: ticketDetailsController.isBooking.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.confirmation_number),
                              label: Text(
                                  ticketDetailsController.isBooking.value
                                      ? "Booking..."
                                      : "Book Ticket"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue[400],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        if (!showBookButton ||
                            ticketDetailsController.bookingSuccess.value)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await GeneratePDF.createTicketPDF(ticketData);
                              },
                              icon: const Icon(Icons.download),
                              label: const Text("Download Ticket"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue[400],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _handleBookTicket(TicketDetailsController controller) async {
    // Check required fields
    final Map<String, dynamic> ticketData = controller.ticketData;

    if (ticketData["passengerName"]?.toString().isEmpty ?? true) {
      Get.snackbar(
        "Missing Information",
        "Please provide passenger name",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (ticketData["phone"]?.toString().isEmpty ?? true) {
      Get.snackbar(
        "Missing Information",
        "Please provide phone number",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (ticketData["seatNumbers"] == null ||
        (ticketData["seatNumbers"] is List &&
            ticketData["seatNumbers"].isEmpty)) {
      Get.snackbar(
        "Missing Information",
        "Please select seat(s)",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Proceed with booking
    final result = await controller.bookTicket();

    if (result) {
      Get.snackbar(
        "Success",
        "Your ticket has been booked successfully!",
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
