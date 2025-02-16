import 'package:eticket_atc/models/bus_model.dart';
import 'package:eticket_atc/screens/busDetails.dart';
import 'package:eticket_atc/screens/home.dart';
import 'package:eticket_atc/screens/searchResult.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
 // Optional: your initial/home page

/// Create a GoRouter instance with your routes.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Home(); 
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
          return BusDetails(bus: bus,);
        },
        ),

      ],
    ),
  ],
);
