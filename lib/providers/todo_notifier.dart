import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo/helpers/response_state.dart';
import 'package:todo/helpers/services/database_service.dart';
import 'package:todo/models/todo_model.dart';
part 'todo_notifier.g.dart';

@riverpod
class TodoNotifier extends _$TodoNotifier {
  DatabaseService databaseService = DatabaseService();

  @override
  ResponseState build() {
    return (ResponseState(isLoading: false, isError: false));
  }

  Future<void> getTodos() async {
    try {
      state = state.copyWith(isLoading: true, head: "todo", isError: false);
      List<TodoModel> list = await databaseService.todos();
      state = state.copyWith(
          isLoading: false, head: "todo", isError: false, response: list);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          head: "todo",
          isError: true,
          errorMessage: e.toString());
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      state = state.copyWith(isLoading: true, head: "add_todo", isError: false);
      await databaseService.insertTodo(todo);
      state = state.copyWith(
          isLoading: false, head: "add_todo", isError: false, response: true);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          head: "add_todo",
          isError: true,
          errorMessage: e.toString());
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      state =
          state.copyWith(isLoading: true, head: "update_todo", isError: false);
      await databaseService.updateTodo(todo);
      state = state.copyWith(
          isLoading: false,
          head: "update_todo",
          isError: false,
          response: true);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          head: "update_todo",
          isError: true,
          errorMessage: e.toString());
    }
  }

  Future<void> deleteTodo(String todoIndex) async {
    try {
      state =
          state.copyWith(isLoading: true, head: "delete_todo", isError: false);
      await databaseService.deleteTodo(todoIndex);
      state = state.copyWith(
          isLoading: false,
          head: "delete_todo",
          isError: false,
          response: true);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          head: "delete_todo",
          isError: true,
          errorMessage: e.toString());
    }
  }
}
