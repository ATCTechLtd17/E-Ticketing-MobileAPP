import 'package:eticket_atc/controller/authController.dart';
import 'package:eticket_atc/controller/ticketDetailsController.dart';
import 'package:eticket_atc/models/bus_model.dart';
import 'package:eticket_atc/screens/busDetails.dart';
import 'package:eticket_atc/screens/home.dart';
import 'package:eticket_atc/screens/login.dart';
import 'package:eticket_atc/screens/profilePage.dart';
import 'package:eticket_atc/screens/searchResult.dart';
import 'package:eticket_atc/screens/register.dart';
import 'package:eticket_atc/screens/ticketForm.dart';
import 'package:eticket_atc/widgets/ticketDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// Controller dependencies initialization
// Controller dependencies initialization
void initControllers() {
  // Ensure AuthController is always registered
  if (!Get.isRegistered<AuthController>()) {
    Get.put(AuthController(), permanent: true);
  }

  // Ensure TicketDetailsController is always registered
  if (!Get.isRegistered<TicketDetailsController>()) {
    Get.put(TicketDetailsController(), permanent: true);
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // Ensure controllers are initialized
    initControllers();

    // Get the auth controller
    final authController = Get.find<AuthController>();

    // Check if the user is trying to access a protected route
    final isProtectedRoute = state.matchedLocation.startsWith('/profile') ||
        state.matchedLocation.startsWith('/dashboard');

    // If the route is protected and the user is not authenticated, redirect to login
    if (isProtectedRoute && !authController.isAuthenticated.value) {
      return '/login';
    }

    // If the user is authenticated and trying to access login/register, redirect to home
    if ((state.matchedLocation == '/login' ||
            state.matchedLocation == '/register') &&
        authController.isAuthenticated.value) {
      return '/';
    }

    // No redirection needed
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        // Get the auth controller to access user data
        final authController = Get.find<AuthController>();

        // Use Obx or GetX to reactively update the UI when authentication state changes
        return Obx(() => Home(userData: authController.userData.value));
      },
      routes: [
        GoRoute(
          path: 'search-results',
          builder: (BuildContext context, GoRouterState state) {
            return const SearchResultsPage();
          },
        ),
        GoRoute(
          path: 'bus-details',
          builder: (context, state) {
            final bus = state.extra as Bus;
            return BusDetails(bus: bus);
          },
        ),
        GoRoute(
          path: 'register',
          builder: (context, state) {
            return RegisterPage();
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            // Get the auth controller to access user data
            final authController = Get.find<AuthController>();

            // Pass the contact number from the controller, not the router
            return Obx(() => ProfilePage(
                  contactNumber:
                      authController.userData.value?['contactNumber'] ?? '',
                ));
          },
        ),
        GoRoute(
          path: 'login',
          builder: (context, state) {
            final ticketData = state.extra as Map<String, dynamic>?;
            return LoginPage(redirectData: ticketData);
          },
        ),
        GoRoute(
          path: 'ticketForm',
          builder: (context, state) {
            return TicketFormPage();
          },
        ),
       // In app_router.dart - Modify the ticketDetails route
        GoRoute(
          path: 'ticketDetails',
          builder: (context, state) {
            // Check if TicketDetailsController is already registered
            if (!Get.isRegistered<TicketDetailsController>()) {
              Get.put(TicketDetailsController());
            }

            // No need to pass or receive extra data
            return TicketDetailsPage();
          },
        ),
      ],
    ),
  ],
);
