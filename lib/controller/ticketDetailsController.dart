import 'package:eticket_atc/controller/authController.dart';
import 'package:eticket_atc/controller/busDetailsController.dart';
import 'package:eticket_atc/controller/seatController.dart';
import 'package:get/get.dart';

class TicketDetailsController extends GetxController {
  // Observable ticket data
  var ticketData = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTicketData();
  }

  Future<void> loadTicketData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Get user data from AuthController
      loadUserData();

      // Get bus details
      loadBusDetails();

      // Get seat details
      loadSeatDetails();

      // Add date information if not present
      addDefaultDateInfo();
    } catch (e) {
      errorMessage.value = 'Error loading ticket data: $e';
      print('Error loading ticket data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load user data from AuthController
 // In ticketDetailsController.dart - Update loadUserData method
  void loadUserData() {
    try {
      final AuthController authController = Get.find<AuthController>();
      if (!authController.isAuthenticated.value) {
        authController.checkAuthStatus();
      }

      final Map<String, dynamic> userData = authController.userData.value ?? {};
      if (userData.isNotEmpty) {
        // Create a copy of the current data
        final Map<String, dynamic> updatedData =
            Map<String, dynamic>.from(ticketData);

        // Only update passenger name if it's not already set (for "myself" scenario)
        if (!updatedData.containsKey("passengerName") ||
            updatedData["passengerName"].toString().isEmpty) {
          updatedData["passengerName"] = userData["name"] ?? "";
        }

        // Always update phone if available from auth
        updatedData["phone"] =
            userData["contactNumber"] ?? updatedData["phone"] ?? "";

        // Update the ticketData
        ticketData(updatedData);
      }
    } catch (e) {
      print('User data not available: $e');
    }
  }

  // Load bus details from BusDetailsController
  void loadBusDetails() {
    try {
      final BusDetailsController busController =
          Get.find<BusDetailsController>();

      // Update ticket data with bus info
      final Map<String, dynamic> updatedData =
          Map<String, dynamic>.from(ticketData);

      updatedData["fromCity"] = busController.selectedBoarding.value;
      updatedData["toCity"] = busController.selectedDropping.value;
      updatedData["boardingPoint"] = busController.selectedBoarding.value;
      updatedData["droppingPoint"] = busController.selectedDropping.value;
      updatedData["originalPrice"] = busController.ticketPrice.value.toString();
      updatedData["busName"] = busController.bus.busName;
      updatedData["busType"] = busController.bus.busType;
      updatedData["coachType"] = busController.bus.coachType;

      // Get schedule details if available
      if (busController.bus.busSchedule.isNotEmpty) {
        updatedData["departureTime"] =
            busController.bus.busSchedule[0].departTime;
        updatedData["arrivalTime"] =
            busController.bus.busSchedule[0].arrivalTime;
      }

      ticketData(updatedData);
    } catch (e) {
      print('Bus details not available: $e');
    }
  }

  // Load seat details from SeatController
  void loadSeatDetails() {
    try {
      final SeatController seatController = Get.find<SeatController>();

      if (seatController.localSelectedSeats.isNotEmpty) {
        final List<String> selectedSeatLabels = seatController
            .localSelectedSeats
            .map((index) => seatController.seatLabels[index])
            .toList();

        final Map<String, dynamic> updatedData =
            Map<String, dynamic>.from(ticketData);
        updatedData["seatNumbers"] = selectedSeatLabels;
        ticketData(updatedData);
      }
    } catch (e) {
      print('Seat details not available: $e');
    }
  }

  // Add default date information if not present
  void addDefaultDateInfo() {
    final now = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final Map<String, dynamic> updatedData =
        Map<String, dynamic>.from(ticketData);

    updatedData["issueDate"] =
        updatedData["issueDate"] ?? "${now.day}/${now.month}/${now.year}";
    updatedData["journeyDate"] = updatedData["journeyDate"] ??
        "${tomorrow.day}/${tomorrow.month}/${tomorrow.year}";

    ticketData(updatedData);
  }

  // Method to initialize with data from navigation
 // In ticketDetailsController.dart - Modify initializeWithData method
  void initializeWithData(Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      final Map<String, dynamic> updatedData =
          Map<String, dynamic>.from(ticketData);
      updatedData.addAll(data);

      // Ensure seat numbers are properly saved
      if (data.containsKey("bookedSeats")) {
        updatedData["seatNumbers"] = data["bookedSeats"];
      }

      // Ensure passenger name is properly saved
      if (data.containsKey("passengerName") &&
          data["passengerName"].toString().isNotEmpty) {
        updatedData["passengerName"] = data["passengerName"];
      }

      ticketData(updatedData);
    }
  }

  // Method to update specific ticket field
  void updateTicketField(String key, dynamic value) {
    final Map<String, dynamic> updatedData =
        Map<String, dynamic>.from(ticketData);
    updatedData[key] = value;
    ticketData(updatedData);
  }

  // Method to update multiple ticket fields at once
  void updateTicketFields(Map<String, dynamic> fields) {
    final Map<String, dynamic> updatedData =
        Map<String, dynamic>.from(ticketData);
    fields.forEach((key, value) {
      updatedData[key] = value;
    });
    ticketData(updatedData);
  }

  // Refreshes all data
  Future<void> refreshTicketData() async {
    isLoading.value = true;

    try {
      loadUserData();
      loadBusDetails();
      loadSeatDetails();
      addDefaultDateInfo();
    } catch (e) {
      print('Error refreshing ticket data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to safely get string values with fallback
  String getStringValue(String key, {String defaultValue = ""}) {
    return ticketData[key]?.toString() ?? defaultValue;
  }

  // Helper method to safely get list values
  List<dynamic> getListValue(String key) {
    final value = ticketData[key];
    if (value is List) {
      return value;
    }
    return [];
  }
}
