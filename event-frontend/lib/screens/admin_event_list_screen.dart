// This screen lets admins view all events along with registration counts,
// and navigate to create or edit an event.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/event_service.dart';
import '../providers/auth_provider.dart';

class AdminEventListScreen extends StatefulWidget {
  const AdminEventListScreen({super.key});

  @override
  State<AdminEventListScreen> createState() => _AdminEventListScreenState();
}

class _AdminEventListScreenState extends State<AdminEventListScreen> {
  final EventService _service = EventService();
  List<dynamic> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // Loads admin event list including registration counts.
  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      _events = await _service.adminFetchEvents();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Deletes an event and refreshes the list.
  Future<void> _deleteEvent(int id) async {
    await _service.adminDeleteEvent(id);
    await _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text('Manage Events'),
        actions: [
          TextButton(
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/admin/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color.fromARGB(255, 70, 181, 209)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/admin/event-form');
          await _loadEvents();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadEvents,
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index] as Map<String, dynamic>;
                  final date =
                      DateTime.tryParse(event['date']?.toString() ?? '');
                  final registrations =
                      event['registration_count']?.toString() ?? '0';
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(event['title'] ?? ''),
                      subtitle: Text(
                        '${event['location'] ?? ''} • ${date != null ? date.toLocal().toString().substring(0, 16) : ''}\n'
                        'Registrations: $registrations',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/admin/event-form',
                                arguments: event,
                              );
                              await _loadEvents();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteEvent(event['id'] as int),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
