import 'package:flutter/material.dart';

class CommonAlertDialog extends StatefulWidget {
  final String? content;
  final Widget? body;
  final String? confirmText;
  final String? cancelText;

  const CommonAlertDialog(
      {super.key, this.content, this.body, this.confirmText, this.cancelText});

  @override
  State<CommonAlertDialog> createState() => _CommonAlertDialogState();
}

class _CommonAlertDialogState extends State<CommonAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: const Text("CONFIRM"),
      content: widget.body ?? Text(widget.content!),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: <Widget>[
        TextButton(
          child: Text(widget.confirmText ?? 'YES'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child: Text(widget.confirmText ?? "NO"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}
