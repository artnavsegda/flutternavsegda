import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'map.dart';
import 'storage.dart';

class VendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Выход'),
                      onTap: () {},
                    ),
                  ),
                ],
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: "Аппараты"),
                Tab(text: "Склад"),
              ],
            ),
            title: Consumer<AppModel>(
              builder: (context, appState, child) {
                return Text(appState.userName);
              },
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [MapPage(), StoragePage()],
          ),
        ),
      ),
    );
  }
}
