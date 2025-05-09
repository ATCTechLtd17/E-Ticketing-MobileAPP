import 'package:eticket_atc/controller/ProfileController/customTabController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/widgets/microwidgets/profile/insightTab.dart';
import 'package:eticket_atc/widgets/microwidgets/profile/profileTab.dart';

class CustomTabBar extends StatelessWidget {
  CustomTabBar({super.key});

  final List<Map<String, dynamic>> _tabs = [
    {"label": "Profile", "widget": ProfileTab()},
    {"label": "Insights", "widget": InsightTab()},
    // {"label": "Tickets", "widget": TicketTab()},
    // {"label": "Total Buy", "widget": TotalBuyTab()},
    // {"label": "Cancel Request", "widget": CancelTicketTab()},
  ];

  @override
  Widget build(BuildContext context) {
    // Create or retrieve the controller instance
    final CustomTabController tabController = Get.put(CustomTabController());

    return Column(
      children: [
        _buildTabBar(tabController),
        // Replace IndexedStack with an Obx-wrapped widget that only shows the current tab
        Obx(
          () => _tabs[tabController.selectedIndex.value]["widget"] as Widget,
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
