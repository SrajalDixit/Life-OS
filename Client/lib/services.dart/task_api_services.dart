import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.97.44:8000';

  static Future<void> updateTaskStatus(String? id, bool completed) async {
  if (id == null || id.isEmpty) {
    print("Skipping update: Task ID is null or empty");
    return;
  }

  final url = Uri.parse('$baseUrl/tasks/$id');
  final body = jsonEncode({"is_completed": completed});

  print("PATCH to: $url");
  print("Body: $body");

  final response = await http.patch(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  print("Response code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Failed to update task status for ID: $id");
  }
}





  static Future<List<dynamic>> fetchTasks() async {
    final url = Uri.parse('http://192.168.97.44:8000/tasks');


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
