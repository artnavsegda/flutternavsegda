import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background task: $task");
    // Your background work here
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ElevatedButton(
              onPressed: () {
                Workmanager().registerOneOffTask("task-id", "simpleTask");
              },
              child: Text('One off'),
            ),
            ElevatedButton(
              onPressed: () {
                Workmanager().registerPeriodicTask(
                  "repeat-id",
                  "repeatingTask",
                  frequency: Duration(minutes: 15),
                );
              },
              child: Text('Regular'),
            ),
            ElevatedButton(
              onPressed: () {
                //
              },
              child: Text('Request location permission'),
            ),
            ElevatedButton(
              onPressed: () {
                //
              },
              child: Text('Show notification'),
            ),
          ],
        ),
      ),
    );
  }
}
