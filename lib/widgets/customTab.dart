import 'package:eticket_atc/controller/customTabController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/widgets/microwidgets/profile/cancelTicketTab.dart';
import 'package:eticket_atc/widgets/microwidgets/profile/insightTab.dart';
import 'package:eticket_atc/widgets/microwidgets/profile/profileTab.dart';
import 'package:eticket_atc/widgets/microwidgets/profile/ticketTab.dart';
import 'package:eticket_atc/widgets/microwidgets/profile/totalbuyTab.dart';


class CustomTabBar extends StatelessWidget {
  CustomTabBar({super.key});

  final List<Map<String, dynamic>> _tabs = [
    {"label": "Profile", "widget": ProfileTab()},
    {"label": "Insights", "widget": InsightTab()},
    // {"label": "Tickets", "widget": TicketTab()},
    {"label": "Total Buy", "widget": TotalBuyTab()},
    {"label": "Cancel Request", "widget": CancelTicketTab()},
  ];

  @override
  Widget build(BuildContext context) {
    // Create or retrieve the controller instance
    final CustomTabController tabController = Get.put(CustomTabController());

    return Column(
      children: [
        _buildTabBar(tabController),
        Obx(
          () => IndexedStack(
            index: tabController.selectedIndex.value,
            children: _tabs.map((tab) => tab["widget"] as Widget).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(CustomTabController tabController) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
      
          return Obx(() {
            bool isSelected = tabController.selectedIndex.value == index;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                  backgroundColor:
                      isSelected ? Colors.blue : Colors.grey.shade300,
                ),
                onPressed: () {
                  tabController.updateIndex(index);
                },
                child: Text(_tabs[index]["label"]!),
              ),
            );
          });
        }),
      ),
    );
  }
}
