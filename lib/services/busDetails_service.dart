import 'package:eticket_atc/controller/BusController/busDetailsController.dart';
import 'package:get/get.dart';

class BusDetailsService {
  // Load bus details with robust error handling
  static Future<Map<String, dynamic>> loadBusDetails(
      {Map<String, dynamic> currentTicketData = const {},
      bool forceFetch = false}) async {
    final Map<String, dynamic> updatedData =
        Map<String, dynamic>.from(currentTicketData);

    try {
      // Check if BusDetailsController is registered
      if (!Get.isRegistered<BusDetailsController>()) {
        print(
            'BusDetailsController not registered, attempting to retrieve default values from bus...');

        // If we have bus data from previous initialization, try to use that
        if (currentTicketData.containsKey("busId")) {
          // Logic to handle fallback if necessary
          print(
              'Using existing bus data with ID: ${currentTicketData["busId"]}');
        }
        return currentTicketData;
      }

      final BusDetailsController busDetailsController =
          Get.find<BusDetailsController>();

      // Force the controller to update ticket price if needed
      if (forceFetch) {
        busDetailsController.updateTicketPrice();
      }

      // Make sure boarding and dropping points are not empty
      // If they are, use the default values from bus schedule
      String boardingPoint = busDetailsController.selectedBoarding.value;
      String droppingPoint = busDetailsController.selectedDropping.value;

      // If boarding point is empty, use the start point from the first schedule
      if (boardingPoint.isEmpty &&
          busDetailsController.bus.busSchedule.isNotEmpty) {
        boardingPoint = busDetailsController.bus.busSchedule[0].startPoint;
        // Update the controller's value
        busDetailsController.setSelectedBoarding(boardingPoint);
        print('Setting default boarding point to: $boardingPoint');
      }

      // If dropping point is empty, use the end point from the first schedule
      if (droppingPoint.isEmpty &&
          busDetailsController.bus.busSchedule.isNotEmpty) {
        droppingPoint = busDetailsController.bus.busSchedule[0].endPoint;
        // Update the controller's value
        busDetailsController.setSelectedDropping(droppingPoint);
        print('Setting default dropping point to: $droppingPoint');
      }

      print('Bus controller data: boarding=$boardingPoint, '
          'dropping=$droppingPoint, '
          'price=${busDetailsController.ticketPrice.value}');

      // Set all location fields consistently
      updatedData["fromCity"] = boardingPoint;
      updatedData["boardingPoint"] = boardingPoint;
      updatedData["toCity"] = droppingPoint;
      updatedData["droppingPoint"] = droppingPoint;
      updatedData["originalPrice"] =
          busDetailsController.ticketPrice.value.toString();

      // Bus details
      updatedData["busName"] = busDetailsController.bus.busName;
      updatedData["busType"] = busDetailsController.bus.busType;
      updatedData["coachType"] = busDetailsController.bus.coachType;
      updatedData["busId"] = busDetailsController.bus.id;

      if (busDetailsController.bus.busSchedule.isNotEmpty) {
        updatedData["departureTime"] =
            busDetailsController.bus.busSchedule[0].departTime;
        updatedData["arrivalTime"] =
            busDetailsController.bus.busSchedule[0].arrivalTime;
      }

      // Debug the values
      print('Updating ticket data with bus info:');
      print('fromCity: ${updatedData["fromCity"]}');
      print('toCity: ${updatedData["toCity"]}');
      print('boardingPoint: ${updatedData["boardingPoint"]}');
      print('droppingPoint: ${updatedData["droppingPoint"]}');
      print('originalPrice: ${updatedData["originalPrice"]}');

      return updatedData;
    } catch (e) {
      print('Error loading bus details: $e');

      // Add fallback mechanism - try to set defaults from other sources
      // If we have bus data but not the boarding/dropping points, try to extract from elsewhere
      if (updatedData.containsKey("busId") &&
          (!updatedData.containsKey("boardingPoint") ||
              updatedData["boardingPoint"].toString().isEmpty)) {
        print('Attempting to recover missing boarding/dropping points...');

        // Check various ways the data might exist in the ticket data
        if (updatedData.containsKey("fromCity") &&
            updatedData["fromCity"].toString().isNotEmpty) {
          updatedData["boardingPoint"] = updatedData["fromCity"];
          print(
              'Recovered boarding point from fromCity: ${updatedData["fromCity"]}');
        }

        if (updatedData.containsKey("toCity") &&
            updatedData["toCity"].toString().isNotEmpty) {
          updatedData["droppingPoint"] = updatedData["toCity"];
          print(
              'Recovered dropping point from toCity: ${updatedData["toCity"]}');
        }
      }

      return ensureBusDataConsistency(updatedData);
     
      
    }
    
  }

  // Helper method to validate and fix bus data consistency
  static Map<String, dynamic> ensureBusDataConsistency(
      Map<String, dynamic> data) {
    final Map<String, dynamic> updatedData = Map<String, dynamic>.from(data);

    // Ensure from/boarding and to/dropping are consistent
    if (updatedData.containsKey("fromCity") &&
        updatedData["fromCity"] != null &&
        updatedData["fromCity"].toString().isNotEmpty) {
      if (!updatedData.containsKey("boardingPoint") ||
          updatedData["boardingPoint"] == null ||
          updatedData["boardingPoint"].toString().isEmpty) {
        updatedData["boardingPoint"] = updatedData["fromCity"];
      }
    } else if (updatedData.containsKey("boardingPoint") &&
        updatedData["boardingPoint"] != null &&
        updatedData["boardingPoint"].toString().isNotEmpty) {
      updatedData["fromCity"] = updatedData["boardingPoint"];
    }

    if (updatedData.containsKey("toCity") &&
        updatedData["toCity"] != null &&
        updatedData["toCity"].toString().isNotEmpty) {
      if (!updatedData.containsKey("droppingPoint") ||
          updatedData["droppingPoint"] == null ||
          updatedData["droppingPoint"].toString().isEmpty) {
        updatedData["droppingPoint"] = updatedData["toCity"];
      }
    } else if (updatedData.containsKey("droppingPoint") &&
        updatedData["droppingPoint"] != null &&
        updatedData["droppingPoint"].toString().isNotEmpty) {
      updatedData["toCity"] = updatedData["droppingPoint"];
    }

    return updatedData;
  }
}
