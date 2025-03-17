// ignore_for_file: use_build_context_synchronously

import 'package:eticket_atc/controller/ticketDetailsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SeatController extends GetxController {
  final int seatCapacity;
  final String busId;
  final List<String> seatLabels;

  RxList<String> seatStates = <String>[].obs;
  RxList<int> localSelectedSeats = <int>[].obs;
  String? busSeatBlockId;

  SeatController({
    required this.seatCapacity,
    required this.busId,
    required this.seatLabels,
  }) {
    seatStates.value = List.filled(seatCapacity, 'available');
    getBookedSeats();
  }

  int get userBookedCount => localSelectedSeats.length;

  final GetConnect getConnect = GetConnect();

  void toggleSeat(int index) async {
    if (seatStates[index] == 'available' &&
        !localSelectedSeats.contains(index)) {
      if (userBookedCount < 4) {
        localSelectedSeats.add(index);
        seatStates[index] = 'booked';
        seatStates.refresh();

        await bookSeatInDatabase(index);
      } else {
        Get.snackbar('Error', 'You cannot book more than 4 seats at a time.');
      }
    } else if (seatStates[index] == 'booked' &&
        localSelectedSeats.contains(index)) {
      localSelectedSeats.remove(index);
      seatStates[index] = 'available';
      seatStates.refresh();
    } else {
      Get.snackbar(
          'Error', 'You cannot unbook a seat that you did not select.');
    }
  }

  Future<void> bookSeatInDatabase(int seatIndex) async {
    final String seatNum = seatLabels[seatIndex];
    print("Attempting to book seat: $seatNum at index: $seatIndex");

    if (busSeatBlockId == null) {
      try {
        final res = await getConnect.get(
          'https://e-ticketing-server.vercel.app/api/v1/bus-ticket-book/get-seat-block/$busId',
        );
        print("GET seat block response: ${res.body}");

        if (res.statusCode == 200 && res.body != null) {
          final data = res.body['data'];
          if (data is List && data.isNotEmpty) {
            final block = data[0];
            if (block is Map && block.containsKey('id')) {
              busSeatBlockId = block['id'];
              print("busSeatBlockId set to: $busSeatBlockId");
            }
          }
        }
      } catch (e) {
        print("Exception while fetching seat block: $e");
        return;
      }
    }

    if (busSeatBlockId == null) {
      print("Error: busSeatBlockId is null");
      return;
    }

    try {
      final response = await getConnect.post(
        'https://e-ticketing-server.vercel.app/api/v1/bus-ticket-book/create-bus-ticket',
        {
          'id': busSeatBlockId,
          'busId': busId,
          'seatNumber': [seatNum],
        },
      );
      print("POST booking response: ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201 &&
              response.body != null &&
              response.body['data'] != null) {
        seatStates[seatIndex] = 'booked';
        seatStates.refresh();
        Get.snackbar("Success", "Seat $seatNum booked successfully!");
        Future.delayed(Duration(seconds: 1), () {
          getBookedSeats();
        });
      } else {
        print("Failed to book seat $seatNum. Response: ${response.body}");
        seatStates[seatIndex] = 'available';
        seatStates.refresh();
      }
    } catch (e) {
      print("Exception while booking seat $seatNum: $e");
      seatStates[seatIndex] = 'available';
      seatStates.refresh();
    }
  }

  Future<void> getBookedSeats() async {
    print("Fetching booked seats for busId: $busId");
    try {
      final response = await getConnect.get(
        'https://e-ticketing-server.vercel.app/api/v1/bus-ticket-book/get-seat-block/$busId?timestamp=${DateTime.now().millisecondsSinceEpoch}',
      );
      print("GET seat block response: ${response.body}");

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body['data'];
        if (data is List && data.isNotEmpty) {
          final block = data[0];
          if (block is Map && block.containsKey('seatNumber')) {
            final seatNumbers = block['seatNumber'];
            if (seatNumbers is List) {
              for (var seat in seatNumbers) {
                if (seat is String) {
                  int index = seatLabels.indexOf(seat);
                  if (index != -1 && !localSelectedSeats.contains(index)) {
                    seatStates[index] = 'booked';
                  }
                }
              }
            }
          }
        }
        seatStates.refresh();
      }
    } catch (e) {
      print("Exception while fetching seat block: $e");
    }
  }

  // In seatController.dart - Modify confirmBooking method
  void confirmBooking(BuildContext context, Map<String, dynamic> extraData) {
    final bookedSeatLabels =
        localSelectedSeats.map((index) => seatLabels[index]).toList();

    for (int index in localSelectedSeats) {
      seatStates[index] = 'sold';
    }
    seatStates.refresh();
    localSelectedSeats.clear();
    Get.snackbar("Success", "Booking confirmed!");

    // Calculate total price
    final totalPrice = bookedSeatLabels.length * extraData["ticketPrice"];

    // Get the ticket controller and update data directly
    final ticketController = Get.find<TicketDetailsController>();
    if (!Get.isRegistered<TicketDetailsController>()) {
      Get.put(TicketDetailsController());
    }

    ticketController.updateTicketFields({
      "seatNumbers": bookedSeatLabels,
      "busName": extraData["busName"],
      "busNumber": extraData["busNumber"],
      "ticketPrice": extraData["ticketPrice"],
      "totalPrice": totalPrice
    });

    // Navigate without passing data
    Future.delayed(const Duration(milliseconds: 300), () {
      GoRouter.of(context).go('/ticketForm');
    });
  }

  Color seatColor(String state) {
    switch (state) {
      case 'booked':
        return Colors.lightBlue[400]!;
      case 'sold':
        return Colors.grey[200]!;
      case 'available':
        return Colors.lightBlue[100]!;
      default:
        return Colors.lightBlue[100]!;
    }
  }
}
