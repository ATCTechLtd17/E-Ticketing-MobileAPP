import 'dart:convert';
import 'package:eticket_atc/screens/FormPage.dart';
import 'package:eticket_atc/services/auth_service.dart';
import 'package:eticket_atc/widgets/graidentIcon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const Home({super.key, this.userData});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? profileImage;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null &&
        widget.userData!.containsKey("contactNumber")) {
      fetchUserProfile(widget.userData!["contactNumber"]);
    }
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    context.go('/');
  }

  Future<void> fetchUserProfile(String contactNumber) async {
    final url = Uri.parse(
        'https://e-ticketing-server.vercel.app/api/v1/passenger/get-passenger/$contactNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          profileImage = data["profileImage"];
        });
      }
    } catch (e) {
      debugPrint("Error fetching user profile: $e");
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
            if (widget.userData != null &&
                widget.userData!.containsKey("contactNumber"))
              SizedBox(
                height: 100,
                width: 100,
                child: PopupMenuButton<String>(
                  icon: profileImage != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(profileImage!),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.lightBlue[500],
                          child: Image.asset('assets/images/avatar.jpg',
                          
                          ),
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
                        final contactNumber = widget.userData?["contactNumber"];
                        if (contactNumber != null) {
                          context.push('/profile', extra: contactNumber);
                        }
                        break;
                      case 'dashboard':
                        context.go('/dashboard');
                        break;
                      case 'logout':
                        _logout(context);
                        break;
                    }
                  },
                ),
              )
            else
              SizedBox(
                height: 35,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
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
              ),
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
