import 'package:eticket_atc/controller/transmediaController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IconButtons extends StatelessWidget {
  final IconData icon;
  final String label;
  final TransMediaController controller;

  const IconButtons(
      {required this.icon,
      required this.label,
      required this.controller,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.toggleSelected(label),
      child: Obx(() {
        final selected = controller.isSelected(label);
        return Column(
          children: [
            Icon(icon, color: selected ? Colors.lightBlue[600] : Colors.grey),
            SizedBox(
              height: 4,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.lightBlue[600] : Colors.grey,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          ],
        );
      }),
    );
  }
}
