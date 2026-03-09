// This provider manages the enquiry form submission state
// and exposes a method that screens can call to send enquiries.

import 'package:flutter/material.dart';
import '../services/enquiry_service.dart';

class EnquiryProvider extends ChangeNotifier {
  final EnquiryService _enquiryService = EnquiryService();

  bool _isSubmitting = false;
  String? _lastMessage;

  bool get isSubmitting => _isSubmitting;
  String? get lastMessage => _lastMessage;

  // Sends an enquiry to the backend and stores a short status message.
  Future<void> submitEnquiry({
    required String name,
    required String contactNumber,
    required String email,
    required String comment,
  }) async {
    _isSubmitting = true;
    _lastMessage = null;
    notifyListeners();
    try {
      await _enquiryService.submitEnquiry(
        name: name,
        contactNumber: contactNumber,
        email: email,
        comment: comment,
      );
      _lastMessage = 'Enquiry submitted successfully';
    } catch (e) {
      _lastMessage = 'Failed to submit enquiry';
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}

