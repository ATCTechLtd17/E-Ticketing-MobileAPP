import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class GeneratePDF {
  static Future<void> createTicketPDF(Map<String, dynamic> ticketData) async {
    final pdf = pw.Document();

    // Extract all ticket information from ticketData
    final passengerName = ticketData["passengerName"] ?? "Guest";
    final email = ticketData["email"] ?? "";
    final phone = ticketData["phone"] ?? "";
    final gender = ticketData["gender"] ?? "";
    final fromCity = ticketData["fromCity"] ?? "";
    final toCity = ticketData["toCity"] ?? "";
    final issueDate = ticketData["issueDate"] ?? "";
    final journeyDate = ticketData["journeyDate"] ?? "";
    final boardingPoint = ticketData["boardingPoint"] ?? "";
    final droppingPoint = ticketData["droppingPoint"] ?? "";
    final departureTime = ticketData["departureTime"] ?? "";
    final arrivalTime = ticketData["arrivalTime"] ?? "";
    final seatNumbers = ticketData["seatNumbers"] ?? [];
    final originalPrice = ticketData["originalPrice"] ?? "";
    final busName = ticketData["busName"] ?? "Hanif Enterprise";
    final busType = ticketData["busType"] ?? "";
    final coachType = ticketData["coachType"] ?? "";
    final ticketId = ticketData["ticketId"] ?? "";
    final transactionId = ticketData["transactionId"] ?? "";

    // Fetch images for PDF
    final Uint8List? logo = await _networkImage(
      'https://upload.wikimedia.org/wikipedia/commons/6/6a/Metrobus_logo.png',
    );

    // Use actual ticketId for QR code if available
    final Uint8List? qrCode = await _networkImage(
      ticketId.isNotEmpty
          ? 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$ticketId'
          : 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=PendingTicket',
    );

    // Define color theme to match UI
    final PdfColor lightBlue =
        PdfColor.fromInt(0xFF90CAF9); // Light blue like Colors.lightBlue[200]
    final PdfColor borderBlue =
        PdfColor.fromInt(0xFFBBDEFB); // Lighter blue for borders
    final PdfColor backgroundGrey =
        PdfColor.fromInt(0xFFF5F5F5); // Grey background

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Ticket header with company info and QR code
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: lightBlue,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (logo != null)
                            pw.Image(pw.MemoryImage(logo),
                                width: 80, height: 40),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            busName,
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.Text(
                            "Dhaka, Bangladesh",
                            style: pw.TextStyle(color: PdfColors.white),
                          ),
                          pw.Text(
                            "01707034372",
                            style: pw.TextStyle(color: PdfColors.white),
                          ),
                        ],
                      ),
                      if (qrCode != null)
                        pw.Container(
                          padding: const pw.EdgeInsets.all(4),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                          child: pw.Image(pw.MemoryImage(qrCode),
                              width: 80, height: 80),
                        ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // Journey Info Card
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: borderBlue, width: 1),
                    borderRadius: pw.BorderRadius.circular(8),
                    color: backgroundGrey,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildLabelValue("From", fromCity),
                                pw.SizedBox(height: 4),
                                _buildLabelValue("Boarding", boardingPoint),
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(3),
                            decoration: pw.BoxDecoration(
                              color: lightBlue,
                              shape: pw.BoxShape.circle,
                            ),
                            child: pw.Icon(
                                pw.IconData(0xe09e), // arrow_forward equivalent
                                color: PdfColors.white),
                          ),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                _buildLabelValue("To", toCity,
                                    alignment: pw.CrossAxisAlignment.end),
                                pw.SizedBox(height: 4),
                                _buildLabelValue("Dropping", droppingPoint,
                                    alignment: pw.CrossAxisAlignment.end),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      pw.Divider(color: lightBlue),
                      pw.SizedBox(height: 12),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabelValue("Date", journeyDate),
                          _buildLabelValue("Departure", departureTime),
                          if (arrivalTime.isNotEmpty)
                            _buildLabelValue("Arrival", arrivalTime),
                        ],
                      ),
                      if (busType.isNotEmpty || coachType.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 12.0),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              if (busType.isNotEmpty)
                                _buildLabelValue("Bus Type", busType),
                              if (coachType.isNotEmpty)
                                _buildLabelValue("Coach", coachType),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // Passenger Info
                _buildSectionTitle("Passenger Details"),
                pw.SizedBox(height: 8),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: borderBlue),
                    borderRadius: pw.BorderRadius.circular(8),
                    color: backgroundGrey,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildLabelValue("Name", passengerName),
                      if (email.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4.0),
                          child: _buildLabelValue("Email", email),
                        ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 4.0),
                        child: _buildLabelValue("Phone", phone),
                      ),
                      if (gender.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4.0),
                          child: _buildLabelValue("Gender", gender),
                        ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // Seat Info
                _buildSectionTitle("Seat Information"),
                pw.SizedBox(height: 8),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: borderBlue),
                    borderRadius: pw.BorderRadius.circular(8),
                    color: backgroundGrey,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildLabelValue(
                          "Seat Number",
                          seatNumbers is List
                              ? seatNumbers.join(', ')
                              : seatNumbers.toString()),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 4.0),
                        child: _buildLabelValue("Price", "৳ $originalPrice"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 4.0),
                        child: _buildLabelValue("Issue Date", issueDate),
                      ),
                      if (ticketId.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4.0),
                          child: _buildLabelValue("Ticket ID", ticketId),
                        ),
                      if (transactionId.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4.0),
                          child:
                              _buildLabelValue("Transaction ID", transactionId),
                        ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // Footer / Company info
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: lightBlue,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "Powered by\nwww.actechltd.com",
                        style:
                            pw.TextStyle(fontSize: 12, color: PdfColors.white),
                      ),
                      pw.Text(
                        "Contact Us\nactechlimited@gmail.com",
                        style:
                            pw.TextStyle(fontSize: 12, color: PdfColors.white),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // Terms & Conditions
                _buildSectionTitle("Terms & Conditions"),
                pw.SizedBox(height: 8),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: backgroundGrey,
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: borderBlue),
                  ),
                  child: pw.Column(
                    children: [
                      _buildBullet(
                          "This ticket has been issued by actechltd.com on behalf of the bus operator."),
                      _buildBullet(
                          "Please carry a printed copy of this e-ticket."),
                      _buildBullet(
                          "Please reach the boarding point 15 minutes prior to departure."),
                      _buildBullet(
                        "THIS TICKET IS NON-TRANSFERABLE / NON-CANCELLABLE. IT CANNOT BE CHANGED / EXCHANGED.",
                        isHighlighted: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save and open the PDF file
    final outputDir = await getApplicationDocumentsDirectory();
    final fileName =
        "ticket_${passengerName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File("${outputDir.path}/$fileName");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }

  // Helper method to create section titles
  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF90CAF9), // Light blue
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  // Helper method to create label-value pairs
  static pw.Widget _buildLabelValue(
    String label,
    String value, {
    pw.CrossAxisAlignment alignment = pw.CrossAxisAlignment.start,
  }) {
    return pw.Column(
      crossAxisAlignment: alignment,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey700,
            fontWeight: pw.FontWeight.normal,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  // Helper method to create bullet points
  static pw.Widget _buildBullet(String text, {bool isHighlighted = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6.0),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 4, right: 4),
            width: 6,
            height: 6,
            decoration: pw.BoxDecoration(
              color:
                  isHighlighted ? PdfColors.red : PdfColor.fromInt(0xFF42A5F5),
              shape: pw.BoxShape.circle,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: 12,
                color: isHighlighted ? PdfColors.red : PdfColors.black,
                fontWeight:
                    isHighlighted ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to download images from URL
  static Future<Uint8List?> _networkImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print("Error loading network image: $e");
    }
    return null;
  }
}
