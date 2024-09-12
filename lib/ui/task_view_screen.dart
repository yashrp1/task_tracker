import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/model/task_model.dart';
import 'package:task_tracker/provider/task_provider.dart';
import 'package:task_tracker/ui/edit_task_screen.dart';

class TaskViewScreen extends StatefulWidget {
  final Task task;

  const TaskViewScreen({super.key, required this.task});

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  bool isComplete = false; // Initialize isComplete with a default value

  @override
  void initState() {
    super.initState();
    isComplete = widget.task.isComplete; // Initialize with the task's completion status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            // Find the latest version of the task in case it's updated
            final currentTask = taskProvider.getTaskById(widget.task.id);

            return ListView(
              children: [
                // Task Name
                const Text(
                  'Task Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currentTask.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Task Description
                const Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currentTask.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Due Date
                const Text(
                  'Due Date:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currentTask.dueDate.toString().split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Task Status
                const Text(
                  'Task Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ToggleButtons(
                  isSelected: [!isComplete, isComplete],
                  onPressed: (int index) {
                    setState(() {
                      isComplete = index == 1; // Update status based on selected index
                      // Update task status using Provider
                      Task updatedTask = currentTask.copyWith(isComplete: isComplete);
                      taskProvider.updateTask(updatedTask);
                    });
                  },
                  selectedColor: Colors.white, // Text color of the selected button
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.purple, // Text color of the unselected buttons
                  selectedBorderColor: Colors.purple, // Border color of the selected button
                  borderColor: Colors.grey, // Border color of the unselected buttons
                  fillColor: Colors.purple.withOpacity(0.9),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Incomplete'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Completed'),
                    ),
                  ], // Background color of the selected button
                ),
                const SizedBox(height: 25),

                // Buttons for Edit and Delete
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => EditTaskScreen(task: currentTask),
                          ));
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (currentTask.id != null) {
                            _confirmDelete(context, currentTask.id!);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper function to confirm before deleting the task
  void _confirmDelete(BuildContext context, int taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete task using Provider
              Provider.of<TaskProvider>(context, listen: false).deleteTask(taskId);
              Navigator.of(context).pop(); // Dismiss dialog after deletion
              Navigator.of(context).pop(); // Pop the TaskViewScreen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
