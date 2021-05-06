import 'package:flutter/material.dart';
import 'map.dart';

class VendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Аппараты"),
                Tab(text: "Склад"),
              ],
            ),
            title: Text('Your Name'),
          ),
          body: TabBarView(
            children: [MapPage(), Icon(Icons.directions_car)],
          ),
        ),
      ),
    );
  }
}
