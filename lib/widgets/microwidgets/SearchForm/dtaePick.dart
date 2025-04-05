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
    // Instead of showDatePicker, we'll use a custom dialog with calendar
    // that can auto-confirm selection
    DateTime initialDate = widget.selectedDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
          ),
          child: Dialog(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    onDateChanged: (DateTime date) {
                      // Auto-confirm when date is selected
                      widget.onDateSelected(date);
                      Navigator.pop(context); // Close dialog automatically
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
