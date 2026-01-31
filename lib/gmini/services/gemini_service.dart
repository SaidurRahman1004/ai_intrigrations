import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/constant.dart';
class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: AppConst.gminiApi,
      requestOptions: const RequestOptions(apiVersion: 'v1'),
    );
  }

  //setn Input txt msg only
  Future<String> sendMessage(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      if (response.text == null) {
        return 'Something went wrong';
      }
      return response.text!.trim();
    } catch (e) {
      return 'Error: $e';
    }
  }

  //Image Analysis Function
  Future<String> analyzeImage(Uint8List imageBytes, String prompt) async {
    try{
      final content =[
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];
      final response = await _model.generateContent(content);
      if(response.text == null){
        return 'Something went wrong';
      }
      return response.text!.trim();

    }catch(e){
      return 'Error: $e';
    }


  }

  Stream<GenerateContentResponse> sendMessageStream(String prompt) {
    final content = [Content.text(prompt)];
    return _model.generateContentStream(content);
  }
}
