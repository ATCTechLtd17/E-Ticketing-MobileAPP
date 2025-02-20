import 'package:eticket_atc/controller/busDetailsController.dart';
import 'package:eticket_atc/models/bus_model.dart';
import 'package:eticket_atc/widgets/microwidgets/bus/busSeatLayout.dart';
import 'package:eticket_atc/widgets/microwidgets/bus/dropdownUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*class BusDetails extends StatelessWidget {
  final Bus bus;
  final String defaultBoarding;
  const BusDetails({required this.bus, this.defaultBoarding = '', super.key});

  @override
  Widget build(BuildContext context) {
    final BusDetailsController busDetailsController = Get.put(
        BusDetailsController(bus: bus, defaultBoarding: defaultBoarding));
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: Text(bus.busName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bus.busName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Type: ${bus.busType}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Coach Type: ${bus.coachType}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Available Seats: ${bus.seatAvailable}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    Text('Departure: ${bus.busSchedule[0].departTime}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Arrival: ${bus.busSchedule[0].arrivalTime}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    Obx(() => Text(
                          'Ticket Price: ৳${busDetailsController.ticketPrice.value.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue[700]!),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => getBoardingPointSelector(
                  bus: bus,
                  selectedValue: busDetailsController.selectedBoarding.value,
                  onSelected: (value) {
                    if (value != busDetailsController.selectedDropping.value) {
                      busDetailsController.setSelectedBoarding(value);
                    }
                  },
                )),
            const SizedBox(height: 12),
            Obx(() => getDroppingPointSelector(
                  bus: bus,
                  selectedValue: busDetailsController.selectedDropping.value,
                  onSelected: (value) {
                    if (value != busDetailsController.selectedBoarding.value) {
                      busDetailsController.setSelectedDropping(value);
                    }
                  },
                )),
            const SizedBox(height: 16),
            BusSeatLayout(seatCapacity: bus.seatCapacity,  busID: bus.id,),
            
          ],
        ),
      ),
    );
  }
}
*/

class BusDetails extends StatelessWidget {
  final Bus bus;
  final String defaultBoarding;
  const BusDetails({required this.bus, this.defaultBoarding = '', super.key});

  @override
  Widget build(BuildContext context) {
    final BusDetailsController busDetailsController = Get.put(
        BusDetailsController(bus: bus, defaultBoarding: defaultBoarding));

    // Prepare the extra data to pass to the next screen
    final extraData = {
      "busName": bus.busName,
      "busNumber": bus.busNumber,
      "ticketPrice": busDetailsController.ticketPrice.value,
    };

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: Text(bus.busName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bus.busName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Type: ${bus.busType}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Coach Type: ${bus.coachType}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Available Seats: ${bus.seatAvailable}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    Text('Departure: ${bus.busSchedule[0].departTime}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Arrival: ${bus.busSchedule[0].arrivalTime}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    Obx(() => Text(
                          'Ticket Price: ৳${busDetailsController.ticketPrice.value.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue[700]!),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => getBoardingPointSelector(
                  bus: bus,
                  selectedValue: busDetailsController.selectedBoarding.value,
                  onSelected: (value) {
                    if (value != busDetailsController.selectedDropping.value) {
                      busDetailsController.setSelectedBoarding(value);
                    }
                  },
                )),
            const SizedBox(height: 12),
            Obx(() => getDroppingPointSelector(
                  bus: bus,
                  selectedValue: busDetailsController.selectedDropping.value,
                  onSelected: (value) {
                    if (value != busDetailsController.selectedBoarding.value) {
                      busDetailsController.setSelectedDropping(value);
                    }
                  },
                )),
            const SizedBox(height: 16),
            // Pass extra data to BusSeatLayout here
            BusSeatLayout(
              seatCapacity: bus.seatCapacity,
              busID: bus.id,
              extraData: extraData, // Pass dynamic data
            ),
          ],
        ),
      ),
    );
  }
}
