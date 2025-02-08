import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/widgets/microwidgets/form/dtaePick.dart';
import 'package:eticket_atc/widgets/microwidgets/form/suggestionList.dart';
import 'package:eticket_atc/widgets/microwidgets/overlayContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class FormFields extends StatelessWidget {
  FormFields({super.key});

  final BusSearchController busSearchController =
      Get.put(BusSearchController());

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
         
          FocusScope.of(context).unfocus();
          busSearchController.clearFocus();
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  
                  Flexible(
                    flex: 1,
                    child: OverlayContainer(
                      showOnFocus: true,
                      showOnTap: true,
                      overlayContent: Obx(() {
                        bool hasSuggestions =
                            busSearchController.filteredSuggestions.isNotEmpty;
                        return hasSuggestions
                            ? SuggestionList(field: 'from')
                            : Container();
                      }),
                      child: TextField(
                        cursorColor: Colors.lightBlue,
                        controller: busSearchController.fromController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 15),
                          labelText: 'From',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                        ),
                        onChanged: (value) {
                          busSearchController.checkSuggestions(value,
                              field: 'from');
                        },
                        onTap: () {
                          busSearchController.toggleFocus(true);
                        },
                      ),
                      
                    ),
                  ),
                  const SizedBox(width: 20),
                 
                  Flexible(
                    flex: 1,
                    child: OverlayContainer(
                      showOnFocus: true,
                      showOnTap: true,
                      
                      overlayContent: Obx(() {
                        bool hasSuggestions =
                            busSearchController.filteredSuggestions.isNotEmpty;
                        return hasSuggestions
                            ? SuggestionList(field: 'to')
                            : Container();
                      }),
                      child: TextField(
                        cursorColor: Colors.lightBlue,
                        controller: busSearchController.toController,
                        decoration: InputDecoration(
                          labelText: 'To',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                        ),
                        onChanged: (value) {
                          busSearchController.checkSuggestions(value,
                              field: 'to');
                        },
                        onTap: () {
                          busSearchController.toggleFocus(false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Flexible(flex: 1, child: DatePick(isJourneyDate: true)),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: Obx(() {
                      return Opacity(
                        opacity: busSearchController.isReturn.value ? 1.0 : 0.5,
                        child: IgnorePointer(
                          ignoring: !busSearchController.isReturn.value,
                          child: DatePick(isJourneyDate: false),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
          
        );
      
    
  }
}
