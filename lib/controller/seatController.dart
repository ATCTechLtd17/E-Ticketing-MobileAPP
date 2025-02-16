import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeatController extends GetxController {
  final int seatCapacity;

  
  RxList<String> seatStates = <String>[].obs;
  RxList<int> bookedSeats = <int>[].obs; 

  SeatController({required this.seatCapacity}) {
    seatStates.value = List.filled(seatCapacity, 'available');
  }

  int get bookedCount => bookedSeats.length;

  void toggleSeat(int index) {
    if (seatStates[index] == 'available') {
      if (bookedCount < 4) {
        seatStates[index] = 'booked';
        bookedSeats.add(index);
      } else {
        Get.snackbar('Error', 'You cannot book more than 4 seats at a time.');
      }
    } else if (seatStates[index] == 'booked') {
      seatStates[index] = 'available';
      bookedSeats.remove(index);
    }
    seatStates.refresh();
    bookedSeats.refresh();
  }

  void confirmBooking() {
    for (int index in bookedSeats) {
      seatStates[index] = 'sold';
    }
    sendBookingToDatabase(bookedSeats);
    bookedSeats.clear();
    seatStates.refresh();
    Get.snackbar("Success", "Booking confirmed!");
  }


  Future<void> sendBookingToDatabase(List<int> selectedSeats) async {
    try {
      
      var response = await GetConnect().post(
        'https://your-api.com/book-seats',
        {'seats': selectedSeats},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Seats booked successfully!");
      } else {
        Get.snackbar("Error", "Failed to book seats.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to the server.");
    }
  }

  Color seatColor(String state) {
    switch (state) {
      case 'booked':
        return Colors.lightBlue[4300]!;
      case 'sold':
        return Colors.grey[800]!;
      default:
        return Colors.lightBlue[100]!;
    }
  }
}
