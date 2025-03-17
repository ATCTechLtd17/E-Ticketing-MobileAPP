
import 'package:eticket_atc/controller/authController.dart';
import 'package:eticket_atc/screens/FormPage.dart';
import 'package:eticket_atc/widgets/graidentIcon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GradientIcon(
                size: 60,
                icon: Icons.all_inclusive,
                gradientColors: [Colors.white, Colors.black],
                shimmerColors: [
                  Colors.lightBlue[300]!,
                  Colors.lightBlue[500]!,
                  Colors.purple[200]!,
                  Colors.purpleAccent[400]!,
                  Colors.deepPurpleAccent,
                ],
              ),
            ),
            // Use Obx to reactively update when authentication state changes
            Obx(() {
              if (authController.isAuthenticated.value &&
                  authController.userData.value != null) {
                // User is logged in
                return SizedBox(
                  height: 100,
                  width: 100,
                  child: PopupMenuButton<String>(
                    icon: authController.userData.value!["profileImage"] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                authController.userData.value!["profileImage"]),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.lightBlue[500],
                            child: Image.asset('assets/images/avatar.jpg'),
                          ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: Text('Profile'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'dashboard',
                        child: Text('Dashboard'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Log Out'),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'profile':
                          context.push('/profile');
                          break;
                        case 'dashboard':
                          context.go('/dashboard');
                          break;
                        case 'logout':
                          authController.logout();
                          context.go('/');
                          break;
                      }
                    },
                  ),
                );
              } else {
                // User is not logged in
                return SizedBox(
                  height: 35,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 3),
                      backgroundColor: Colors.lightBlue[500],
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50],
                      ),
                    ),
                  ),
                );
              }
            }),
          ],
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu_outlined,
            size: 25,
            color: Colors.lightBlue[700],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset('assets/images/bus_banner.jpg'),
            ),
            Forms(),
          ],
        ),
      ),
    );
  }
}
