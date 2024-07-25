class TodoModel {
  final String id;
  final String title;
  final String description;
  final String duedate;
  final String priority;
  final int completed;

  TodoModel({
    required this.title,
    required this.description,
    required this.duedate,
    required this.priority,
    required this.completed,
    required this.id,
  });

  TodoModel copyWith(
      {String? id,
      String? title,
      String? description,
      String? dueDate,
      String? priority,
      int? completed}) {
    return TodoModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        duedate: dueDate ?? duedate,
        priority: priority ?? this.priority,
        completed: completed ?? this.completed);
  }

  // Convert a TodoModel into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duedate': duedate,
      'priority': priority,
      'completed': completed
    };
  }

  // Implement toString to make it easier to see information about
  // each TodoModel when using the print statement.
  @override
  String toString() {
    return 'TodoModel{id: $id, title: $title, description: $description,duedate: $duedate, priority: $priority, completed: $completed}';
  }
}
