import 'package:flutter/material.dart';
import 'package:todo/constants/color_path.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.onButtonPressed,
      this.label,
      this.hasIcon = false,
      this.labelWithIcon,
      this.padding = 14.0,
      this.verticalPadding = 5.0,
      this.fontSize = 16.0,
      this.hasBorder = false,
      this.textColor = Colors.white,
      this.horizontalPadding = 20.0,
      this.containerPadding,
      this.radius = 8,
      this.backgroundColor = TodoColors.primaryColor});

  final VoidCallback onButtonPressed;
  final String? label;
  final bool? hasIcon;
  final Widget? labelWithIcon;
  final double? padding;
  final Color? backgroundColor;
  final double? verticalPadding;
  final double? fontSize;
  final bool? hasBorder;
  final Color? textColor;
  final double? radius;
  final double? horizontalPadding;
  final EdgeInsets? containerPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: containerPadding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: containerPadding != null ? Colors.transparent : Colors.white,
          boxShadow: containerPadding != null
              ? []
              : [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                      color: Colors.black.withOpacity(0.25))
                ]),
      child: ElevatedButton(
        onPressed: onButtonPressed,
        style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    hasBorder! ? Colors.white : backgroundColor),
                overlayColor: WidgetStateProperty.all(
                    hasBorder! ? Colors.grey.shade100 : null),
                shape: !hasBorder!
                    ? WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius!),
                      ))
                    : WidgetStateProperty.all(RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(4.0))))
            .copyWith(
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                    horizontal: horizontalPadding!,
                    vertical: verticalPadding!))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padding!),
          child: hasIcon!
              ? labelWithIcon
              : Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: hasBorder! ? Colors.grey.shade800 : textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
