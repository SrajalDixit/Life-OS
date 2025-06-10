import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotesApiService {
static String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  static Future<void> deleteNote(String noteId) async {
    final url = Uri.parse('$baseUrl/notes/$noteId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Note deleted successfully');
    } else if (response.statusCode == 404) {
      throw Exception('Note not found');
    } else {
      throw Exception('Failed to delete note: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> addNote(Map<String, dynamic> note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add note: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchNotes() async {
  final response = await http.get(Uri.parse("$baseUrl/notes"));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map<Map<String, dynamic>>((note) => Map<String, dynamic>.from(note)).toList();
  } else {
    throw Exception('Failed to fetch notes: ${response.statusCode}');
  }
}

}
