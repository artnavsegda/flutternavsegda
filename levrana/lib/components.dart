import 'package:flutter/material.dart';

class LevranaCheckbox extends StatelessWidget {
  const LevranaCheckbox(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return value
        ? Image.asset('assets/checkbox/Checked=Yes, Big=No, Partial=No.png')
        : Image.asset('assets/checkbox/Checked=No, Big=No, Partial=No.png');
  }
}
