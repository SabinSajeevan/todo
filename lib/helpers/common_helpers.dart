import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final navigatorKey = GlobalKey<NavigatorState>();

const TextStyle titleLabelStyle = TextStyle(
  color: Colors.black87,
  fontSize: 14,
  fontWeight: FontWeight.w900,
);

showLog(String msg) {
  debugPrint(msg);
}

showMessage(BuildContext context, String msg, {String type = "red"}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: type == "success" ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Future<Database> openMyDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'todoDatabase.db');
  const databaseVersion = 1;

  const table = 'Todos';
  const columnId = 'id';
  const columnTitle = 'title';
  const columnDescription = 'description';
  const columnDueDate = 'duedate';
  const columnPriority = 'priority';
  const columnCompleted = 'completed';
  final database = await openDatabase(
    path,
    version: databaseVersion,
    onCreate: (db, version) async {
      db.execute('''CREATE TABLE $table(
            $columnId TEXT PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnDueDate TEXT NOT NULL,
            $columnPriority TEXT NOT NULL,
            $columnCompleted INTEGER NOT NULL)''');
    },
  );
  return database;
}

Future<void> showProgress(BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CupertinoActivityIndicator(radius: 20),
        );
      });
}

showUnAuthorisedPopUp() {
  showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: const Text("Session Expired"),
            content: const Text("Please Log In again"),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          )).then((value) async {});
}

DateTime getDateTimeFromString({required String stringDate}) {
  String date = stringDate.substring(0, 8);
  return DateTime.parse(date);
}

String getDateStringFromListOfInt(List<int> dateList) {
  String dateString = dateList[0].toString() +
      dateList[1].toString().padLeft(2, '0') +
      dateList[2].toString().padLeft(2, '0');
  return dateString;
}
