import 'package:flutter/material.dart';

class StoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        title: Text('Primary text'),
        leading: Icon(Icons.label),
        subtitle: Text('Metadata'),
      ),
      Icon(Icons.directions_car),
    ]);
  }
}
