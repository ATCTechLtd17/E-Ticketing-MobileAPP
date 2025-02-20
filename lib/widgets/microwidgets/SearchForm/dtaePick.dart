/*import 'package:eticket_atc/controller/searchController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePick extends StatefulWidget {
  final bool isJourneyDate;
  const DatePick({required this.isJourneyDate, super.key});

  @override
  _DatePickState createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  final BusSearchController busSearchController =
      Get.put(BusSearchController());

  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isJourneyDate ? 'Journey Date' : 'Return Date',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
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
                  final date = widget.isJourneyDate
                      ? busSearchController.departureTime.value
                      : busSearchController.returnTime.value;
                  return Text(
                    date != null
                        ? DateFormat('MMMM dd, yyyy').format(date)
                        : 'Select a date',
                    style: TextStyle(fontSize: 14, color: Colors.black),
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
        DateTime(now.year, now.month + 3, 0).subtract(Duration(days: 1));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TableCalendar(
                  firstDay: firstDate,
                  lastDay: lastDate,
                  focusedDay: _focusedDay,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.black),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.black),
                  ),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      
                      _selectedDate = DateTime(
                          selectedDay.year, selectedDay.month, selectedDay.day);
                      _focusedDay = focusedDay;
                    });

                    Navigator.pop(context);

                    if (widget.isJourneyDate) {
                      busSearchController.selectDepartureDate(
                          _selectedDate); 
                      print(_selectedDate); 
                    } else {
                      busSearchController.selectReturnDate(_selectedDate);
                      print(_selectedDate); 
                  }
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 2),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    outsideDaysVisible: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePick extends StatefulWidget {
  final String label;

  final DateTime? selectedDate;

  final Function(DateTime?) onDateSelected;

  final DateTime firstDate;

  final DateTime lastDate;

  const DatePick({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    super.key,
  });

  @override
  _DatePickState createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedDate != null
                      ? DateFormat('MMMM dd, yyyy').format(widget.selectedDate!)
                      : 'Select a date',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
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
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      initialEntryMode:
          DatePickerEntryMode.calendar, 
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.lightBlue, 
            colorScheme: ColorScheme.light(
              primary: Colors.lightBlue, 
              onPrimary: Colors.grey[200]!, 
              surface: Colors.grey[200]!, 
              onSurface: Colors.black,
            ),
             dialogTheme: DialogThemeData(backgroundColor: Colors.grey[300]), 
              textTheme: TextTheme(
              headlineSmall: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400), 
              titleLarge:
                  TextStyle(fontSize: 10), 
              bodyMedium: TextStyle(fontSize: 12), 
            ),
              inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none, 
            ),
          ),

          child: child!,
        );

      },
    );

    if (pickedDate != null) {
      widget.onDateSelected(pickedDate);
    }
  }
}
