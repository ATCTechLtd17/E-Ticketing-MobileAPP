import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eticket_atc/controller/authController.dart';

class InsightController extends GetxController {
  final Rx<bool> isLoading = true.obs;
  final Rx<String> errorMessage = ''.obs;
  final Rx<int> flightPurchase = 0.obs;
  final Rx<int> busPurchase = 0.obs;
  final Rx<int> totalTickets = 0.obs;
  final Rx<int> destinations = 0.obs;
  final RxList<Map<String, dynamic>> journeyData = <Map<String, dynamic>>[].obs;
  final RxMap<String, double> destinationData = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInsights();
  }

  Future<void> fetchInsights() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get auth token
      final authController = Get.find<AuthController>();
      final token = authController.token.value;

      if (token.isEmpty) {
        errorMessage.value = 'Authentication required';
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://e-ticketing-server.vercel.app/api/v1/passenger/ticket-calculated'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':  token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          
          final calculatedData = data['data'];
          busPurchase.value = calculatedData['calculatedTicket'] ?? 0;
          totalTickets.value = calculatedData['totalTicketCount'] ?? 0;

        
          flightPurchase.value =
              60; 
          destinations.value = 2;

          journeyData.value = calculatedData['formattedData']
                  ?.map<Map<String, dynamic>>((item) => {
                        'month': 'Jan', 
                        'flights': item['flights'],
                        'spent': item['spent']
                      })
                  .toList() ??
              [];

          destinationData.value = {
            'Dhaka': 33.0,
            'Rajshahi': 67.0,
          };
        } else {
          errorMessage.value = data['message'] ?? 'Failed to load data';
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
