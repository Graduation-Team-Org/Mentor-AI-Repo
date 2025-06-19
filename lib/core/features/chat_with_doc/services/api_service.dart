import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  // Replace with your deployed AWS App Runner URL
  static const String baseUrl = 'https://gtjyqhvu7e.us-east-1.awsapprunner.com';

  // Upload PDF file
  static Future<Map<String, dynamic>> uploadPdf(String filePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload-pdf'),
      );

      // Attach the PDF file using the path
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Changed from 'pdf_file' to 'file' to match Flask endpoint
          filePath,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Handle API errors (e.g., 500 Internal Server Error from Flask)
        String errorBody = response.body;
        print('Upload API Error (${response.statusCode}): $errorBody');
        throw Exception(
          'Failed to upload PDF: ${response.statusCode} - $errorBody',
        );
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error during PDF upload: $e');
      throw Exception('Error uploading PDF: $e');
    }
  }

  // Ask question
  static Future<Map<String, dynamic>> askQuestion(String question) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'question': question,
        }), // Matches your Flask API's expected 'question' key
      );

      if (response.statusCode == 200) {
        return json.decode(
          response.body,
        ); // Should contain 'answer' and 'chat_history'
      } else {
        // Handle API errors
        String errorBody = response.body;
        print('Chat API Error (${response.statusCode}): $errorBody');
        throw Exception(
          'Failed to get answer: ${response.statusCode} - $errorBody',
        );
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error asking question: $e');
      throw Exception('Error asking question: $e');
    }
  }
}
