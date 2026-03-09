// This service sends the public enquiry form data
// to the backend so admins can review user questions.

import 'package:dio/dio.dart';
import 'api_client.dart';

class EnquiryService {
  final Dio _dio = ApiClient.client;

  // Sends an enquiry with basic contact information and a short message.
  Future<void> submitEnquiry({
    required String name,
    required String contactNumber,
    required String email,
    required String comment,
  }) async {
    await _dio.post('/enquiries', data: {
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
      'comment': comment,
    });
  }
}

