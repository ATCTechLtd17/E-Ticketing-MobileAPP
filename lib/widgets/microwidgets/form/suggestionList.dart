import 'package:eticket_atc/controller/searchController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestionList extends StatelessWidget {
  final String field;
  SuggestionList({required this.field, super.key});

  final BusSearchController busSearchController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        color: Colors.lightBlue[100]
      ),
      child: Obx(() {
        final suggestions = busSearchController.filteredSuggestions;
      
        if (suggestions.isEmpty) return const SizedBox.shrink();
      
        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  busSearchController.isSelecting.value = true;
                  busSearchController.selectSuggestion(suggestion, field: field);
                },
              );
            },
          ),
        );
      }),
    );
  }
}


    