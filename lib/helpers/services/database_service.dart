import 'package:sqflite/sqflite.dart';
import 'package:todo/helpers/common_helpers.dart';
import 'package:todo/models/todo_model.dart';

class DatabaseService {
  Future<void> insertTodo(TodoModel todo) async {
    // Get a reference to the database.
    final db = await openMyDatabase();

    // Insert the Todo into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Todo is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'Todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the Todos from the Todos table.
  Future<List<TodoModel>> todos() async {
    // Get a reference to the database.
    final db = await openMyDatabase();

    // Query the table for all the Todos.
    final List<Map<String, Object?>> todoMaps = await db.query('Todos');

    // Convert the list of each Todo's fields into a list of `Todo` objects.
    return [
      for (final {
            'id': id as String,
            'title': title as String,
            'description': description as String,
            'duedate': duedate as String,
            'priority': priority as String,
            'completed': completed as int,
          } in todoMaps)
        TodoModel(
            id: id,
            title: title,
            description: description,
            duedate: duedate,
            priority: priority,
            completed: completed),
    ];
  }

  Future<void> updateTodo(TodoModel todo) async {
    // Get a reference to the database.
    final db = await openMyDatabase();

    // Update the given Todo.
    await db.update(
      'Todos',
      todo.toMap(),
      // Ensure that the Todo has a matching id.
      where: 'id = ?',
      // Pass the Todo's id as a whereArg to prevent SQL injection.
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(String id) async {
    // Get a reference to the database.
    final db = await openMyDatabase();

    // Remove the Todo from the database.
    await db.delete(
      'Todos',
      // Use a `where` clause to delete a specific Todo.
      where: 'id = ?',
      // Pass the Todo's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
