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
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        final userData = state.extra as Map<String, dynamic>?;
        return Home(userData: userData);
      },
      routes: [
        GoRoute(
          path: 'search-results',
          builder: (BuildContext context, GoRouterState state) {
            return const SearchResultsPage();
          },
        ),
        GoRoute(
          path: '/bus-details',
          builder: (context, state) {
            final bus = state.extra as Bus;
            return BusDetails(
              bus: bus,
            );
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
             final contactNumber = state.extra as String;
            return ProfilePage(contactNumber:contactNumber ,);
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
            final extra = state.extra as Map<String, dynamic>? ?? {};

            return TicketFormPage(
              bookedSeats: extra["bookedSeats"] ?? [],
              busName: extra["busName"] ?? "",
              busNumber: extra["busNumber"] ?? "",
              ticketPrice: extra["ticketPrice"] ?? 0.0,
            );
          },
        ),
        GoRoute(
          path: '/ticketDetails',
          builder: (context, state) {
            final ticketData = state.extra as Map<String, dynamic>;
            return TicketDetailsPage(ticketData: ticketData);
          },
        ),
      ],
    ),
  ],
);
