import 'package:eticket_atc/controller/transmediaController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/controller/BusController/busFilterController.dart';
import 'package:eticket_atc/widgets/formFields.dart';
import 'package:eticket_atc/widgets/microwidgets/bus/busList.dart';
import 'package:lottie/lottie.dart';

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
        backgroundColor: Colors.lightBlue[50],
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Obx(() => Text(
              '${transController.selectedTransport.value} Search Results')),
        ]),
      ),
      body: Column(
        children: [
          // Wrap the form section in an AnimatedContainer for smooth transition
          Obx(() {
            final bool hasSearchResults =
                transController.selectedTransport.value == 'Bus' &&
                    !busFilterController.isLoading.value &&
                    busFilterController.filteredBuses.isNotEmpty;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: hasSearchResults
                  ? MediaQuery.of(context).size.height * 0.2
                  : MediaQuery.of(context).size.height * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    FormFields(),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[50],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color: Colors.lightBlue[700]!, width: 1))),
                        onPressed: () {
                          if (transController.selectedTransport.value ==
                              'Bus') {
                            Get.find<BusSearchController>().searchBuses();
                          }
                        },
                        child: Text(
                          'Modify Search',
                          style: TextStyle(color: Colors.blueGrey[900]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          // Results section - will expand to fill remaining space
          Expanded(
            child: Obx(() {
              if (transController.selectedTransport.value == 'Bus') {
                if (busFilterController.isLoading.value) {
                  return Center(
                      child: Lottie.asset(
                    'assets/json/busLoading.json',
                    height: 600,
                  ));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_alt_outlined,
                                size: 20,
                                color: Colors.grey[500],
                              ),
                              Text(
                                'Filter',
                                style: TextStyle(
                                  color: Colors.lightBlue[800],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        child:
                            BusList(buses: busFilterController.filteredBuses),
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
