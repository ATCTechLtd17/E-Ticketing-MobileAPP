import 'package:eticket_atc/controller/transmediaController.dart';
import 'package:eticket_atc/widgets/graidentIcon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/controller/busFilterController.dart';
import 'package:eticket_atc/widgets/formFields.dart';
import 'package:eticket_atc/widgets/microwidgets/busList.dart';


class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final TransMediaController transController =
        Get.find<TransMediaController>();
    final BusFilterController busFilterController =
        Get.find<BusFilterController>();
    // final AirFilterController airFilterController =
    //     Get.find<AirFilterController>();
    // final TrainFilterController trainFilterController =
    //     Get.find<TrainFilterController>();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Obx(
            () => Text('${transController.selectedTransport.value} Results')),
            GradientIcon(
            size: 70,
            icon: Icons.all_inclusive,
            gradientColors: [Colors.white, Colors.black],
            shimmerColors: [
                  Colors.lightBlue[300]!,
                  Colors.lightBlue[500]!,
                  Colors.purple[200]!,
                  Colors.purpleAccent[400]!,
                  Colors.deepPurpleAccent,
                ],
            ),
        ],)
       
      ),
      body: Column(
        children: [
         SizedBox(height: 20,),
          const FormFields(),
          const SizedBox(height: 20),
          
          Center(
            child: ElevatedButton(
              onPressed: () {
                // For example, you might re-run the search.
                // You can call the appropriate search method based on transport type.
                if (transController.selectedTransport.value == 'Bus') {
                  Get.find<BusSearchController>().searchBuses();
                }
                // Similarly, you would trigger the search for Air or Train
                // or navigate back to a previous screen if that suits your UX.
              },
              child: const Text('Modify Search'),
            ),
          ),
          const SizedBox(height: 20),
          // Scrollable list of available transports
          Expanded(
            child: Obx(() {
              // Based on the selected transport, show the appropriate list.
              if (transController.selectedTransport.value == 'Bus') {
                if (busFilterController.isLoading.value) {
                  return Center(child: GradientIcon(
                      size: 100,
                      icon: Icons.all_inclusive,
                      gradientColors: const [Colors.lightBlue, Colors.purpleAccent],
                      shimmerColors: [
                        Colors.lightBlueAccent,
                        Colors.grey,
                        Colors.black,
                      ],
                    ),
                  );
                } else {
                  return BusList(buses: busFilterController.filteredBuses);
                }
              } else if (transController.selectedTransport.value == 'Air') {
                
                  return Text('Airs');
                  // AirList(
                      //airTransports: airFilterController.filteredAirTransports);
                
              } else if (transController.selectedTransport.value == 'Train') {
                
                  return Text('Trains');
                 // TrainList(
                     // trains: trainFilterController.filteredTrains);
                
              } else {
                return const Center(child: Text('No results available.'));
              }
            }),
          ),
        ],
      ),
    );
  }
}
