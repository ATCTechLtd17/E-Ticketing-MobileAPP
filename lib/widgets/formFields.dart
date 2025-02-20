import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/widgets/microwidgets/SearchForm/dtaePick.dart';
import 'package:eticket_atc/widgets/microwidgets/SearchForm/suggestionList.dart';
import 'package:eticket_atc/widgets/microwidgets/overlayContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class FormFields extends StatelessWidget {
  FormFields({super.key});

  final BusSearchController busSearchController =
      Get.put(BusSearchController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        busSearchController.clearFocus();
      },
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              child:
                  Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: OverlayContainer(
                          showOnFocus: true,
                          showOnTap: true,
                          overlayContent: Obx(() {
                            bool hasSuggestions = busSearchController
                                .filteredSuggestions.isNotEmpty;
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
                      SizedBox(width: 50), // Space for the swap button
                      Flexible(
                        flex: 1,
                        child: OverlayContainer(
                          showOnFocus: true,
                          showOnTap: true,
                          overlayContent: Obx(() {
                            bool hasSuggestions = busSearchController
                                .filteredSuggestions.isNotEmpty;
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

                  
                  Positioned(
                    child: Transform.rotate(
                      angle: math.pi / 2, 
                      child: IconButton(
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.lightBlue[100],
                          padding: EdgeInsets.all(3),
                        ),
                        onPressed: () {
                          String fromText =
                              busSearchController.fromController.text;
                          String toText = busSearchController.toController.text;
                          busSearchController.fromController.text = toText;
                          busSearchController.toController.text = fromText;
                          busSearchController.from.value = toText;
                          busSearchController.to.value = fromText;
                        },
                        icon: Icon(
                          Icons.swap_calls_outlined,
                          size: 30,
                          color: Colors.lightBlue[800],
                        ),
                      ),
                    ),
                  ),
                ],
              )

              ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
  children: [
    // Journey Date Picker
    Flexible(
      flex: 1,
      child: Obx(() => DatePick(
            label: 'Journey Date',
            selectedDate: busSearchController.departureTime.value,
            onDateSelected: (date) {
              busSearchController.selectDepartureDate(date);
            },
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 90)),
          )),
    ),
    const SizedBox(width: 20),
    // Return Date Picker (with opacity/ignore logic)
    Flexible(
      flex: 1,
      child: Obx(() {
        return Opacity(
          opacity: busSearchController.isReturn.value ? 1.0 : 0.5,
          child: IgnorePointer(
            ignoring: !busSearchController.isReturn.value,
            child: DatePick(
              label: 'Return Date',
              selectedDate: busSearchController.returnTime.value,
              onDateSelected: (date) {
                busSearchController.selectReturnDate(date);
              },
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
            ),
          ),
        );
      }),
    ),
  ],
),

            /*Row(
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
            ),*/
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
