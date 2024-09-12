import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/model/category_model.dart';
import 'package:task_tracker/model/task_model.dart';
import 'package:task_tracker/provider/task_provider.dart';
import 'package:task_tracker/ui/task_view_screen.dart';
import 'package:task_tracker/ui/add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  String? _selectedCategory; // Store selected category filter
  String _searchQuery = ''; // Store search query for task ID
  final List<String> _categories = [
    'All',
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
      ),
      body: Column(
        children: [
          // Search Bar and Filter Dropdown in a Row (outside the ListView)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by Task Name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    keyboardType: TextInputType.text, // Task ID is numeric
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value; // Update search query
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                // Filter Dropdown
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: (String value) {
                    setState(() {
                      if (value == 'All') {
                        _selectedCategory = null; // Clear filter
                      } else {
                        _selectedCategory = value;
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return _categories.map((String category) {
                      return PopupMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),

          // Show selected filter with a clear option (if a filter is applied)
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Filter: $_selectedCategory'),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null; // Clear filter
                      });
                    },
                    child: const Text('Clear Filter'),
                  ),
                ],
              ),
            ),

          // Expanded Task List
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                // Apply category filter and search query
                List<Task> filteredTasks = taskProvider.tasks.where((task) {
                  // Filter by search query (task ID) and category
                  final matchesSearch = _searchQuery.isEmpty ||
                      task.name.toString().contains(_searchQuery);
                  final matchesCategory = _selectedCategory == null ||
                      task.category == _selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                // Sort tasks by due date
                filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

                if (filteredTasks.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                      child: Text(
                        'No tasks available. Add a task to get started.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    final category = categories.firstWhere(
                      (cat) => cat.name == task.category,
                      orElse: () => Category('Other', Icons.help),
                    );

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Icon(
                            category.icon,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          task.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Status: ',
                                    style: DefaultTextStyle.of(context).style,
                                  ),
                                  TextSpan(
                                    text: task.isComplete
                                        ? 'Completed'
                                        : 'Incomplete',
                                    style: TextStyle(
                                      color: task.isComplete
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // View Task Button
                            IconButton(
                              icon: const Icon(Icons.visibility,
                                  color: Colors.blue),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => TaskViewScreen(task: task),
                                ));
                              },
                            ),
                            // Delete Task Button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _confirmDelete(context, task.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddTaskScreen()));
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add), // Ensures it's circular
      ),
    );
  }

  // Helper function to confirm before deleting
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
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(taskId);
              Navigator.of(context).pop(); // Dismiss dialog after deletion
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
