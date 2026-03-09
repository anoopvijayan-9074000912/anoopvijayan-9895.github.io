// This screen lists all events that the current user has registered for.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../providers/auth_provider.dart';

class MyRegistrationsScreen extends StatefulWidget {
  const MyRegistrationsScreen({super.key});

  @override
  State<MyRegistrationsScreen> createState() => _MyRegistrationsScreenState();
}

class _MyRegistrationsScreenState extends State<MyRegistrationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load registrations once the widget is inserted into the tree.
    Future.microtask(
      () => Provider.of<EventProvider>(context, listen: false)
          .loadMyRegistrations(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Registered Events'),
        actions: [
          TextButton(
            onPressed: () {
              // Logs out the current user and returns to the user login screen.
              auth.logout();
              Navigator.pushReplacementNamed(context, '/user/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color.fromARGB(255, 32, 148, 206)),
            ),
          ),
        ],
      ),
      body: provider.myRegistrations.isEmpty
          ? const Center(child: Text('No registrations yet.'))
          : ListView.builder(
              itemCount: provider.myRegistrations.length,
              itemBuilder: (context, index) {
                final reg =
                    provider.myRegistrations[index] as Map<String, dynamic>;
                final date = DateTime.tryParse(reg['date']?.toString() ?? '');
                return ListTile(
                  title: Text(reg['title'] ?? ''),
                  subtitle: Text(
                    '${reg['location'] ?? ''} • ${date != null ? date.toLocal().toString().substring(0, 16) : ''}',
                  ),
                );
              },
            ),
    );
  }
}
