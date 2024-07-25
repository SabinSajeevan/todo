import 'package:flutter/material.dart';

class CommonRoundButton extends StatelessWidget {
  const CommonRoundButton({
    super.key,
    required this.onButtonPressed,
    this.icon,
    this.padding = 14.0,
    this.verticalPadding = 10.0,
    this.horizontalPadding = 10.0,
  });

  final VoidCallback onButtonPressed;
  final Icon? icon;
  final double? padding;
  final double? verticalPadding;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding!, vertical: verticalPadding!),
      child: Container(
        alignment: Alignment.center,
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
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              onButtonPressed();
            },
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
