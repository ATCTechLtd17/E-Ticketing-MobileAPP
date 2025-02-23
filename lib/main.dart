import 'package:eticket_atc/routes/app_router.dart';
import 'package:eticket_atc/services/auth_service.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await AuthService.isTokenValid();
  runApp(MyApp(isLoggedIn: isLoggedIn));

}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'E-Ticket ATC',
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      debugShowCheckedModeBanner: false,
    );
  }
}
