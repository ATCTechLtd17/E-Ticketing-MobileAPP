import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TransMediaController extends GetxController{
  var buttonState = <String, bool>{}.obs;

  
  @override
  void onInit() {
    super.onInit();
    // Set default selected button (e.g., 'Home')
    buttonState['Bus'] = true;
  }
  void toggleSelected (String label){
    buttonState.updateAll((key, val) => false);
    buttonState[label] = true;
  }

  bool isSelected(String label){
    return buttonState[label] ?? false;
  }
}

class IconButtons extends StatelessWidget {
  final IconData icon;
  final String label;
  final TransMediaController controller;
  
  const IconButtons({
    required this.icon,
    required this.label,
    required this.controller,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> controller.toggleSelected(label),
      child: Obx((){
        final selected = controller.isSelected(label);
        return Column(
          children: [
            Icon(icon, color: selected ? Colors.lightBlue[600] : Colors.grey),
            SizedBox(height: 4,),
            Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.lightBlue[600] : Colors.grey, fontWeight: selected ? FontWeight.bold : FontWeight.normal,),
            
            )
          ],
        );
      }),
    );
  }
}