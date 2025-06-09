import 'package:http/http.dart' as http;
import 'dart:convert';

class NotesApiService {
   static const String baseUrl = 'http://192.168.26.44:8000';

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
      print('working upto this line');
      final List<dynamic> data = json.decode(response.body);
      print('wtf');
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch notes: ${response.statusCode}');
    }
  }

  
}
