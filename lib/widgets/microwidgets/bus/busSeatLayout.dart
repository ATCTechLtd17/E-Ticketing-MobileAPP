import 'package:eticket_atc/controller/seatController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusSeatLayout extends StatelessWidget {
  final int seatCapacity;
  final String busID;

  const BusSeatLayout(
      {required this.seatCapacity, required this.busID, super.key});

  List<String> generateSeatLabels() {
    List<String> labels = [];
    int seatIndex = 0;
    int totalRows = ((seatCapacity - 5) / 4).toInt() + 1;
    for (int row = 0; row < totalRows; row++) {
      String rowLabel = String.fromCharCode(65 + row);
      int seatsInRow = (row == totalRows - 1) ? 5 : 4;
      for (int pos = 0; pos < seatsInRow; pos++) {
        if (seatIndex < seatCapacity) {
          labels.add('$rowLabel${pos + 1}');
          seatIndex++;
        }
      }
    }
    return labels;
  }

  Widget buildSeatLayout(
      SeatController seatController, List<String> seatLabels) {
    List<Widget> seatRows = [];
    int seatIndex = 0;
    int totalRows = ((seatCapacity - 5) / 4).toInt() + 1;

    for (int row = 0; row < totalRows; row++) {
      List<Widget> rowSeats = [];
      int seatsInRow = (row == totalRows - 1) ? 5 : 4;

      for (int pos = 0; pos < seatsInRow; pos++) {
        if (seatIndex < seatCapacity) {
          final currentSeatIndex = seatIndex;
          rowSeats.add(
            GestureDetector(
              onTap: () => seatController.toggleSeat(currentSeatIndex),
              child: Obx(
                () => Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: seatController.seatColor(
                      seatController.seatStates[currentSeatIndex],
                    ),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    seatLabels[currentSeatIndex],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          );
          seatIndex++;
        }
      }

      if (seatsInRow == 4) {
        rowSeats.insert(2, const SizedBox(width: 25));
      }
      seatRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowSeats,
        ),
      );
    }
    return Column(children: seatRows);
  }

  @override
  Widget build(BuildContext context) {
    final seatLabels = generateSeatLabels();
    final SeatController seatController = Get.put(
      SeatController(
        seatCapacity: seatCapacity,
        busId: busID,
        seatLabels: seatLabels,
      ),
    );

    return Column(
      children: [
        const Text(
          'Select Your Seat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        buildSeatLayout(seatController, seatLabels),
        const SizedBox(height: 24),
        Obx(
          () => ElevatedButton(
            onPressed: seatController.userBookedCount > 0
                ? seatController.confirmBooking
                : null,
            child: const Text('Confirm Booking'),
          ),
        ),
      ],
    );
  }
}
