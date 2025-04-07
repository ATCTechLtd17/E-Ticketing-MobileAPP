import 'package:flutter/material.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/labelValue.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/sectionTitle.dart';

class PassengerInfo extends StatelessWidget {
  final String passengerName;
  final String email;
  final String phone;
  final String gender;

  const PassengerInfo({
    super.key,
    required this.passengerName,
    this.email = '',
    required this.phone,
    this.gender = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: "Passenger Details"),
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
                label: "Name",
                value: passengerName,
                labelColor: Colors.lightBlue[800],
              ),
              if (email.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: LabelValueWidget(
                    label: "Email",
                    value: email,
                    labelColor: Colors.lightBlue[800],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: LabelValueWidget(
                  label: "Phone",
                  value: phone,
                  labelColor: Colors.lightBlue[800],
                ),
              ),
              if (gender.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: LabelValueWidget(
                    label: "Gender",
                    value: gender,
                    labelColor: Colors.lightBlue[800],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
