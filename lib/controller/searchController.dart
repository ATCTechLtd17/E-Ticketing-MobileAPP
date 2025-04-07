import 'dart:convert';
import 'package:eticket_atc/controller/BusController/busFilterController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BusSearchController extends GetxController {
  final String apiUrl =
      'https://e-ticketing-server.vercel.app/api/v1/bus-stops';

  var suggestions = <String>[].obs;
  var filteredSuggestions = <String>[].obs;

  var from = ''.obs;
  var to = ''.obs;

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  final GlobalKey fromFieldKey = GlobalKey();
  final GlobalKey toFieldKey = GlobalKey();

  OverlayEntry? overlayEntry;

  var departureTime = Rxn<DateTime>();
  var returnTime = Rxn<DateTime>();

  final BusFilterController busFilterController = Get.put(BusFilterController());

  var isReturn = false.obs;
  var isFrom = false.obs;
  var isTo = false.obs;
  var isSelecting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSuggestions();
  }


  Future<void> loadSuggestions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> dataSet =
              List<dynamic>.from(responseData['data']);

          suggestions.value = dataSet.map((stops) {
            return stops['busStoppageLocation'].toString();
          }).toList();
        } else {
          print(
              "Error: API response does not contain 'data' key or is not a list.");
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error Fetching Suggestions: $e");
      Get.snackbar('Error', 'Failed to load bus stops: $e');
    }
  }


  void checkSuggestions(String query, {required String field}) {
    if (field == 'from') {
      from.value = query;
    } else {
      to.value = query;
    }

    if (query.isEmpty) {
      filteredSuggestions.clear();
      
    } else {
      filteredSuggestions.value = suggestions
          .where((location) =>
              location.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
    }
  }

  void selectDepartureDate(DateTime? date) {
    if (date != null) departureTime.value = date;
  }

  void selectReturnDate(DateTime? date) {
    if (date != null) returnTime.value = date;
  }

  void toggleReturnTrip(bool value) {
    isReturn.value = value;
  }

  
  void toggleFocus(bool ifrom) {
    if (ifrom) {
      isFrom.value = true;
      isTo.value = false;
      checkSuggestions(fromController.text, field: 'from');
    } else {
      isFrom.value = false;
      isTo.value = true;
      checkSuggestions(toController.text, field: 'to');
    }
  }

  void clearFocus() {
    isFrom.value = false;
    isTo.value = false;
    filteredSuggestions.clear();
    
  }


  void selectSuggestion(String suggestion, {required String field}) {
    isSelecting.value = true;

    if (field == 'from') {
      fromController.text = suggestion;
      from.value = suggestion;
      print(suggestion);
    } else if (field == 'to') {
      toController.text = suggestion;
      to.value = suggestion;
      print(suggestion);
    }

    Future.delayed(Duration(milliseconds: 100), () {
      isSelecting.value = false;
      clearFocus();
    });
  }

  void searchBuses(){
    if(from.isNotEmpty && to.isNotEmpty && departureTime.value != null){
      String formattedDate = departureTime.value != null
          ? DateFormat('yyyy-MM-dd').format(departureTime.value!)
          : 'N/A'; 

      busFilterController.searchBuses(from.value, to.value, formattedDate);
      print(formattedDate);
      print(from.value);
      print( to.value);

    } else{
      print('error in bus search');
    }
  }
}
