import 'package:flutter/material.dart';

import '../../helpers/style.dart';

class ToDoFormField extends StatelessWidget {
  const ToDoFormField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.maxLines = 1,
    this.onTap,
    this.validator,
  }) : super(key: key);

  final String label;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int maxLines;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(color: klightGray, fontSize: 18)),
        const SizedBox(height: 10),
        TextFormField(
          maxLines: maxLines,
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          readOnly: onTap != null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: kprimarytheme,
            hintStyle: TextStyle(color: klightGray.withOpacity(0.5)),
            suffixIcon: onTap != null
                ? const Icon(Icons.keyboard_arrow_down, color: klightGray)
                : null,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kprimarytheme, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(0))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(0))),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(0))),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(0))),
          ),
        ),
      ],
    );
  }
}
