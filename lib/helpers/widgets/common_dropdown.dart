import 'package:flutter/material.dart';
import 'package:todo/constants/color_path.dart';

class CommonDropDown extends StatefulWidget {
  @override
  State<CommonDropDown> createState() => _CommonDropDownState();

  final String? selectedValue;
  final List<String> itemsList;
  final Function(dynamic value) onChanged;
  final String label;
  final bool? isOptional;
  final Icon? prefixIcon;

  const CommonDropDown({
    this.selectedValue,
    required this.itemsList,
    required this.onChanged,
    required this.label,
    this.isOptional = false,
    super.key,
    this.prefixIcon,
  });
}

class _CommonDropDownState extends State<CommonDropDown> {
  String? validate(String value) {
    if (value.isEmpty || value == 'null') {
      return '${widget.label} cannot be empty';
    } else {
      return null;
    }
  }

  String? selectedValue;
  @override
  void initState() {
    if (widget.selectedValue != null) {
      setState(() {
        selectedValue = widget.selectedValue;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            widget.label,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: TodoColors.lightWhiteAlternativeColor),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 20,
                      spreadRadius: 0,
                      color: Colors.black.withOpacity(0.15))
                ]),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return widget.isOptional! ? null : validate(value.toString());
              },
              value: widget.selectedValue,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(color: TodoColors.greyColor.withOpacity(1))),
                prefixIcon: widget.prefixIcon,
                prefixIconColor: TodoColors.greyColor,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_outlined),
              items: widget.itemsList
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
                widget.onChanged(value);
              },
            ),
          ),
        ]));
  }
}
