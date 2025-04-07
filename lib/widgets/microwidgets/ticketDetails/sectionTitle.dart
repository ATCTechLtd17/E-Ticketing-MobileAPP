import 'package:flutter/material.dart';


class SectionTitleWidget extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color textColor;

  const SectionTitleWidget({
    Key? key,
    required this.title,
    this.backgroundColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}




