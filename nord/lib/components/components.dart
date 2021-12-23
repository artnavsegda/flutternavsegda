import 'package:flutter/material.dart';

class NordCheckboxTile extends StatelessWidget {
  const NordCheckboxTile({
    Key? key,
    required this.title,
  }) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(child: Image.asset('assets/Icon-Checkbox-Checked.png')),
        SizedBox(width: 38),
        Flexible(child: title)
      ],
    );
  }
}
