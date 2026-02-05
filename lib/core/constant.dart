import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConst {
  //Gmini
  static String get gminiApi {
    return dotenv.env['GMINI_API_KEY'] ?? 'API_KEY_NOT_FOUND';
  }
  //Hugging Face
  static String get huggingFaceApi {
    return dotenv.env['HUGGING_FACE_API_KEY'] ?? 'API_KEY_NOT_FOUND';
  }
}
