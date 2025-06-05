import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.97.44:8000';

  static Future<void> updateTaskStatus(String id, bool completed) async {
    final url = Uri.parse('$baseUrl/update-task-status/$id');

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"is_completed": completed}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update task status");
    }
  }



  static Future<List<dynamic>> fetchTasks() async {
    final url = await Uri.parse('$baseUrl/tasks');

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
