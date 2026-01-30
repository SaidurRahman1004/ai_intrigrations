import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../core/constant.dart';

class GeminiService {
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  final String modelName = 'gemini-pro';

  //setn Input
  Future<String> sendMessage(String message) async {
    try {
      if (AppConst.gminiApi.isEmpty) {
        throw Exception('API Key missing!');
      }
      final url = Uri.parse(
        '$baseUrl/$modelName:generateContent?key=${AppConst.gminiApi}',
      );
      //prepaire request body
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': message, // User  actual message
              },
            ],
          },
        ],

        //  Generation configuration
        'generationConfig': {
          'temperature': 0.7, // Creativity level (0.0-1.0)
          'maxOutputTokens': 1000, // Maximum response length
          'topP': 0.8, // Diversity parameter
          'topK': 40, // Consider top K tokens
        },
        //  Safety settings (optional)
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
        ],
      };
      debugPrint(' Sending request to Gemini AI...');
      //Post Request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // JSON data sent
        },
        body: jsonEncode(requestBody), // Dart object to JSON string
      );
      debugPrint(' Response received! Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final generatedText = responseData['candidates'] as List;
        if (generatedText.isEmpty) {
          throw Exception('No response from AI');
        }

        final content = generatedText[0]['content'] as Map<String, dynamic>;
        final parts = content['parts'] as List;
        final text = parts[0]['text'] as String;
        debugPrint(' AI Response: ${text.substring(0, 50)}...');
        return text.trim();
      } else if (response.statusCode == 400) {
        //  Bad Request
        final error = jsonDecode(response.body);
        throw Exception(' Invalid request: ${error['error']['message']}');
      } else if (response.statusCode == 403) {
        //  Forbidden: API key problem
        throw Exception(' API Key invalid or disabled!');
      } else if (response.statusCode == 429) {
        ///️ Rate limit exceeded
        throw Exception(' Too many requests! Rate limit exceeded.');
      } else if (response.statusCode == 500) {
        //  Server error
        throw Exception(' Google server error!');
      } else {
        // Unknown error
        throw Exception(' Unknown error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(' Error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception(' No internet connection!');
      } else {
        throw Exception(' Failed to get AI response: $e');
      }
    }
  }
  //Image Analysis Function
  Future<String> analyzeImage(String imageBase64, String prompt) async {
    try {
      final url = Uri.parse(
          '$baseUrl/gemini-pro-vision:generateContent?key=${AppConst.gminiApi}'
      );

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}, // Question about image
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': imageBase64, // Base64 encoded image
                }
              }
            ]
          }
        ]
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final text = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        return text.trim();
      } else {
        throw Exception('Image analysis failed');
      }

    } catch (e) {
      throw Exception('Failed to analyze image: $e');
    }
  }
  Stream<String> sendMessageStream(String message) async* {
    yield 'Streaming feature coming soon...';
  }
}
