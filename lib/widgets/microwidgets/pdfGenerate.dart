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

    // Fetch images for PDF
    final Uint8List? logo = await _networkImage(
      'https://upload.wikimedia.org/wikipedia/commons/6/6a/Metrobus_logo.png',
    );
    final Uint8List? qrCode = await _networkImage(
      'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=YourTicketID',
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 1),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionContainer(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (logo != null)
                            pw.Image(pw.MemoryImage(logo), width: 80),
                          pw.SizedBox(height: 5),
                          pw.Text("Hanif Enterprise",
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text("Dhaka, Bangladesh"),
                          pw.Text("01707034372"),
                        ],
                      ),
                      if (qrCode != null)
                        pw.Image(pw.MemoryImage(qrCode), width: 80),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                _sectionContainer(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _pdfRowText(
                          "From:",
                          ticketData["fromCity"] ?? "Dhaka",
                          "Journey Date:",
                          ticketData["journeyDate"] ?? "22, Feb 2025"),
                      _pdfRowText(
                          "Boarding:",
                          ticketData["boardingPoint"] ?? "Kajla",
                          "Departure:",
                          ticketData["departureTime"] ?? "2:00 PM"),
                      _pdfRowText(
                          "Issue Date:",
                          ticketData["issueDate"] ?? "22, Feb 2025",
                          "To:",
                          ticketData["toCity"] ?? "Rajshahi"),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                _sectionContainer(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Passenger:",
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Text(ticketData["passengerName"] ?? "John Doe",
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        "Seat: ${(ticketData["seatNumbers"] ?? [
                              "C2",
                              "C3"
                            ]).join(', ')}",
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                _sectionContainer(
                  child: pw.Text(
                    "Terms & Conditions:",
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                _pdfBullet(
                    "This ticket has been issued by actechltd.com on behalf of the bus operator."),
                _pdfBullet("Please carry a printed copy of this e-ticket."),
                _pdfBullet(
                    "Please reach the boarding point 15 minutes prior to departure."),
                pw.SizedBox(height: 6),
                pw.Text(
                  "THIS TICKET IS NON-TRANSFERABLE / NON-CANCELLABLE. IT CANNOT BE CHANGED / EXCHANGED.",
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red),
                ),
              ],
            ),
          );
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final file =
        File("${outputDir.path}/ticket_${ticketData["passengerName"]}.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }

  static pw.Widget _sectionContainer({required pw.Widget child}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      child: child,
    );
  }

  static pw.Widget _pdfRowText(
      String title1, String value1, String title2, String value2) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("$title1 $value1", style: const pw.TextStyle(fontSize: 12)),
          pw.Text("$title2 $value2", style: const pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static pw.Widget _pdfBullet(String text) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("• ", style: pw.TextStyle(fontSize: 12)),
        pw.Expanded(
            child: pw.Text(text, style: const pw.TextStyle(fontSize: 12))),
      ],
    );
  }

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
