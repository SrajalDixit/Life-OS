import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http:// 192.168.97.44:8000';


  static Future<List<dynamic>> fetchTasks() async {
    final url = Uri.parse('$baseUrl/tasks');

    final response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // You can also add methods for POST, PUT, DELETE here later
}
