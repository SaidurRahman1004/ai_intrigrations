import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../core/constant.dart';

class HuggingFaceService {
  final String apiTocken = AppConst.huggingFaceApi;
  final String baseUrl = 'https://router.huggingface.co/models';

  Future<String> generateText({
    required String prompt,
    String modelId = 'gpt2',
  }) async {
    try {
      debugPrint('Generating text with prompt: $modelId');
      final url = Uri.parse('$baseUrl/$modelId');

      final requestBody = {
        'inputs': prompt,
        'parameters': {
          'max_length': 100,
          'temperature': 0.7,
          'top_p': 0.9,
          'do_sample': true,
        },
      };
      debugPrint('sending request...');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiTocken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      debugPrint(' Response received! Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody is List && responseBody.isNotEmpty) {
          final generatedText = responseBody[0]['generated_text'] as String;
          debugPrint('🙌 Generated: ${generatedText.substring(0, 50)}...');
          return generatedText.trim();
        } else {
          throw Exception('Empty response from model');
        }
      } else if (response.statusCode == 503) {
        return ' Model is loading... Please wait 20 seconds and try again....';
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API token! Check .env file');
      } else {
        final error = jsonDecode(response.body);
        throw Exception('API Error: ${error['error'] ?? response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error generating text: $e');
      throw Exception('Failed to generate text: $e');
    }
  }

  //TransLate Function
  Future<String> translateText({
    required String text,
    String fromLang = 'en',
    String toLang = 'bn',
  }) async {
    try {
      debugPrint(' Translating: $fromLang → $toLang');
      //Model Declire
      String modelId;
      if (fromLang == 'en' && toLang == 'bn') {
        modelId = 'Helsinki-NLP/opus-mt-en-bn';
      } else if (fromLang == 'bn' && toLang == 'en') {
        modelId = 'Helsinki-NLP/opus-mt-bn-en';
      } else {
        throw Exception('Unsupported language pair: $fromLang → $toLang');
      }
      final url = Uri.parse('$baseUrl/$modelId');
      //req body or headers
      final requestBody = {'inputs': text};
      final headers = {
        'Authorization': 'Bearer $apiTocken',
        'Content-Type': 'application/json',
      };
      //http req
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      debugPrint(' Response received! Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is List && responseBody.isNotEmpty) {
          final translatedText = responseBody[0]['translation_text'] as String;
          debugPrint('Translated: $translatedText');
          return translatedText.trim();
        } else {
          throw Exception('Empty response from model');
        }
      } else if (response.statusCode == 503) {
        return ' Model is loading... Please wait 20 seconds and try again....';
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API token! Check .env file');
      } else {
        final error = jsonDecode(response.body);
        throw Exception('API Error: ${error['error'] ?? response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error translating text: $e');
      throw Exception('Failed to translate text: $e');
    }
  }

  //Sentiment Analysis Functions
  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    try {
      debugPrint(' Analyzing sentiment...');

      // Model
      const modelId = 'j-hartmann/emotion-english-distilroberta-base';
      final url = Uri.parse('$baseUrl/$modelId');
      //req body or headers
      final requestBody = {'inputs': text};
      final headers = {
        'Authorization': 'Bearer $apiTocken',
        'Content-Type': 'application/json',
      };
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      debugPrint(' Response received! Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is List && responseBody.isNotEmpty) {
          //took 1st emotions list
          final emotions = responseBody[0] as List;
          //took 1st emotions to score
          final topEmotion = emotions[0];

          final label = topEmotion['label'] as String;
          final score = topEmotion['score'] as double;

          debugPrint(' Emotion: $label (${(score * 100).toStringAsFixed(1)}%)');

          return {
            'emotion': label,
            'confidence': score,
            'emoji': _getEmojiForEmotion(label),
          };
        } else {
          throw Exception('Empty response from model');
        }
      } else if (response.statusCode == 503) {
        return {
          'emotion': 'loading',
          'confidence': 0.0,
          'emoji': '⏳',
        };
      }else{
        final error = jsonDecode(response.body);
        throw Exception('API Error: ${error['error'] ?? response.statusCode}');

      }
    }catch(e) {
      debugPrint('Error analyzing sentiment: $e');
      throw Exception('Failed to analyze sentiment: $e');
    }
  }

  //emotion emoji
  String _getEmojiForEmotion(String emotion){
    switch (emotion.toLowerCase()) {
      case 'joy':
      case 'happiness':
        return '😊';
      case 'sadness':
        return '😢';
      case 'anger':
        return '😠';
      case 'fear':
        return '😨';
      case 'surprise':
        return '😲';
      case 'disgust':
        return '🤢';
      case 'love':
        return '❤️';
      default:
        return '😐';
    }
  }

  //See Models Details
  Future<Map<String, dynamic>> getModelInfo(String modelId)async{
    try{
      final url = Uri.parse('https://huggingface.co/api/models/$modelId');
      final response = await http.get(url);
      if(response.statusCode == 200){
        final responseBody = jsonDecode(response.body);
        return responseBody;
      }else{
        throw Exception('Failed to fetch model info: ${response.statusCode}');
      }
    }catch(e){
      throw Exception('Error fetching model info: $e');
    }
  }


}

