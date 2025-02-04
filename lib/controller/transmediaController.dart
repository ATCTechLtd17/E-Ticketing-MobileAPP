import 'package:get/get.dart';

class TransMediaController extends GetxController {
  var buttonState = <String, bool>{}.obs;
  RxString selectedTransport = 'Bus'.obs;

  @override
  void onInit() {
    super.onInit();

    
    buttonState.value = {
      'Air': false,
      'Train': false,
      'Bus': true, 
    };

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
