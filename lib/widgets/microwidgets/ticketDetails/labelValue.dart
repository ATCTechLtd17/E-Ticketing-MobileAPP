import 'package:flutter/material.dart';

class LabelValueWidget extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;
  final Color? labelColor;
  final Color valueColor;
  final double labelFontSize;
  final double valueFontSize;

  const LabelValueWidget({
    Key? key,
    required this.label,
    required this.value,
    this.alignment = CrossAxisAlignment.start,
    this.labelColor,
    this.valueColor = Colors.black,
    this.labelFontSize = 12,
    this.valueFontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: labelColor ?? Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
