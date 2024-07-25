import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:todo/constants/color_path.dart';

// ignore: must_be_immutable
class CommonTextField extends StatefulWidget {
  @override
  State<CommonTextField> createState() => _CommonTextFieldState();

  CommonTextField(
      {super.key,
      this.hasLeading = false,
      this.leadingColor,
      this.leadingIconImage,
      this.label,
      this.hasTrailing = false,
      this.isTrailingDatePicker = false,
      this.isTrailingTimePicker = false,
      this.isOptional = false,
      this.isPhone = false,
      this.isEmail = false,
      required this.controller,
      this.isReadOnly = false,
      this.hintText,
      this.verticalPadding,
      this.isNumber = false,
      this.removeBorder = true,
      this.isTextCapital = false,
      this.isEnabled = true,
      this.isDOB = false,
      this.isStartDate = false,
      required this.onChanged,
      this.isAlphaNumeric = false,
      this.isNoNegative = false,
      this.preventCopy = false,
      this.isTrailingObscure = false,
      this.selectedDate,
      this.selectedTime,
      this.prefixIcon,
      this.suffix,
      this.maxLines = 1});

  final bool? hasLeading;
  final Color? leadingColor;
  final Widget? suffix;
  final String? leadingIconImage;
  final String? label;
  final bool? hasTrailing;
  final bool? isTrailingDatePicker;
  final bool? isTrailingTimePicker;
  final bool? isTrailingObscure;
  final bool? isAlphaNumeric;
  final bool? isOptional;
  final bool? isReadOnly;
  final bool? isPhone;
  final bool? isEmail;
  TextEditingController controller;
  final String? hintText;
  final double? verticalPadding;
  final bool? isNumber;
  final bool? removeBorder;
  final bool? isTextCapital;
  final bool? isEnabled;
  final bool? isDOB;
  final bool? isStartDate;
  final bool? isNoNegative;
  final ValueChanged onChanged;
  final bool? preventCopy;
  final int? maxLines;
  final String? selectedDate;
  final String? selectedTime;
  final Widget? prefixIcon;
}

class _CommonTextFieldState extends State<CommonTextField> {
  DateTime today = DateTime.now();
  late DateTime selectedDate =
      DateTime(today.year - 18, today.month, today.day);
  bool isShowPassword = false;
  int hour = TimeOfDay.now().hour;
  int minute = TimeOfDay.now().minute;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.isDOB!
            ? selectedDate
            : widget.selectedDate != null
                ? DateTime.parse(widget.selectedDate!)
                : today,
        firstDate: widget.isStartDate! ? today : DateTime(today.year - 100),
        lastDate: widget.isDOB!
            ? DateTime(today.year - 18, today.month, today.day)
            : DateTime(today.year + 100));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        widget.onChanged(widget.controller.text);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (widget.selectedTime != null) {
      List<String> split = widget.selectedTime!.split(":");
      hour = int.parse(split[0]);
      minute = int.parse(split[1]);
    }
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        widget.controller.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        widget.onChanged(widget.controller.text);
      });
    }
  }

  String? validateMobile(String? value) {
    const String pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return '${widget.label} cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.label != null
              ? Text(
                  widget.label!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: TodoColors.lightWhiteAlternativeColor),
                )
              : Container(),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 20,
                      spreadRadius: 0,
                      color: Colors.black.withOpacity(0.15))
                ]),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              !widget.hasLeading!
                  ? Container()
                  : Container(
                      width: 55,
                      height: 55,
                      margin: const EdgeInsets.only(right: 15.0),
                      padding: const EdgeInsets.all(17.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.leadingColor,
                      ),
                      child: Image.asset(
                        "assets/images/${widget.leadingIconImage}",
                        height: 30,
                        width: 30,
                      ),
                    ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: widget.maxLines,
                  onChanged: (val) {
                    widget.onChanged(val.toString());
                  },
                  validator: (value) {
                    return widget.isOptional!
                        ? null
                        : widget.isEmail!
                            ? validateEmail(value)
                            : widget.isPhone!
                                ? validateMobile(value)
                                : validateName(value);
                  },
                  textCapitalization: widget.isTextCapital!
                      ? TextCapitalization.words
                      : TextCapitalization.none,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  enabled: widget.isEnabled!,
                  readOnly: widget.isReadOnly! ||
                          widget.isTrailingDatePicker! ||
                          widget.isTrailingTimePicker!
                      ? true
                      : false,
                  onTap: widget.isTrailingDatePicker!
                      ? () {
                          _selectDate(context);
                        }
                      : widget.isTrailingTimePicker!
                          ? () {
                              _selectTime(context);
                            }
                          : null,
                  obscureText: widget.hasTrailing! &&
                          widget.isTrailingObscure! &&
                          !isShowPassword
                      ? true
                      : false,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: TodoColors.greyColor.withOpacity(1))),
                    contentPadding: widget.verticalPadding != null
                        ? EdgeInsets.symmetric(
                            vertical: widget.verticalPadding!)
                        : widget.hasLeading!
                            ? null
                            : const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 15),
                    hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                    prefixIcon: widget.prefixIcon,
                    suffix: widget.suffix,
                    prefixIconColor: TodoColors.greyColor,
                    suffixIcon: !widget.hasTrailing!
                        ? null
                        : widget.isTrailingDatePicker!
                            ? IconButton(
                                onPressed: () {
                                  _selectDate(context);
                                },
                                icon: Image.asset('assets/images/calender.png'))
                            : widget.isTrailingObscure!
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isShowPassword = !isShowPassword;
                                      });
                                    },
                                    icon: Icon(isShowPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility))
                                : IconButton(
                                    onPressed: () {},
                                    icon: Image.asset(
                                        'assets/images/add_person.png')),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    widget.isPhone! || widget.isNumber!
                        ? widget.isNoNegative!
                            ? FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'))
                            : FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9-+]'))
                        : widget.isAlphaNumeric!
                            ? FilteringTextInputFormatter.allow(
                                RegExp("[0-9a-zA-Z ]"))
                            : FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  keyboardType: widget.isPhone! || widget.isNumber!
                      ? TextInputType.phone
                      : widget.isEmail!
                          ? TextInputType.emailAddress
                          : TextInputType.text,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
