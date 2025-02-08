import 'package:eticket_atc/controller/seatController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusSeatLayout extends StatelessWidget {
  const BusSeatLayout({super.key});

  Widget buildSeatLayout(SeatController seatController) {
    List<Widget> seatRows = [];
    int seatNumber = 1;
    int totalRows = (seatController.seatCapacity / 4).ceil();

    for (int row = 0; row < totalRows; row++) {
      List<Widget> rowSeats = [];
      for (int pos = 0; pos < 4; pos++) {
        if (seatNumber <= seatController.seatCapacity) {
          rowSeats.add(
            GestureDetector(
              onTap: () => seatController.toggleSeat(seatNumber - 1),
              child: Obx(() => Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: seatController
                          .seatColor(seatController.seatStates[seatNumber - 1]),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'A$seatNumber',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )),
            ),
          );
          seatNumber++;
        } else {
          rowSeats.add(Container(
              width: 50, height: 50, margin: const EdgeInsets.all(4.0)));
        }
        if (pos == 1 && pos != 3) {
          rowSeats.add(const SizedBox(width: 20));
        }
      }
      seatRows.add(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: rowSeats));
    }
    return Column(children: seatRows);
  }

  @override
  Widget build(BuildContext context) {
    final SeatController seatController = Get.find<SeatController>();

    return Column(
      children: [
        const Text('Select Your Seat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Obx(() => buildSeatLayout(seatController)),
        const SizedBox(height: 24),
        Obx(
          () => ElevatedButton(
            onPressed: seatController.bookedCount > 0
                ? seatController.confirmBooking
                : null,
            child: const Text('Confirm Booking'),
          ),
        ),
      ],
    );
  }
}
