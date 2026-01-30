import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConst {
  static String get gminiApi {
    return dotenv.env['GMINI_API_KEY'] ?? 'API_KEY_NOT_FOUND';
  }
}
