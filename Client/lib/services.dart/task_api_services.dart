import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskApiService {
  static String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  static Future<bool> deleteTask(String id) async {
    final url = Uri.parse('$baseUrl/tasks/$id');

    try {
      final response = await http.delete(url);

      return response.statusCode == 200;
    } catch (e) {
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
    final url = Uri.parse('$baseUrl/tasks');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}
