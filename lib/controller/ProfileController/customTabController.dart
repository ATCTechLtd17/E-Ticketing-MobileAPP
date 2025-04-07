import 'package:get/get.dart';

class CustomTabController extends GetxController {
  final selectedIndex = 0.obs;

  void updateIndex(int index) => selectedIndex.value = index;
}
