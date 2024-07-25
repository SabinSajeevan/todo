import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/constants/color_path.dart';
import 'package:todo/constants/route_path.dart';
import 'package:todo/helpers/common_helpers.dart';
import 'package:todo/helpers/response_state.dart';
import 'package:todo/helpers/widgets/common_alert_dialog.dart';
import 'package:todo/helpers/widgets/common_appbar.dart';
import 'package:todo/helpers/widgets/common_button.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/providers/todo_notifier.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  List<TodoModel> todoList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoNotifierProvider.notifier).getTodos();
    });
  }

  onButtonPressed(
      {required String type, BuildContext? context, TodoModel? model}) async {
    if (type == "logout") {
      const dialog = CommonAlertDialog(content: "Are you sure to logout?");
      showDialog(context: context!, builder: (BuildContext context) => dialog)
          .then((value) async {
        if (value != null && value) {
          showMessage(context, "Logout Successfully!");
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, signInScreen);
        }
      });
    } else if (type == "add" || type == "edit") {
      var result = await Navigator.pushNamed(context!, addEditTodoScreen,
          arguments: model);
      if (result != null) {
        if (result == true) {
          ref.read(todoNotifierProvider.notifier).getTodos();
        }
      }
    }
  }

  updateValues(List<TodoModel> list) {
    setState(() {
      todoList = list;
    });
  }

  updateTodo(TodoModel model, bool completed, int index) {
    ref
        .read(todoNotifierProvider.notifier)
        .updateTodo(model.copyWith(completed: completed ? 1 : 0));
  }

  deleteTodo(int index) {
    ref.read(todoNotifierProvider.notifier).deleteTodo(todoList[index].id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseState>(todoNotifierProvider,
        (ResponseState? previous, ResponseState next) {
      if (next.head == "todo") {
        if (next.isLoading!) {
          showProgress(context);
        } else if (next.isError! && !next.isLoading!) {
          Navigator.pop(context);
          showMessage(context, next.errorMessage!);
        } else {
          updateValues(next.response);
          Navigator.pop(context);
        }
      } else if (next.head == "update_todo") {
        if (!next.isLoading! && !next.isError! && next.response) {
          ref.read(todoNotifierProvider.notifier).getTodos();
        }
      } else if (next.head == "delete_todo") {
        if (!next.isLoading! && !next.isError! && next.response) {
          ref.read(todoNotifierProvider.notifier).getTodos();
        }
      }
    });
    return Scaffold(
      appBar: CommonAppBar(
        title: "Todos",
        hasBackArrow: false,
        hasIcons: true,
        isCenterTitle: false,
        actions: [
          PopupMenuButton(
              child: Container(
                margin: const EdgeInsets.only(right: 10, left: 5),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 20,
                          spreadRadius: 0,
                          color: Colors.black.withOpacity(0.15))
                    ]),
                child: const Icon(Icons.person_outline),
              ),
              onSelected: (value) {
                if (value == "logout") {
                  onButtonPressed(type: "logout", context: context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: "logout",
                      child: Row(
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ])
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Your Todos",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: TodoColors.lightWhiteColor),
                  )),
                  CommonButton(
                    padding: 5,
                    verticalPadding: 5,
                    containerPadding: EdgeInsets.zero,
                    onButtonPressed: () {
                      onButtonPressed(type: "add", context: context);
                    },
                    label: "Add New",
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todoList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                          onButtonPressed(
                              type: "edit",
                              context: context,
                              model: todoList[index]);
                        },
                        child: ListTile(
                          title: Text(todoList[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w500)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, bottom: 10),
                                child: Text(
                                  todoList[index].description,
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: todoList[index].priority == "Low"
                                          ? Colors.green
                                          : todoList[index].priority == "Medium"
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: todoList[index].priority == "Low"
                                          ? Colors.green
                                          : todoList[index].priority == "Medium"
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        "Due Date : ${todoList[index].duedate}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        deleteTodo(index);
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: TodoColors
                                                    .backgroundDarkColor),
                                          ),
                                          Icon(
                                            Icons.delete_outline_outlined,
                                            color:
                                                TodoColors.backgroundDarkColor,
                                            size: 20,
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ],
                          ),
                          trailing: Checkbox.adaptive(
                            onChanged: (value) {
                              updateTodo(todoList[index], value!, index);
                            },
                            value: todoList[index].completed == 1,
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
