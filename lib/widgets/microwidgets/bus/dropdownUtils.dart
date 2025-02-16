import 'package:eticket_atc/models/bus_model.dart';
import 'package:eticket_atc/widgets/microwidgets/overlayContainer.dart';
import 'package:flutter/material.dart';

Widget getBoardingPointSelector({
  required Bus bus,
  required String selectedValue,
  required Function(String) onSelected,
}) {
  return OverlayContainer(
    showOnFocus: true,
    showOnTap: true,
      overlayContent: _buildDropdownList(
      options: [
        bus.busSchedule[0].startPoint,
        ...bus.busBoardingPoint.map((boarding) => boarding.boardingLocation),
        ...bus.busRoute.map((route) => route.stoppageLocation),
      ],
      onSelected: onSelected,
    
      ), 
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: "Select Boarding Point",
        border: OutlineInputBorder(),
      ),
      child:
          Text(selectedValue.isEmpty ? 'Select Boarding Point' : selectedValue),
    ),
  );
}

Widget getDroppingPointSelector({
  required Bus bus,
  required String selectedValue,
  required Function(String) onSelected,
}) {
  return OverlayContainer(
    showOnFocus: true,
    showOnTap: true,
    overlayContent: _buildDropdownList(
      options: [
        bus.busSchedule[0].endPoint,
        ...bus.busDroppingPoint.map((drop) => drop.counterName),
        ...bus.busRoute.map((route) => route.stoppageLocation),
      ],
      onSelected: onSelected, 
    ),
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: "Select Dropping Point",
        border: OutlineInputBorder(),
      ),
      child:
          Text(selectedValue.isEmpty ? 'Select Dropping Point' : selectedValue),
    ),
  );
}

Widget _buildDropdownList({
  required List<String> options,
  required Function(String) onSelected,
  
}) {
  return Material(
    elevation: 8,
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.zero, 
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(options[index]),
            onTap: () {
              onSelected(options[index]); 
              
            },
          );
        },
      ),
    ),
  );
}
