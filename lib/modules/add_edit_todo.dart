// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/helpers/common_helpers.dart';
import 'package:todo/helpers/response_state.dart';
import 'package:todo/helpers/widgets/common_appbar.dart';
import 'package:todo/helpers/widgets/common_button.dart';
import 'package:todo/helpers/widgets/common_dropdown.dart';
import 'package:todo/helpers/widgets/common_textfield.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/providers/todo_notifier.dart';
import 'package:uuid/uuid.dart';

class AddEditTodo extends ConsumerStatefulWidget {
  TodoModel? todoModel;
  AddEditTodo({super.key, this.todoModel});

  @override
  AddEditTodoState createState() => AddEditTodoState();
}

class AddEditTodoState extends ConsumerState<AddEditTodo> {
  bool isAddingTodo = true;
  TextEditingController dueDateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> priorityList = ['Low', 'Medium', "High"];

  String selectedPriority = "Low";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.todoModel == null) {
      isAddingTodo = true;
    } else {
      isAddingTodo = false;
      updateValues();
    }
    super.initState();
  }

  @override
  void dispose() {
    dueDateController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  updateValues() {
    titleController.text = widget.todoModel!.title;
    descriptionController.text = widget.todoModel!.description;
    dueDateController.text = widget.todoModel!.duedate;
    selectedPriority = widget.todoModel!.priority;
  }

  onButtonPressed({required String type, BuildContext? context}) async {
    if (type == "save") {
      if (_formKey.currentState!.validate()) {
        late String id;
        if (isAddingTodo) {
          id = const Uuid().v4();
        } else {
          id = widget.todoModel!.id;
        }

        TodoModel model = TodoModel(
            title: titleController.text,
            description: descriptionController.text,
            duedate: dueDateController.text,
            priority: selectedPriority,
            completed: 0,
            id: id);

        FocusManager.instance.primaryFocus?.unfocus();
        if (isAddingTodo) {
          ref.read(todoNotifierProvider.notifier).addTodo(model);
        } else {
          ref.read(todoNotifierProvider.notifier).updateTodo(model);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseState>(todoNotifierProvider,
        (ResponseState? previous, ResponseState next) {
      if (next.head == "add_todo") {
        if (next.isLoading!) {
          showProgress(context);
        } else if (next.isError! && !next.isLoading!) {
          Navigator.pop(context);
          showMessage(context, next.errorMessage!);
        } else {
          if (next.response == true) {
            showMessage(context, "Todo added!", type: "success");
            Navigator.pop(context);
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context);
          }
        }
      } else if (next.head == "update_todo") {
        if (next.isLoading!) {
          showProgress(context);
        } else if (next.isError! && !next.isLoading!) {
          Navigator.pop(context);
          showMessage(context, next.errorMessage!);
        } else {
          if (next.response == true) {
            showMessage(context, "Todo updated!", type: "success");
            Navigator.pop(context);
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context);
          }
        }
      }
    });
    return Scaffold(
      appBar: CommonAppBar(
        title: "${isAddingTodo ? "Add" : "Edit"} Todo",
        hasBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CommonTextField(
                      label: "Title",
                      controller: titleController,
                      onChanged: (val) {}),
                  CommonTextField(
                      label: "Description",
                      maxLines: 3,
                      controller: descriptionController,
                      onChanged: (val) {}),
                  CommonTextField(
                      label: "Date",
                      controller: dueDateController,
                      isTrailingDatePicker: true,
                      selectedDate: dueDateController.text.isEmpty
                          ? null
                          : dueDateController.text,
                      onChanged: (val) {
                        setState(() {
                          dueDateController.text = dueDateController.text;
                        });
                      }),
                  CommonDropDown(
                      itemsList: priorityList,
                      selectedValue: selectedPriority,
                      onChanged: (val) {
                        setState(() {
                          selectedPriority = val;
                        });
                      },
                      label: "Priority"),
                ])),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonButton(
            containerPadding: const EdgeInsets.only(bottom: 10),
            onButtonPressed: () {
              onButtonPressed(type: "save", context: context);
            },
            label: "SAVE",
          ),
        ],
      ),
    );
  }
}
