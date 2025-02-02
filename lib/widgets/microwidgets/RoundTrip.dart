import 'package:eticket_atc/controller/searchController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundTripBtn extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback onTap;
  const RoundTripBtn(
      {required this.label,
      required this.value,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    final BusSearchController busSearchController =
        Get.find<BusSearchController>(); 

    return Obx(() {
      bool selected = busSearchController
          .isReturn.value; 
      return Center(
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: selected,
              activeColor: Colors.lightBlue[600],
              onChanged: (val) {
                busSearchController
                    .toggleReturnTrip(val ?? true); 
              },
            ),
            GestureDetector(
              onTap: onTap, 
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected == value
                      ? Colors.lightBlue[600]
                      : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
