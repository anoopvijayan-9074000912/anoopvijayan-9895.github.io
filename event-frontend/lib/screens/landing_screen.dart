// This screen is the public landing page of the web app.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enquiry_provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // Validates the enquiry form
  Future<void> _submitEnquiry() async {
    if (!_formKey.currentState!.validate()) return;
    final enquiryProvider =
        Provider.of<EnquiryProvider>(context, listen: false);
    await enquiryProvider.submitEnquiry(
      name: _nameController.text.trim(),
      contactNumber: _contactController.text.trim(),
      email: _emailController.text.trim(),
      comment: _commentController.text.trim(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(enquiryProvider.lastMessage ?? 'Done'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 142, 214, 237),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildHeroSection(context)),
                          const SizedBox(width: 32),
                          Expanded(child: _buildEnquiryCard(context)),
                        ],
                      )
                    : Column(
                        children: [
                          _buildHeroSection(context),
                          const SizedBox(height: 24),
                          _buildEnquiryCard(context),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the top navigation header with buttons for different sections.
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: const Color.fromARGB(255, 242, 245, 249),
      child: Row(
        children: [
          const Text(
            'Dewdrops Events',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text('Contact'),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: () {
              // Navigate to user login so normal users can sign in.
              Navigator.pushNamed(context, '/user/login');
            },
            child: const Text('User Login'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Navigate to admin login for administrators.
              Navigator.pushNamed(context, '/admin/login');
            },
            child: const Text('Admin Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Host events',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Dewdrop arranges conferences, webinars and seminars. '
          'contact our team for custom enquiries.',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  // Enquiry form
  Widget _buildEnquiryCard(BuildContext context) {
    final enquiryProvider = Provider.of<EnquiryProvider>(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Send us an enquiry',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Comment (max 300 characters)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  if (value.length > 300) {
                    return 'Comment must be 300 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enquiryProvider.isSubmitting
                      ? null
                      : () => _submitEnquiry(),
                  child: enquiryProvider.isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Enquiry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
