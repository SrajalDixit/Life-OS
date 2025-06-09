import 'package:flutter/material.dart';
import 'package:life_os/constants.dart';
import 'package:life_os/services.dart/notes_api_services.dart';
import 'package:life_os/widgets/note_tile.dart'; // Make sure you create this

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final fetchedNotes = await NotesApiService.fetchNotes();
      setState(() {
        _notes = fetchedNotes;
      });
    } catch (e) {
      print('the problem is in _loadnotes: $e');
    }
  }

  Future<void> _addNote(String text) async {
  final newNote = {
    'text': text,
    'sentiment': 'neutral',
    'tags': ['General'],
  };

  try {
    final addedNote = await NotesApiService.addNote(newNote);
    setState(() {
      _notes.add(addedNote); // Update UI with saved note from backend
    });
    _controller.clear();
  } catch (e) {
    print('Failed to add note: $e');
    // Optionally show a snackbar or dialog
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return NoteTile(
                  text: note['text'],
                  sentiment: note['sentiment'],
                  tags: List<String>.from(note['tags']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Write your note...",
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: MainColor),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _addNote(_controller.text.trim());
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
