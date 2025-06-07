import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.97.44:8000';

  static Future<bool> deleteTask(String id) async {
    final url = Uri.parse(
        '$baseUrl/tasks/$id'); // Ensure this matches your FastAPI route

    try {
      final response = await http.delete(url);
      print('Delete status: ${response.statusCode}');
      print('Delete response: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  static Future<bool> addTask(String title) async {
    final url = Uri.parse('$baseUrl/tasks');

    final body = {
      'title': title,
      'is_completed': false,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error occurred while adding task: $e');
      return false;
    }
  }

  static Future<void> updateTaskStatus(String? id, bool completed) async {
    if (id == null || id.isEmpty) {
      return;
    }

    final url = Uri.parse('$baseUrl/tasks/$id');
    final body = jsonEncode({"is_completed": completed});

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

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
}
