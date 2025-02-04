import 'package:eticket_atc/models/bus_model.dart';
import 'package:flutter/material.dart';


class BusList extends StatelessWidget {
  final List<Bus>buses;
  const BusList({required this.buses, super.key});

  @override
  Widget build(BuildContext context) {
    if(buses.isEmpty){
      return Center(
        child: Text('No Bus Found on this Date'),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: buses.length,
      itemBuilder: (context, index){
        final bus = buses[index];

        return Card(
  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  elevation: 3,
  child: Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.lightBlue[100]
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bus.busName, 
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue[700],
          ),
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${bus.busSchedule[0].startPoint} → ${bus.busSchedule[0].endPoint}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '৳${bus.ticketPrice}', // Ticket Price
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Departure: ${bus.busSchedule[0].departTime}',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              'Arrival: ${bus.busSchedule[0].arrivalTime}',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'Date: ${bus.busSchedule[0].departureDate}',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    ),
  ),
);

      });
  }
}