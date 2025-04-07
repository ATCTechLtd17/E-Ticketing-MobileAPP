import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:eticket_atc/controller/AuthController/authController.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const AppScaffold({
    super.key,
    required this.child,
    required this.currentPath,
  }) ;

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  // Calculate selected index dynamically based on the current path
  int _getSelectedIndex() {
    final path = widget.currentPath;
    if (path.contains('/profile')) {
      return 1;
    } else if (path.contains('/tickets')) {
      return 2;
    } else {
      return 0;
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 0) {
      // Home tab
      context.go('/');
    } else if (index == 1) {
      // Profile tab
      if (authController.isAuthenticated.value) {
        final contactNumber = authController.userData.value?["contactNumber"];
        context.go('/profile', extra: {'contactNumber': contactNumber});
      } else {
        context.go('/login');
      }
    } else if (index == 2) {
      // Tickets tab
      if (authController.isAuthenticated.value) {
        context.go('/discounts');
      } else {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current selected index
    final currentIndex = _getSelectedIndex();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Image.network(
                'https://infinityhubbd.online/assets/inif-C5gDDt_z.png',
                width: 100,
                height: 80,
              ),
            ),
            // Display profile icon or login button
            Obx(() {
              if (authController.isAuthenticated.value &&
                  authController.userData.value != null) {
                return GestureDetector(
                  onTap: () {
                    final contactNumber =
                        authController.userData.value!["contactNumber"];
                    context.go('/profile',
                        extra: {'contactNumber': contactNumber});
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        authController.userData.value!["profileImage"] != null
                            ? NetworkImage(
                                authController.userData.value!["profileImage"])
                            : const AssetImage('assets/images/avatar.jpg')
                                as ImageProvider,
                  ),
                );
              } else {
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
      ),
      body: widget.child, // This displays the current page content
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100],
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        selectedItemColor: Colors.lightBlue[500],
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.percent_rounded),
            label: 'Discounts',
          ),
        ],
      ),
    );
  }
}
