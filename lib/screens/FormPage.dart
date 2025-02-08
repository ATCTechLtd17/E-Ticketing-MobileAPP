import 'package:eticket_atc/controller/busFilterController.dart';
import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/controller/transmediaController.dart';
import 'package:eticket_atc/widgets/formFields.dart';
import 'package:eticket_atc/widgets/graidentIcon.dart';
import 'package:eticket_atc/widgets/microwidgets/form/iconButton.dart';
import 'package:eticket_atc/widgets/microwidgets/form/RoundTrip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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
    final BusFilterController busFilterController =
        Get.put(BusFilterController());

    return  Column(
      children: [
        const SizedBox(height: 30),
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
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundTripBtn(
              label: 'One Way',
              value: false,
              onTap: () {
                busSearchController.toggleReturnTrip(false);
              },
            ),
            const SizedBox(width: 20),
            RoundTripBtn(
              label: 'Round Trip',
              value: true,
              onTap: () {
                busSearchController.toggleReturnTrip(true);
              },
            ),
          ],
        ),
        Obx((){
         return transController.selectedTransport.value == 'Bus'? Column(
          children: [
             FormFields(),
             const SizedBox(height: 20),
        Center(
          child: Obx(() {
            return ElevatedButton(
              
              style: ElevatedButton.styleFrom(
                
                
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Colors.lightBlue[800]!,
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5)
              ),
              onPressed: busFilterController.isLoading.value
                  ? null
                  : () async {
                     
                      busSearchController.searchBuses();
                      
                      context.go('/search-results');
                    },
              child: busFilterController.isLoading.value
                  ? GradientIcon(
                size: 70,
                icon: Icons.all_inclusive,
                gradientColors: [Colors.white, Colors.black],
                shimmerColors: [
                        Colors.white,
                        Colors.grey,
                        Colors.black,
                      ],
              )
                  : Text('Search Bus', 
                  style: TextStyle(
                    color: Colors.lightBlue[700],
                  ),),
            );
    
          }),
        ),
          ],
        ) : Container(
          padding: EdgeInsets.all(12),
          child: Center(
            
            child: Text('Something Gorgeous is coming', style: TextStyle(
              color: Colors.lightBlue[700],
              fontWeight: FontWeight.bold,
              fontSize: 40
            ),
            textAlign: TextAlign.center,)
            ),
        );
        }),
        
        
        const SizedBox(height: 20),
        
      ],
    );

    
     }
}
