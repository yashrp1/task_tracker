import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/model/task_model.dart';
import 'package:task_tracker/provider/task_provider.dart';
import 'package:task_tracker/ui/widgets/custom_dropdown_field.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker/ui/widgets/custom_text_area_field.dart';
import 'package:task_tracker/ui/widgets/custom_text_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _dueDate;
  String _selectedCategory = 'Work'; // Default category

  final List<String> _categories = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize any required state
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate); // Format the date
      });
    }
  }

  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 5),
            child: Text(
              "Date",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16.0),
                  hintText: 'Select Date',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                readOnly: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Date is required'
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                title: 'Task Name',
                hintText: 'Enter task name',
                controller: _nameController,
                isRequired: true,
              ),
              CustomTextAreaFormField(
                title: 'Description',
                hintText: 'Enter description',
                controller: _descriptionController,
                isRequired: true,
              ),
              _buildDateField(context),
              CustomDropdownField(
                label: 'Category',
                selectedValue: _selectedCategory,
                items: _categories,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                child: const Text('Add Task'),
                onPressed: () {
                  if (_formKey.currentState!.validate() && _dueDate != null) {
                    final newTask = Task(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      dueDate: _dueDate!,
                      isComplete: false,
                      category: _selectedCategory,
                    );
                    Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
