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
      final addedNoteResponse = await NotesApiService.addNote(newNote);
      final addedNote = addedNoteResponse['note']; // ✅ Extract inner 'note'

      setState(() {
        _notes.add(addedNote);
      });

      _controller.clear();
    } catch (e) {
      print('Failed to add note: $e');
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
                  onDelete: () async {
                    try {
                      final id = note['id'];
                      if (id == null) {
                        print('❌ Note id is missing or null');
                        return;
                      }
                      await NotesApiService.deleteNote(id);

                      setState(() {
                        _notes.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note deleted')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete: $e')),
                      );
                    }
                  },
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
                      FocusScope.of(context).unfocus(); // Dismiss the keyboard

                      _addNote(_controller.text.trim());

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Note added successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
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
