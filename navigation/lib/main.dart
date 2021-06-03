import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute<void>(
                builder: (BuildContext context) => Scaffold(
                      body: Center(
                        child: TextButton(
                          child: Text("Helloaa"),
                          onPressed: () {
                            print("Click");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Scaffold(
                                      body: Center(
                                        child: Text("Hello"),
                                      ),
                                      appBar: AppBar(
                                        title: Text("Hello"),
                                      ),
                                    )));
                          },
                        ),
                      ),
                      appBar: AppBar(
                        title: Text("Hello"),
                      ),
                    ),
                settings: settings);
          },
        ), //Center(child: Text("Hello")),
        bottomNavigationBar: Text("Hello"),
      ),
    );
  }
}
