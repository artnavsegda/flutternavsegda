import 'package:flutter/material.dart';
import '../action/action.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    Key? key,
    required this.actionName,
    required this.actionImage,
    required this.actionDate,
  }) : super(key: key);

  final String actionName;
  final String actionImage;
  final String actionDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ActionPage()));
            },
            child: Image.asset(actionImage)),
        Text(actionName),
        Text(actionDate),
      ],
    );
  }
}
