import 'package:eticket_atc/models/bus_model.dart';
import 'package:eticket_atc/widgets/microwidgets/bus/busSeatLayout.dart';
import 'package:flutter/material.dart';

class BusDetails extends StatelessWidget {
  final Bus bus;
  const BusDetails({required this.bus, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: Text(bus.busName),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  bus.busName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Type: ${bus.busType}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coach Type: ${bus.coachType}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ticket Price: ৳',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  'Available Seats: ${bus.seatAvailable}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'Departure: ${bus.busSchedule[0].departTime}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Arrival: ${bus.busSchedule[0].arrivalTime}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Flexible(
              child: SingleChildScrollView(
                  child: BusSeatLayout(
            seatCapacity: bus.seatCapacity,
          )
          )
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}
