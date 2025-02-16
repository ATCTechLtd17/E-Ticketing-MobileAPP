import 'package:eticket_atc/models/bus_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusList extends StatelessWidget {
  final List<Bus> buses;
  const BusList({required this.buses, super.key});

  @override
  Widget build(BuildContext context) {
    if (buses.isEmpty) {
      print(buses);
      return Center(
        child: Text('No Bus Found on this Date'),
      );
    }
    return ListView.builder(
      controller: ScrollController(),
        shrinkWrap: true,
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];

          return InkWell(
            onTap: (){
              context.push('/bus-details', extra: bus);
            },
            child: Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.lightBlue[100]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        bus.busName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue[700],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '[${bus.busType}]',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Text(
                    '${bus.seatAvailable} seats are available',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${bus.busSchedule[0].startPoint} → ${bus.busSchedule[0].endPoint}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                            backgroundColor: Colors.lightBlue[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 1,
                                color: Colors.lightBlue[800]!
                              )
                            )
                          ),
                          onPressed: (){}, 
                          child: Text('Cancellation Policy',
                          style: TextStyle(
                            color: Colors.lightBlue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          )
                          ),
                      ),
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(2),
                            backgroundColor: Colors.lightBlue[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 1,
                                color: Colors.lightBlue[800]!
                              )
                            )
                          ),
                          onPressed: (){}, 
                          child: Text('Boarding Point',
                          style: TextStyle(
                            color: Colors.lightBlue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          )
                          ),
                      ),
                    ],
                  ),
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                            backgroundColor: Colors.lightBlue[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 1,
                                color: Colors.lightBlue[800]!
                              )
                            )
                          ),
                          onPressed: (){}, 
                          child: Text('Dropping Point',
                          style: TextStyle(
                            color: Colors.lightBlue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          )
                          ),
                      ),
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(2),
                            backgroundColor: Colors.lightBlue[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 1,
                                color: Colors.lightBlue[800]!
                              )
                            )
                          ),
                          onPressed: (){}, 
                          child: Text('Amenities',
                          style: TextStyle(
                            color: Colors.lightBlue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          )
                          ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          );
          });
  }
}
