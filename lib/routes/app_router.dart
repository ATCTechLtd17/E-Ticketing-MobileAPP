import 'package:eticket_atc/controller/authController.dart';
import 'package:eticket_atc/controller/ticketDetailsController.dart';
import 'package:eticket_atc/layout/scaffold.dart';
import 'package:eticket_atc/models/bus_model.dart';
import 'package:eticket_atc/screens/busDetails.dart';
import 'package:eticket_atc/screens/home.dart';
import 'package:eticket_atc/screens/login.dart';
import 'package:eticket_atc/screens/profilePage.dart';
import 'package:eticket_atc/screens/searchResult.dart';
import 'package:eticket_atc/screens/register.dart';
import 'package:eticket_atc/screens/ticketForm.dart';
import 'package:eticket_atc/screens/ticketDetails.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

void initControllers() {
  if (!Get.isRegistered<AuthController>()) {
    Get.put(AuthController(), permanent: true);
  }

  if (!Get.isRegistered<TicketDetailsController>()) {
    Get.put(TicketDetailsController(), permanent: true);
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    initControllers();

    final authController = Get.find<AuthController>();

    final isProtectedRoute = state.matchedLocation.startsWith('/profile') ||
        state.matchedLocation.startsWith('/dashboard') ||
        state.matchedLocation.startsWith('/tickets');

    if (isProtectedRoute && !authController.isAuthenticated.value) {
      return '/login';
    }

    if ((state.matchedLocation == '/login' ||
            state.matchedLocation == '/register') &&
        authController.isAuthenticated.value) {
      return '/';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // Wrap every route with our app scaffold
        return AppScaffold(
          child: child,
          currentPath: state.matchedLocation,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            final authController = Get.find<AuthController>();
            return Obx(
                () => Home(userData: authController.userData.value));
          },
        ),
        GoRoute(
          path: '/search-results',
          builder: (context, state) {
            return const SearchResultsPage();
          },
        ),
        GoRoute(
          path: '/bus-details',
          builder: (context, state) {
            final bus = state.extra as Bus;
            return BusDetails(bus: bus);
          },
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) {
            return RegisterPage();
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            final authController = Get.find<AuthController>();
            return Obx(() => ProfilePage(
                  contactNumber:
                      authController.userData.value?['contactNumber'] ?? '',
                ));
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) {
            final ticketData = state.extra as Map<String, dynamic>?;
            return LoginPage(redirectData: ticketData);
          },
        ),
        GoRoute(
          path: '/ticketForm',
          builder: (context, state) {
            return TicketFormPage();
          },
        ),
        GoRoute(
          path: '/ticketDetails',
          builder: (context, state) {
            return TicketDetailsPage();
          },
        ),
        // GoRoute(
        //   path: '/tickets',
        //   builder: (context, state) {
        //     return const ProfilePage();
        //   },
        // ),
      ],
    ),
  ],
);
