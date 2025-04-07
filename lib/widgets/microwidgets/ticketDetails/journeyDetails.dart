import 'package:flutter/material.dart';
import 'package:eticket_atc/widgets/microwidgets/ticketDetails/labelValue.dart';

class JourneyDetails extends StatelessWidget {
  final String fromCity;
  final String toCity;
  final String boardingPoint;
  final String droppingPoint;
  final String journeyDate;
  final String departureTime;
  final String arrivalTime;
  final String busType;
  final String coachType;

  const JourneyDetails({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.boardingPoint,
    required this.droppingPoint,
    required this.journeyDate,
    required this.departureTime,
    this.arrivalTime = '',
    this.busType = '',
    this.coachType = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue.shade300, width: 1),
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
                    LabelValueWidget(
                      label: "From",
                      value: fromCity,
                      labelColor: Colors.black,
                      valueColor: Colors.black,
                    ),
                    const SizedBox(height: 4),
                    LabelValueWidget(
                      label: "Boarding",
                      value: boardingPoint,
                      labelColor: Colors.black,
                      valueColor: Colors.black,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    LabelValueWidget(
                      label: "To",
                      value: toCity,
                      alignment: CrossAxisAlignment.end,
                      labelColor: Colors.black,
                      valueColor: Colors.black,
                    ),
                    const SizedBox(height: 4),
                    LabelValueWidget(
                      label: "Dropping",
                      value: droppingPoint,
                      alignment: CrossAxisAlignment.end,
                      labelColor: Colors.black,
                      valueColor: Colors.black,
                    ),
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
              LabelValueWidget(
                label: "Date",
                value: journeyDate,
                labelColor: Colors.black,
                valueColor: Colors.black,
              ),
              LabelValueWidget(
                label: "Departure",
                value: departureTime,
                labelColor: Colors.black,
                valueColor: Colors.black,
              ),
              if (arrivalTime.isNotEmpty)
                LabelValueWidget(
                  label: "Arrival",
                  value: arrivalTime,
                  labelColor: Colors.black,
                  valueColor: Colors.black,
                ),
            ],
          ),
          if (busType.isNotEmpty || coachType.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (busType.isNotEmpty)
                    LabelValueWidget(
                      label: "Bus Type",
                      value: busType,
                      labelColor: Colors.black,
                      valueColor: Colors.black,
                    ),
                  if (coachType.isNotEmpty)
                    LabelValueWidget(
                      label: "Coach",
                      value: coachType,
                      labelColor: Colors.black,
                      valueColor: Colors.black,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
