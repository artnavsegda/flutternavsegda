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
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
              builder: (BuildContext context) => Scaffold(
                    body: Center(
                      child: TextButton(
                        child: Text("Helloaa"),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              body: Center(
                                child: Text("Hello"),
                              ),
                              appBar: AppBar(
                                title: Text("Hello"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    appBar: AppBar(
                      title: Text("Hello"),
                    ),
                  ),
              settings: settings),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
        ),
      ),
    );
  }
}
