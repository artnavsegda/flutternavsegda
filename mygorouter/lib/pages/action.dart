import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Action extends StatelessWidget {
  const Action({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$id'),
      ),
    );
  }
}
