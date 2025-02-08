import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollHideController extends GetxController{
  final ScrollController scrollController = ScrollController();
  var showForm = true.obs;
  double _previousOffset = 0.0;

  @override
  void onInit(){
    super.onInit();
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll(){
    double currentOffset = scrollController.offset;
    
    if(currentOffset > _previousOffset && showForm.value){
      showForm.value = false;
    }
    else if(currentOffset < _previousOffset && !showForm.value){
      showForm.value = true;
    }

    _previousOffset = currentOffset;
  }

  @override
  void onClose(){
    scrollController.dispose();
    super.onClose();
  }
}