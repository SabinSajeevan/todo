import 'package:flutter/material.dart';
import 'package:todo/constants/route_path.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/modules/add_edit_todo.dart';
import 'package:todo/modules/home.dart';
import 'package:todo/modules/register.dart';
import 'package:todo/modules/sign_in.dart';
import 'package:todo/modules/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return switch (settings.name) {
      splashScreen => MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        ),
      signInScreen => MaterialPageRoute(
          builder: (_) => SignIn(),
        ),
      registerScreen => MaterialPageRoute(
          builder: (_) => Register(),
        ),
      homeScreen => MaterialPageRoute(
          builder: (_) => const Home(),
        ),
      addEditTodoScreen => MaterialPageRoute(
          builder: (_) => AddEditTodo(
              todoModel: settings.arguments != null
                  ? settings.arguments as TodoModel
                  : null)),
      _ => MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route found for the name $settings.name',
              ),
            ),
          ),
        )
    };
  }
}
