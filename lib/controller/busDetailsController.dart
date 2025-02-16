import 'package:eticket_atc/models/bus_model.dart';
import 'package:get/get.dart';

class BusDetailsController extends GetxController {
  final Bus bus;
  final String defaultBoarding;

  RxString selectedBoarding;
  RxString selectedDropping;
  RxDouble ticketPrice = 0.0.obs;

  BusDetailsController({required this.bus, this.defaultBoarding = ''})
      : selectedBoarding = RxString(defaultBoarding.isNotEmpty
            ? defaultBoarding
            : bus.busSchedule[0].startPoint),
        selectedDropping = RxString(bus.busSchedule[0].endPoint);
  @override
  void onInit() {
    super.onInit();
    updateTicketPrice();
  }

  void updateTicketPrice() {
    if (selectedBoarding.value == bus.busSchedule[0].startPoint) {
      ticketPrice.value = bus.busSchedule[0].ticketPrice.toDouble();
    } else {
      final matchRoutes = bus.busRoute
          .where((route) => route.stoppageLocation == selectedBoarding.value)
          .toList();

      if (matchRoutes.isNotEmpty) {
        ticketPrice.value = matchRoutes.first.ticketPrice.toDouble();
      } else {
        ticketPrice.value = bus.busSchedule[0].ticketPrice.toDouble();
      }
    }
  }

  void setSelectedBoarding(String? value) {
    if (value != null) {
      selectedBoarding.value = value;
      updateTicketPrice();
    }
  }

  void setSelectedDropping(String? value) {
    if (value != null) {
      selectedDropping.value = value;
    }
  }
}
