import 'package:eticket_atc/models/bus_model.dart';
import 'package:get/get.dart';

class BusDetailsController extends GetxController {
  final Bus bus;

  RxString selectedBoarding;
  RxString selectedDropping;
  RxDouble ticketPrice = 0.0.obs;

  BusDetailsController({required this.bus, String defaultBoarding = ''})
      : selectedBoarding = RxString(defaultBoarding.isNotEmpty
            ? defaultBoarding
            : bus.busSchedule.isNotEmpty
                ? bus.busSchedule[0].startPoint
                : ''),
        selectedDropping = RxString(
            bus.busSchedule.isNotEmpty ? bus.busSchedule[0].endPoint : '');

  @override
  void onInit() {
    super.onInit();

    // Ensure we have valid values at initialization
    if (selectedBoarding.value.isEmpty && bus.busSchedule.isNotEmpty) {
      selectedBoarding.value = bus.busSchedule[0].startPoint;
    }

    if (selectedDropping.value.isEmpty && bus.busSchedule.isNotEmpty) {
      selectedDropping.value = bus.busSchedule[0].endPoint;
    }

    updateTicketPrice();

    // Log the initial values
    print(
        'BusDetailsController initialized with: boarding=${selectedBoarding.value}, dropping=${selectedDropping.value}');
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
    if (value != null && value.isNotEmpty) {
      selectedBoarding.value = value;
      updateTicketPrice();
    } else if (bus.busSchedule.isNotEmpty) {
      // Use default value if null or empty is passed
      selectedBoarding.value = bus.busSchedule[0].startPoint;
      updateTicketPrice();
    }
  }

  void setSelectedDropping(String? value) {
    if (value != null && value.isNotEmpty) {
      selectedDropping.value = value;
    } else if (bus.busSchedule.isNotEmpty) {
      // Use default value if null or empty is passed
      selectedDropping.value = bus.busSchedule[0].endPoint;
    }
  }
}
