class Task {
  final int? id;
  final String name;
  final String description;
  final DateTime dueDate;
  final bool isComplete;
  final String category; // Add category field

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.isComplete,
    required this.category, // Update constructor
  });

  // Convert Task to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isComplete': isComplete ? 1 : 0,
      'category': category, // Add category to map
    };
  }

  // Create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isComplete: map['isComplete'] == 1,
      category: map['category'], // Add category from map
    );
  }

  // Copy method to create a new Task with updated properties
  Task copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? dueDate,
    bool? isComplete,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isComplete: isComplete ?? this.isComplete,
      category: category ?? this.category,
    );
  }
}
