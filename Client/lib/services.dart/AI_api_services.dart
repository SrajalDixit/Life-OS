import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiApiService {
 

  static Future<String> sendToBot(String message) async {
    String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
    final url = Uri.parse("$baseUrl/chatbot");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"message": message}),
    );

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  }
}
