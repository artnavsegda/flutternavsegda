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
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ActionPage()));
                },
                child: Image.asset(
                  actionImage,
                  fit: BoxFit.cover,
                )),
          ),
          Text(
            actionDate,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          Text(actionName, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
