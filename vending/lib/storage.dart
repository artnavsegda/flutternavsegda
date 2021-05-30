import 'package:flutter/material.dart';

class StoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        title: Text('Primary text'),
        leading: Icon(Icons.directions_car),
        subtitle: Text('Metadata'),
      ),
      ListTile(
        title: Text('Primary text'),
        leading: Icon(Icons.directions_car),
        subtitle: Text('Metadata'),
      ),
      ListTile(
        title: Text('Primary text'),
        leading: Icon(Icons.directions_car),
        subtitle: Text('Metadata'),
      ),
    ]);
  }
}
