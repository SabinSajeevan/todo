import 'package:flutter/material.dart';
import 'package:todo/constants/color_path.dart';
import 'package:todo/helpers/widgets/common_round_button.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.hasIcons = false,
    this.hasBackArrow = true,
    this.isCenterTitle = true,
    required this.title,
    this.height = kToolbarHeight,
    this.actions,
  });

  final bool? hasIcons;
  final bool? hasBackArrow;
  final String title;
  final double? height;
  final bool isCenterTitle;
  final List<Widget>? actions;

  @override
  CommonAppBarState createState() => CommonAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height!);
}

class CommonAppBarState extends State<CommonAppBar> {
  onButtonPressed({required BuildContext context, required String type}) async {
    if (type == "back") {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(widget.title),
        centerTitle: widget.isCenterTitle,
        backgroundColor: TodoColors.secondaryDarkColor,
        titleTextStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold, color: TodoColors.lightWhiteColor),
        elevation: 0.0,
        surfaceTintColor: TodoColors.lightWhiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: widget.hasBackArrow!,
        leading: widget.hasBackArrow!
            ? CommonRoundButton(
                onButtonPressed: () {
                  onButtonPressed(context: context, type: "back");
                },
                icon: const Icon(Icons.arrow_back))
            : Container(),
        actions: !widget.hasIcons! ? null : widget.actions);
  }
}
