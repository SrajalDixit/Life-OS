import 'dart:convert';
import 'package:http/http.dart' as http;

class AiApiService {
 static const String baseUrl = 'http://192.168.97.44:8000';

  static Future<String> sendToBot(String message) async {
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
