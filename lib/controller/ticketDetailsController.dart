import 'dart:convert';
import 'package:eticket_atc/controller/authController.dart';
import 'package:eticket_atc/controller/busDetailsController.dart';
import 'package:eticket_atc/controller/profileController.dart';
import 'package:eticket_atc/controller/seatController.dart';
import 'package:eticket_atc/models/passenger_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TicketDetailsController extends GetxController {
  // Observable ticket data
  var ticketData = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var isBooking = false.obs;
  var bookingSuccess = false.obs;
  var bookingError = ''.obs;
  var bookedTicketInfo = Rxn<PassengerInfo>();

  @override
  void onInit() {
    super.onInit();
    loadTicketData();
  }

  Future<void> loadTicketData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // First attempt to load data from other controllers
      await loadUserData();
      await loadBusDetails();
      await loadSeatDetails();
      addDefaultDateInfo();

      // Debug logging
      print('Loaded ticket data: ${ticketData.toString()}');

      // Verify key fields are present
      final keysToCheck = [
        'fromCity',
        'toCity',
        'boardingPoint',
        'droppingPoint',
        'passengerName',
        'originalPrice',
        'phone'
      ];
      final missingKeys = keysToCheck
          .where((key) =>
              ticketData[key] == null || ticketData[key].toString().isEmpty)
          .toList();

      if (missingKeys.isNotEmpty) {
        print('Warning: Missing keys in ticket data: $missingKeys');
        // Try to fix missing data by calling loadBusDetails again
        if (missingKeys.contains('fromCity') ||
            missingKeys.contains('toCity') ||
            missingKeys.contains('boardingPoint') ||
            missingKeys.contains('droppingPoint') ||
            missingKeys.contains('originalPrice')) {
          await loadBusDetails(forceFetch: true);
        }
      }
    } catch (e) {
      errorMessage.value = 'Error loading ticket data: $e';
      print('Error loading ticket data: $e');
    } finally {
      isLoading.value = false;
    }

    // Ensure we have data for all fields
    ensureRequiredFields();
  }

  // Ensures all required fields have at least an empty string
  void ensureRequiredFields() {
    final requiredFields = [
      'passengerName',
      'phone',
      'email',
      'gender',
      'fromCity',
      'toCity',
      'boardingPoint',
      'droppingPoint',
      'originalPrice',
      'issueDate',
      'journeyDate',
      'departureTime',
      'arrivalTime',
      'busName',
      'busType',
      'coachType'
    ];

    final Map<String, dynamic> updatedData =
        Map<String, dynamic>.from(ticketData);
    for (final field in requiredFields) {
      if (!updatedData.containsKey(field) || updatedData[field] == null) {
        updatedData[field] = "";
      }
    }

    if (!updatedData.containsKey("seatNumbers") ||
        updatedData["seatNumbers"] == null) {
      updatedData["seatNumbers"] = [];
    }

    ticketData(updatedData);
  }

  // Load user data with enhanced profile loading
  Future<void> loadUserData() async {
    try {
      final AuthController authController = Get.find<AuthController>();
      if (!authController.isAuthenticated.value) {
        await authController.checkAuthStatus();
      }

      // Check if user is authenticated before proceeding
      if (authController.isAuthenticated.value) {
        // First try to get basic user data from auth controller
        final Map<String, dynamic> userData =
            authController.userData.value ?? {};

        // Then try to get more detailed profile data
        try {
          // Get or create ProfileController instance
          ProfileController profileController;
          if (!Get.isRegistered<ProfileController>()) {
            profileController = Get.put(ProfileController());
          } else {
            profileController = Get.find<ProfileController>();
          }

          // If profile is not yet loaded, load it
          if (profileController.user.value == null) {
            await profileController.loadUserProfile();
          }

          // Wait a moment for the profile to load if needed
          if (profileController.isLoading.value) {
            await Future.delayed(Duration(milliseconds: 500));
          }

          // Use the detailed user profile if available
          if (profileController.user.value != null) {
            final userModel = profileController.user.value!;

            // Create updated data with all user information
            final Map<String, dynamic> updatedData =
                Map<String, dynamic>.from(ticketData);

            // Set passenger info with priority from profile
            // Fix: Use correct field names from UserModel
            updatedData["passengerName"] = userModel.fullName;
            updatedData["phone"] = userModel.contactNumber;
            updatedData["email"] = userModel.email;
            updatedData["gender"] = userModel.gender;

            // Add any additional fields from the profile that might be useful
            // Fix: Use correct field names from UserModel
            updatedData["address"] = userModel.presentAddress ?? "";

            // Fix: UserModel doesn't have age, using dateOfBirth instead
            updatedData["dateOfBirth"] = userModel.dateOfBirth;

            // Fix: UserModel has nidCardNumber, not nationalId
            updatedData["nationalId"] = userModel.nidCardNumber ?? "";

            // Update the ticket data
            ticketData(updatedData);
            print('Loaded detailed user profile data');
            return;
          }
        } catch (e) {
          print('Error loading profile data: $e');
          // Continue with basic auth data if profile fetch fails
        }

        // Fallback to basic user info if profile isn't available
        final Map<String, dynamic> updatedData =
            Map<String, dynamic>.from(ticketData);

        // Only set passenger name if not already set or empty
        if (!updatedData.containsKey("passengerName") ||
            updatedData["passengerName"] == null ||
            updatedData["passengerName"].toString().isEmpty) {
          updatedData["passengerName"] = userData["name"] ?? "";
        }

        // Update phone if available
        if (!updatedData.containsKey("phone") ||
            updatedData["phone"] == null ||
            updatedData["phone"].toString().isEmpty) {
          updatedData["phone"] = userData["contactNumber"] ?? "";
        }

        // Add email if available
        updatedData["email"] = userData["email"] ?? updatedData["email"] ?? "";

        // Add gender if available
        updatedData["gender"] =
            userData["gender"] ?? updatedData["gender"] ?? "";

        ticketData(updatedData);
        print('Loaded basic user data: ${userData["name"]}');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Load bus details with more robust handling
  Future<void> loadBusDetails({bool forceFetch = false}) async {
    try {
      // Check if BusDetailsController is registered
      if (!Get.isRegistered<BusDetailsController>()) {
        print('BusDetailsController not registered');
        return;
      }

      final BusDetailsController busController =
          Get.find<BusDetailsController>();

      print(
          'Bus controller data: boarding=${busController.selectedBoarding.value}, '
          'dropping=${busController.selectedDropping.value}, '
          'price=${busController.ticketPrice.value}');

      final Map<String, dynamic> updatedData =
          Map<String, dynamic>.from(ticketData);

      // Fix: Force the ticket price to be updated
      if (forceFetch) {
        busController.updateTicketPrice();
      }

      // Always update these fields to ensure they're set
      updatedData["fromCity"] = busController.selectedBoarding.value;
      updatedData["boardingPoint"] = busController.selectedBoarding.value;
      updatedData["toCity"] = busController.selectedDropping.value;
      updatedData["droppingPoint"] = busController.selectedDropping.value;
      updatedData["originalPrice"] = busController.ticketPrice.value.toString();

      // Bus details
      updatedData["busName"] = busController.bus.busName;
      updatedData["busType"] = busController.bus.busType;
      updatedData["coachType"] = busController.bus.coachType;
      updatedData["busId"] = busController.bus.id;

      if (busController.bus.busSchedule.isNotEmpty) {
        updatedData["departureTime"] =
            busController.bus.busSchedule[0].departTime;
        updatedData["arrivalTime"] =
            busController.bus.busSchedule[0].arrivalTime;
      }

      // Add totalPrice based on seat count and ticket price
      if (updatedData.containsKey("seatNumbers") &&
          updatedData["seatNumbers"] is List &&
          busController.ticketPrice.value > 0) {
        final int seatCount = (updatedData["seatNumbers"] as List).length;
        updatedData["totalPrice"] =
            (seatCount * busController.ticketPrice.value).toString();
      }

      // Debug the values
      print('Updating ticket data with bus info:');
      print('fromCity: ${updatedData["fromCity"]}');
      print('toCity: ${updatedData["toCity"]}');
      print('boardingPoint: ${updatedData["boardingPoint"]}');
      print('droppingPoint: ${updatedData["droppingPoint"]}');
      print('originalPrice: ${updatedData["originalPrice"]}');

      ticketData(updatedData);
    } catch (e) {
      print('Error loading bus details: $e');
    }
  }

  // Load seat details with improved error handling
  Future<void> loadSeatDetails() async {
    try {
      // Check if SeatController is registered
      if (!Get.isRegistered<SeatController>()) {
        print('SeatController not registered');
        return;
      }

      final SeatController seatController = Get.find<SeatController>();

      print(
          'Seat controller data: selected seats=${seatController.localSelectedSeats}');

      if (seatController.localSelectedSeats.isNotEmpty &&
          seatController.seatLabels.isNotEmpty) {
        final List<String> selectedSeatLabels = seatController
            .localSelectedSeats
            .map((index) => seatController.seatLabels[index])
            .toList();

        final Map<String, dynamic> updatedData =
            Map<String, dynamic>.from(ticketData);
        updatedData["seatNumbers"] = selectedSeatLabels;

        // Update total price based on seat count and ticket price
        if (updatedData.containsKey("originalPrice") &&
            updatedData["originalPrice"].toString().isNotEmpty) {
          final double price =
              double.tryParse(updatedData["originalPrice"].toString()) ?? 0.0;
          if (price > 0) {
            updatedData["totalPrice"] =
                (selectedSeatLabels.length * price).toString();
          }
        }

        ticketData(updatedData);
      }
    } catch (e) {
      print('Error loading seat details: $e');
    }
  }

  void addDefaultDateInfo() {
    final now = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final Map<String, dynamic> updatedData =
        Map<String, dynamic>.from(ticketData);

    updatedData["issueDate"] =
        updatedData["issueDate"] ?? "${now.day}/${now.month}/${now.year}";
    updatedData["journeyDate"] = updatedData["journeyDate"] ??
        "${tomorrow.day}/${tomorrow.month}/${tomorrow.year}";

    // Add formatted dates for API
    final String formattedJourneyDate =
        _formatDateForApi(updatedData["journeyDate"]);
    updatedData["depertureDate"] = formattedJourneyDate;
    updatedData["arrivalDate"] = formattedJourneyDate;

    ticketData(updatedData);
  }

  // Helper to convert DD/MM/YYYY to YYYY-MM-DD
  String _formatDateForApi(String dateStr) {
    if (dateStr.isEmpty) {
      return DateTime.now()
          .add(const Duration(days: 1))
          .toString()
          .split(' ')[0];
    }

    try {
      final parts = dateStr.split('/');
      if (parts.length != 3) {
        return DateTime.now()
            .add(const Duration(days: 1))
            .toString()
            .split(' ')[0];
      }

      return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
    } catch (e) {
      return DateTime.now()
          .add(const Duration(days: 1))
          .toString()
          .split(' ')[0];
    }
  }

  void initializeWithData(Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      final Map<String, dynamic> updatedData =
          Map<String, dynamic>.from(ticketData);
      updatedData.addAll(data);

      if (data.containsKey("bookedSeats")) {
        updatedData["seatNumbers"] = data["bookedSeats"];
      }

      if (data.containsKey("passengerName") &&
          data["passengerName"] != null &&
          data["passengerName"].toString().isNotEmpty) {
        updatedData["passengerName"] = data["passengerName"];
      }

      // Fix: Check for boarding/dropping points and price
      if (data.containsKey("boardingPoint") && data["boardingPoint"] != null) {
        updatedData["fromCity"] = data["boardingPoint"];
      }

      if (data.containsKey("droppingPoint") && data["droppingPoint"] != null) {
        updatedData["toCity"] = data["droppingPoint"];
      }

      if (data.containsKey("ticketPrice") && data["ticketPrice"] != null) {
        updatedData["originalPrice"] = data["ticketPrice"].toString();

        // Update total price if we have seat data
        if (updatedData.containsKey("seatNumbers") &&
            updatedData["seatNumbers"] is List &&
            (updatedData["seatNumbers"] as List).isNotEmpty) {
          final int seatCount = (updatedData["seatNumbers"] as List).length;
          final double price =
              double.tryParse(data["ticketPrice"].toString()) ?? 0.0;
          if (price > 0) {
            updatedData["totalPrice"] = (seatCount * price).toString();
          }
        }
      }

      ticketData(updatedData);
      print('Initialized ticket data: $updatedData');
    }
  }

  void updateTicketField(String key, dynamic value) {
    final Map<String, dynamic> updatedData =
        Map<String, dynamic>.from(ticketData);
    updatedData[key] = value;

    // Fix: Update related fields
    if (key == "boardingPoint") {
      updatedData["fromCity"] = value;
    } else if (key == "droppingPoint") {
      updatedData["toCity"] = value;
    } else if (key == "fromCity") {
      updatedData["boardingPoint"] = value;
    } else if (key == "toCity") {
      updatedData["droppingPoint"] = value;
    } else if (key == "ticketPrice") {
      updatedData["originalPrice"] = value.toString();

      // Update total price if we have seat data
      if (updatedData.containsKey("seatNumbers") &&
          updatedData["seatNumbers"] is List &&
          (updatedData["seatNumbers"] as List).isNotEmpty) {
        final int seatCount = (updatedData["seatNumbers"] as List).length;
        final double price = double.tryParse(value.toString()) ?? 0.0;
        if (price > 0) {
          updatedData["totalPrice"] = (seatCount * price).toString();
        }
      }
    }

    ticketData(updatedData);
    print('Updated ticket field $key: $value');
  }

  void updateTicketFields(Map<String, dynamic> fields) {
    final Map<String, dynamic> updatedData =
        Map<String, dynamic>.from(ticketData);

    fields.forEach((key, value) {
      updatedData[key] = value;

      // Fix: Update related fields
      if (key == "boardingPoint") {
        updatedData["fromCity"] = value;
      } else if (key == "droppingPoint") {
        updatedData["toCity"] = value;
      } else if (key == "fromCity") {
        updatedData["boardingPoint"] = value;
      } else if (key == "toCity") {
        updatedData["droppingPoint"] = value;
      } else if (key == "ticketPrice") {
        updatedData["originalPrice"] = value.toString();
      }
    });

    // Update total price if ticketPrice is provided and we have seat data
    if ((fields.containsKey("ticketPrice") ||
            fields.containsKey("originalPrice")) &&
        updatedData.containsKey("seatNumbers") &&
        updatedData["seatNumbers"] is List) {
      final int seatCount = (updatedData["seatNumbers"] as List).length;
      final double price = double.tryParse(fields.containsKey("ticketPrice")
              ? fields["ticketPrice"].toString()
              : fields["originalPrice"].toString()) ??
          0.0;

      if (price > 0 && seatCount > 0) {
        updatedData["totalPrice"] = (seatCount * price).toString();
      }
    }

    ticketData(updatedData);
    print('Updated ticket fields: $fields');
  }

  // Add this method to fix the error in ticketTab.dart
  void setTicketData(Map<String, dynamic> data) {
    isLoading.value = true;
    // Reset the current ticket data and replace with new data
    ticketData.value = Map<String, dynamic>.from(data);

    // Fix: Ensure from/to and boarding/dropping are consistent
    if (data.containsKey("fromCity") && !data.containsKey("boardingPoint")) {
      ticketData["boardingPoint"] = data["fromCity"];
    } else if (data.containsKey("boardingPoint") &&
        !data.containsKey("fromCity")) {
      ticketData["fromCity"] = data["boardingPoint"];
    }

    if (data.containsKey("toCity") && !data.containsKey("droppingPoint")) {
      ticketData["droppingPoint"] = data["toCity"];
    } else if (data.containsKey("droppingPoint") &&
        !data.containsKey("toCity")) {
      ticketData["toCity"] = data["droppingPoint"];
    }

    print('Set complete ticket data: $data');
    isLoading.value = false;
  }

  Future<void> refreshTicketData() async {
    isLoading.value = true;

    try {
      await loadUserData();
      await loadBusDetails(forceFetch: true);
      await loadSeatDetails();
      addDefaultDateInfo();
      ensureRequiredFields();
    } catch (e) {
      print('Error refreshing ticket data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getStringValue(String key, {String defaultValue = ""}) {
    return ticketData[key]?.toString() ?? defaultValue;
  }

  List<dynamic> getListValue(String key) {
    final value = ticketData[key];
    if (value is List) {
      return value;
    }
    return [];
  }

  // Method to create passenger info and book ticket
  Future<bool> bookTicket() async {
    try {
      isBooking.value = true;
      bookingSuccess.value = false;
      bookingError.value = '';

      // Get auth token
      final authController = Get.find<AuthController>();
      final token = authController.token.value;

      if (token.isEmpty) {
        bookingError.value = 'Authentication required. Please login first.';
        return false;
      }

      // Create passenger info from ticket data
      final passengerInfo = PassengerInfo.fromTicketData(ticketData);

      // Generate random transaction ID if not present
      if (passengerInfo.transactionId.isEmpty) {
        final updatedData = Map<String, dynamic>.from(ticketData);
        final txnId =
            'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}';
        updatedData['transactionId'] = txnId;
        ticketData(updatedData);
      }

      // Send request to API
      final url = Uri.parse(
          'https://e-ticketing-server.vercel.app/api/v1/bus-ticket-book/create-passenger-info');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(passengerInfo.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final bookedInfo = PassengerInfo.fromJson(responseData['data']);
          bookedTicketInfo.value = bookedInfo;

          // Update ticket data with response data
          final updatedData = Map<String, dynamic>.from(ticketData);
          updatedData['ticketId'] = bookedInfo.id;
          ticketData(updatedData);

          bookingSuccess.value = true;
          return true;
        } else {
          bookingError.value =
              responseData['message'] ?? 'Failed to book ticket';
          return false;
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        bookingError.value = errorResponse['message'] ??
            'Failed to book ticket. Status: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      bookingError.value = 'Error booking ticket: $e';
      print('Error booking ticket: $e');
      return false;
    } finally {
      isBooking.value = false;
    }
  }
}
