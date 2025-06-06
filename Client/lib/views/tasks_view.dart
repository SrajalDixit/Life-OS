import 'package:flutter/material.dart';
import 'package:life_os/constants.dart';
import 'package:life_os/services.dart/task_api_services.dart';
import 'package:life_os/views/new_task.dart';
import 'package:life_os/widgets/continue_button.dart';
import 'package:life_os/widgets/task_tile.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  List<Map<String, dynamic>> tasks = [];
  Set<String> updatedTaskIds = {};
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final data = await ApiService.fetchTasks();
      setState(() {
        tasks = data
            .map((task) => {
                  'title': task['title'],
                  'is_completed': task['is_completed'],
                  'id': task['id'],
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleTaskCompletion(int index, bool? value) {
    if (value == null) return;

    final taskId = tasks[index]['id'];

    if (taskId != null) {
      setState(() {
        tasks[index]['is_completed'] = value;
        updatedTaskIds.add(taskId);
      });
    } else {}
  }

  Future<void> saveUpdatedTasks() async {
    setState(() => isSaving = true);
    try {
      for (var task in tasks) {
        final taskId = task['id'];
        final isCompleted = task['is_completed'];

        if (updatedTaskIds.contains(taskId)) {
          await ApiService.updateTaskStatus(taskId, isCompleted);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tasks saved successfully")),
      );

      updatedTaskIds.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save tasks")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Tasks",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (tasks.isEmpty)
                const Center(
                  child: Text(
                    'No tasks found',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskTile(
                        title: tasks[index]['title'],
                        completed: tasks[index]['is_completed'],
                        onChanged: (value) =>
                            toggleTaskCompletion(index, value),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),

        // Positioned Save Button
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: SaveButton(
              isSaving: isSaving,
              onPressed: saveUpdatedTasks,
            ),
          ),
        ),
      ],
    ),

   
    floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTask()),
    );
  },
  backgroundColor: MainColor,
  child: const Icon(Icons.add),
),

  );
}
}
