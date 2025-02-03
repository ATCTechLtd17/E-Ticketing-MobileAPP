import 'package:eticket_atc/controller/transmediaController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/controller/busFilterController.dart';
import 'package:eticket_atc/widgets/formFields.dart';
import 'package:eticket_atc/widgets/microwidgets/busList.dart';


class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the controllers (make sure they are properly instantiated in your app)
    final TransMediaController transController =
        Get.find<TransMediaController>();
    final BusFilterController busFilterController =
        Get.find<BusFilterController>();
    // final AirFilterController airFilterController =
    //     Get.find<AirFilterController>();
    // final TrainFilterController trainFilterController =
    //     Get.find<TrainFilterController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
            () => Text('${transController.selectedTransport.value} Results')),
      ),
      body: Column(
        children: [
          // The search input fields along with suggestions/date pickers
          const FormFields(),
          const SizedBox(height: 20),
          // Modify Search button (you can choose to re-run the search or navigate back)
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
                  return const Center(child: CircularProgressIndicator());
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
