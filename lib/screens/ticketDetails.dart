import 'package:eticket_atc/controller/ticketDetailsController.dart';
import 'package:eticket_atc/widgets/microwidgets/pdfGenerate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDetailsPage extends StatelessWidget {
  final bool showBookButton;

  const TicketDetailsPage({super.key, this.showBookButton = false});

  @override
  Widget build(BuildContext context) {
    // Ensure TicketDetailsController is registered
    if (!Get.isRegistered<TicketDetailsController>()) {
      Get.put(TicketDetailsController());
    }

    final TicketDetailsController ticketController =
        Get.find<TicketDetailsController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Your Ticket"),
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
      ),
      body: Obx(() {
        if (ticketController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.lightBlue,
            ),
          );
        }

        if (ticketController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ticketController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[200],
                    ),
                    onPressed: () => ticketController.refreshTicketData(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final ticketData = ticketController.ticketData;

        // Extract ticket information
        // Extract ticket information - This is the updated section
        final passengerName = ticketController.getStringValue("passengerName");
        final email = ticketController.getStringValue("email");
        final phone = ticketController.getStringValue("phone");
        final gender = ticketController.getStringValue("gender");
        final fromCity = ticketController.getStringValue("fromCity");
        final toCity = ticketController.getStringValue("toCity");
        final issueDate = ticketController.getStringValue("issueDate");
        final journeyDate = ticketController.getStringValue("journeyDate");
        final boardingPoint = ticketController.getStringValue("boardingPoint");
        final droppingPoint = ticketController.getStringValue("droppingPoint");
        final departureTime = ticketController.getStringValue("departureTime");
        final arrivalTime = ticketController.getStringValue("arrivalTime");
        final seatNumbers = ticketController.getListValue("seatNumbers");
        final originalPrice = ticketController.getStringValue("originalPrice");
        final busName = ticketController.getStringValue("busName",
            defaultValue: "Hanif Enterprise");
        final busType = ticketController.getStringValue("busType");
        final coachType = ticketController.getStringValue("coachType");
        final ticketId = ticketController.getStringValue("ticketId");
        final transactionId = ticketController.getStringValue("transactionId");

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Booking status notification
              if (ticketController.bookingSuccess.value)
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
              if (ticketController.bookingError.value.isNotEmpty &&
                  !ticketController.bookingSuccess.value)
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
                    "Booking Error: ${ticketController.bookingError.value}",
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
                  border:
                      Border.all(color: Colors.lightBlue[100]!, width: 1),
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.lightBlue.shade300, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabelValue("From", fromCity,
                                        labelColor: Colors.lightBlue[800]),
                                    const SizedBox(height: 4),
                                    _buildLabelValue("Boarding", boardingPoint,
                                        labelColor: Colors.lightBlue[800]),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[200],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_forward,
                                    color: Colors.white),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _buildLabelValue("To", toCity,
                                        alignment: CrossAxisAlignment.end,
                                        labelColor: Colors.lightBlue[800]),
                                    const SizedBox(height: 4),
                                    _buildLabelValue("Dropping", droppingPoint,
                                        alignment: CrossAxisAlignment.end,
                                        labelColor: Colors.lightBlue[800]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(color: Colors.lightBlue[300]),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLabelValue("Date", journeyDate,
                                  labelColor: Colors.lightBlue[800]),
                              _buildLabelValue("Departure", departureTime,
                                  labelColor: Colors.lightBlue[800]),
                              if (arrivalTime.isNotEmpty)
                                _buildLabelValue("Arrival", arrivalTime,
                                    labelColor: Colors.lightBlue[800]),
                            ],
                          ),
                          if (busType.isNotEmpty || coachType.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (busType.isNotEmpty)
                                    _buildLabelValue("Bus Type", busType,
                                        labelColor: Colors.lightBlue[800]),
                                  if (coachType.isNotEmpty)
                                    _buildLabelValue("Coach", coachType,
                                        labelColor: Colors.lightBlue[800]),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Passenger Info
                    _buildSectionTitle("Passenger Details"),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelValue("Name", passengerName,
                              labelColor: Colors.lightBlue[800]),
                          if (email.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: _buildLabelValue("Email", email,
                                  labelColor: Colors.lightBlue[800]),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: _buildLabelValue("Phone", phone,
                                labelColor: Colors.lightBlue[800]),
                          ),
                          if (gender.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: _buildLabelValue("Gender", gender,
                                  labelColor: Colors.lightBlue[800]),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Seat Info
                    _buildSectionTitle("Seat Information"),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelValue(
                              "Seat Number",
                              // ignore: unnecessary_type_check
                              seatNumbers is List
                                  ? seatNumbers.join(', ')
                                  : seatNumbers.toString(),
                              labelColor: Colors.lightBlue[800]),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: _buildLabelValue("Price", "৳ $originalPrice",
                                labelColor: Colors.lightBlue[800]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: _buildLabelValue("Issue Date", issueDate,
                                labelColor: Colors.lightBlue[800]),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Company Info
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
                    _buildSectionTitle("Terms & Conditions"),
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
                          _buildBullet(
                              "This ticket has been issued by actechltd.com on behalf of the bus operator."),
                          _buildBullet(
                              "Please carry a printed copy of this e-ticket."),
                          _buildBullet(
                              "Please reach the boarding point 15 minutes prior to departure."),
                          _buildBullet(
                              "THIS TICKET IS NON-TRANSFERABLE / NON-CANCELLABLE. IT CANNOT BE CHANGED / EXCHANGED.",
                              isHighlighted: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showBookButton &&
                            !ticketController.bookingSuccess.value)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: ticketController.isBooking.value
                                  ? null
                                  : () => _handleBookTicket(ticketController),
                              icon: ticketController.isBooking.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.confirmation_number),
                              label: Text(ticketController.isBooking.value
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
                            ticketController.bookingSuccess.value)
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

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLabelValue(
    String label,
    String value, {
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
    Color? labelColor,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: labelColor ?? Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBullet(String text, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4, right: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.red : Colors.lightBlue[400],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isHighlighted ? Colors.red : Colors.black87,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
