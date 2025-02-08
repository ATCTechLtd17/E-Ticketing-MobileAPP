import 'package:eticket_atc/controller/transmediaController.dart';
import 'package:eticket_atc/widgets/graidentIcon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/controller/busFilterController.dart';
import 'package:eticket_atc/widgets/formFields.dart';
import 'package:eticket_atc/widgets/microwidgets/bus/busList.dart';

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
              Obx(() => Text(
                  '${transController.selectedTransport.value} Search Results')),
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
            ],
          )),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          FormFields(),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side:
                          BorderSide(color: Colors.lightBlue[700]!, width: 1))),
              onPressed: () {
                if (transController.selectedTransport.value == 'Bus') {
                  Get.find<BusSearchController>().searchBuses();
                }
              },
              child: Text(
                'Modify Search',
                style: TextStyle(color: Colors.blueGrey[900]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (transController.selectedTransport.value == 'Bus') {
                if (busFilterController.isLoading.value) {
                  return Center(
                    child: GradientIcon(
                      size: 100,
                      icon: Icons.all_inclusive,
                      gradientColors: const [
                        Colors.lightBlue,
                        Colors.purpleAccent
                      ],
                      shimmerColors: [
                        Colors.lightBlueAccent,
                        Colors.grey,
                        Colors.black,
                      ],
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: (){
                      
                      }, 
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt_outlined, size: 20, color: Colors.grey[500],),
                          Text('Filter', 
                          style: TextStyle(
                            color: Colors.lightBlue[800],
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          ),
                        ],
                      )
                      ),
                      Expanded(
                        child: BusList(buses: busFilterController.filteredBuses),
                          ),
                    ],
                  );
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
