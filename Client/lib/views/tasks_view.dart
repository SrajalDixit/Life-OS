import 'package:flutter/material.dart';
import 'package:life_os/services.dart/task_api_services.dart';
import 'package:life_os/widgets/task_tile.dart';


class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

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
                  'completed': task['is_completed'], // fix here
                  '_id': task['_id'],
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
    setState(() {
      tasks[index]['completed'] = value;
    });
    // TODO: Add API update call here later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
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
                      completed: tasks[index]['completed'],
                      onChanged: (value) => toggleTaskCompletion(index, value),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
