import 'package:eticket_atc/controller/searchController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatePick extends StatelessWidget {
  final bool isJourneyDate;
  DatePick({required this.isJourneyDate, super.key});

  final BusSearchController busSearchController =
      Get.put(BusSearchController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isJourneyDate ? 'Journey Date' : 'Return Date',
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final date = isJourneyDate
                      ? busSearchController.departureTime.value
                      : busSearchController.returnTime.value;
                  return Text(
                    date != null
                        ? DateFormat('MMMM dd, yyyy').format(date)
                        : 'Select a date',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  );
                }),
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey[600],
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = now;
    DateTime lastDate =
        DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (date) {
        
        return date.isAfter(firstDate.subtract(Duration(days: 1))) &&
            date.isBefore(lastDate.add(Duration(days: 1)));
      },
    );

    if (pickedDate != null) {
      if (isJourneyDate) {
        busSearchController.selectDepartureDate(pickedDate);
      } else {
        busSearchController.selectReturnDate(pickedDate);
      }
    }
  }
}
