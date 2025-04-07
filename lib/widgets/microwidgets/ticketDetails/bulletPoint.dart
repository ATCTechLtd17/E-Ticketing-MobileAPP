import 'package:flutter/material.dart';

class BulletPointWidget extends StatelessWidget {
  final String text;
  final bool isHighlighted;
  final Color? bulletColor;
  final Color? textColor;
  final double fontSize;

  const BulletPointWidget({
    Key? key,
    required this.text,
    this.isHighlighted = false,
    this.bulletColor,
    this.textColor,
    this.fontSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color defaultBulletColor =
        isHighlighted ? Colors.red : Colors.lightBlue[400]!;
    final Color defaultTextColor = isHighlighted ? Colors.red : Colors.black87;

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
              color: bulletColor ?? defaultBulletColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor ?? defaultTextColor,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
