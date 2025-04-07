import 'dart:convert';

import 'package:eticket_atc/models/bus_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BusFilterController extends GetxController{
  final String baseUrl = 'https://e-ticketing-server.vercel.app/api/v1/bus-details/get-bus-search';
  var filteredBuses = <Bus>[].obs;
  var isLoading = false.obs;

  Future<void> searchBuses(String from, String to, String date) async{
    isLoading.value = true;
    final String endUrl = '$baseUrl?startPoint=$from&endPoint=$to&departureDate=$date';

    try{
      final res = await http.get(Uri.parse(endUrl));
      print(endUrl);

      if(res.statusCode == 200){
        final List<dynamic> data = jsonDecode(res.body)['data'];
        filteredBuses.value = data.map((bus)=> Bus.fromJson(bus)).toList();
        print(data);
        
      } else {
        filteredBuses.clear();
        print('Error: ${res.body}');
      }
    }
    catch (e){
      print('Fetching error: $e');
      filteredBuses.clear();
    }
    finally {
      isLoading.value = false;
    }
  }
}