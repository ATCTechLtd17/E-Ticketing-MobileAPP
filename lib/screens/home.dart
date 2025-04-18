import 'package:eticket_atc/controller/AuthController/authController.dart';
import 'package:eticket_atc/screens/FormPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const Home({super.key, this.userData});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();

    // If user data exists, make sure profile image is loaded
    if (widget.userData != null &&
        widget.userData!.containsKey("contactNumber")) {
      if (widget.userData!["profileImage"] == null) {
        authController.fetchUserProfile(widget.userData!["contactNumber"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        // This property ensures the screen scrolls when keyboard opens
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset('assets/images/bus_banner.jpg'),
            ),
            const Forms(),
          ],
        ),
      ),
      // Add this to allow keyboard to push the content up
      resizeToAvoidBottomInset: true,
    );
  }
}
