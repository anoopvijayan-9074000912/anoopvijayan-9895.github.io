// This is the entry point of the Flutter app.
// It wires up global providers and defines named routes for all screens.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/enquiry_provider.dart';

import 'screens/landing_screen.dart';
import 'screens/user_login_screen.dart';
import 'screens/user_signup_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/user_event_list_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/my_registrations_screen.dart';
import 'screens/admin_event_list_screen.dart';
import 'screens/admin_event_form_screen.dart';

void main() {
  runApp(const EventApp());
}

class EventApp extends StatelessWidget {
  const EventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => EnquiryProvider()),
      ],
      child: MaterialApp(
        title: 'Dewdrop Event Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingScreen(),
          '/user/login': (context) => const UserLoginScreen(),
          '/user/signup': (context) => const UserSignupScreen(),
          '/admin/login': (context) => const AdminLoginScreen(),
          '/user/events': (context) => const UserEventListScreen(),
          '/user/event-detail': (context) => const EventDetailScreen(),
          '/user/registrations': (context) => const MyRegistrationsScreen(),
          '/admin/events': (context) => const AdminEventListScreen(),
          '/admin/event-form': (context) => const AdminEventFormScreen(),
        },
      ),
    );
  }
}
