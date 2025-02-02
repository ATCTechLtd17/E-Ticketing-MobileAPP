import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/widgets/formFields.dart';
import 'package:eticket_atc/widgets/microwidgets/iconButton.dart';
import 'package:eticket_atc/widgets/microwidgets/RoundTrip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forms extends StatefulWidget {
  const Forms({super.key});

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  @override
  Widget build(BuildContext context) {
    final TransMediaController transController =
        Get.put(TransMediaController());
    final BusSearchController busSearchController =
        Get.put(BusSearchController()); 

    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButtons(
              icon: Icons.directions_bus_outlined,
              label: 'Bus',
              controller: transController,
            ),
            IconButtons(
              icon: Icons.flight_outlined,
              label: 'Air',
              controller: transController,
            ),
            IconButtons(
              icon: Icons.train_outlined,
              label: 'Train',
              controller: transController,
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundTripBtn(
              label: 'One Way',
              value: false,
              onTap: () {
                busSearchController.toggleReturnTrip(
                    false); 
              },
            ),
            SizedBox(width: 20), 
            RoundTripBtn(
              label: 'Round Trip',
              value: true,
              onTap: () {
                busSearchController.toggleReturnTrip(
                    true); 
              },
            ),
          ],
        ),
        
        FormFields(),
      ],
    );
  }
}
