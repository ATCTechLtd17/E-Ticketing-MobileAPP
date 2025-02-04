import 'package:get/get.dart';

class TransMediaController extends GetxController {
  var buttonState = <String, bool>{}.obs;

  RxString selectedTransport = 'Bus'.obs;

  @override
  void onInit() {
    super.onInit();
    buttonState['Bus'] = true;
    buttonState['Air'] = false;
    buttonState['Train'] = false;
    selectedTransport.value = 'Bus';
  }

  void toggleSelected(String label) {
    buttonState.updateAll((key, val) => false);
    buttonState[label] = true;
    selectedTransport.value = label;
  }

  bool isSelected(String label) {
    return buttonState[label] ?? false;
  }
}
