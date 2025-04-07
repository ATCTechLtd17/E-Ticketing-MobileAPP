import 'package:flutter/material.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/labelValue.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/sectionTitle.dart';

class SeatDetails extends StatelessWidget {
  final List<dynamic> seatNumbers;
  final String totalPrice;
  final String issueDate;

  const SeatDetails({
    super.key,
    required this.seatNumbers,
    required this.totalPrice,
    required this.issueDate,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: "Seat Information"),
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
              LabelValueWidget(
                label: "Seat Number",
                value: seatNumbers.join(', '),
                labelColor: Colors.lightBlue[800],
                valueColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: LabelValueWidget(
                  label: "Price",
                  value: "৳ $totalPrice",
                  labelColor: Colors.lightBlue[800],
                  valueColor: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: LabelValueWidget(
                  label: "Issue Date",
                  value: issueDate,
                  labelColor: Colors.lightBlue[800],
                  valueColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
