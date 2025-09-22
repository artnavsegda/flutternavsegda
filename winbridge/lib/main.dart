import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowsSingleInstance.ensureSingleInstance(args, "custom_identifier",
      onSecondWindow: (args) {
    print(args);
  }, bringWindowToFront: true);

  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setPreventClose(true);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  launchExe() async {
    final exitCode = calloc<DWORD>();
    final si = calloc<STARTUPINFO>();
    ZeroMemory(si, sizeOf<STARTUPINFO>());
    final pi = calloc<PROCESS_INFORMATION>();
    ZeroMemory(pi, sizeOf<PROCESS_INFORMATION>());

    try {
/*       ShellExecute(0, TEXT('open'), TEXT('notepad.exe'), nullptr, nullptr,
          SHOW_WINDOW_CMD.SW_SHOW); */
      final retval = CreateProcess(
        nullptr,
        TEXT('C:\\test\\testApp.exe'),
        nullptr,
        nullptr,
        FALSE,
        0,
        nullptr,
        nullptr,
        si,
        pi,
      );
      print("retVal $retval");
      print("handle ${pi.ref.hProcess}");
      WaitForSingleObject(pi.ref.hProcess, INFINITE);
      GetExitCodeProcess(pi.ref.hProcess, exitCode);
      //await Future.delayed(const Duration(milliseconds: 5000));
      print("${exitCode.value}");
      return true;
    } catch (_) {
      return false;
    }
  }

  launchExe2() async {
    final exitCode = calloc<DWORD>();
    final shExecInfo = calloc<SHELLEXECUTEINFO>()
      ..ref.cbSize = sizeOf<SHELLEXECUTEINFO>()
      ..ref.lpFile = TEXT('C:\\test\\testApp.exe')
      ..ref.hProcess = 123
      ..ref.nShow = SHOW_WINDOW_CMD.SW_SHOW;

    try {
/*       ShellExecute(0, TEXT('open'), TEXT('notepad.exe'), nullptr, nullptr,
          SHOW_WINDOW_CMD.SW_SHOW); */
      final retval = ShellExecuteEx(shExecInfo);
      print("retVal $retval");
      print("handle ${shExecInfo.ref.hProcess}");
      WaitForSingleObject(shExecInfo.ref.hProcess, INFINITE);
      GetExitCodeProcess(shExecInfo.ref.hProcess, exitCode);
      await Future.delayed(const Duration(milliseconds: 5000));
      print("${exitCode.value}");
      return true;
    } catch (_) {
      return false;
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchExe();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
