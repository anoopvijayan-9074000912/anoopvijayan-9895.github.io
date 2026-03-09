// This screen shows all upcoming events to the logged in user.
// Users can tap an event to view its details or register.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../providers/auth_provider.dart';

class UserEventListScreen extends StatefulWidget {
  const UserEventListScreen({super.key});

  @override
  State<UserEventListScreen> createState() => _UserEventListScreenState();
}

class _UserEventListScreenState extends State<UserEventListScreen> {
  @override
  void initState() {
    super.initState();
    // Load events as soon as the screen is ready.
    Future.microtask(
      () => Provider.of<EventProvider>(context, listen: false).loadEvents(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user/registrations');
            },
            child: const Text(
              'My Registrations',
              style: TextStyle(color: Color.fromARGB(255, 92, 169, 220)),
            ),
          ),
          TextButton(
            onPressed: () {
              // Logs out the current user and returns to the user login screen.
              auth.logout();
              Navigator.pushReplacementNamed(context, '/user/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color.fromARGB(255, 92, 169, 220)),
            ),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadEvents,
              child: ListView.builder(
                itemCount: provider.events.length,
                itemBuilder: (context, index) {
                  final event = provider.events[index] as Map<String, dynamic>;
                  final date =
                      DateTime.tryParse(event['date']?.toString() ?? '');
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(event['title'] ?? ''),
                      subtitle: Text(
                        '${event['location'] ?? ''} • ${date != null ? date.toLocal().toString().substring(0, 16) : ''}',
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/user/event-detail',
                          arguments: event,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
