import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(almanacState: AlmanacState(prefs)));
}

class AlmanacState extends ChangeNotifier {
  final SharedPreferences prefs;

  AlmanacState(this.prefs) {}
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.almanacState,
  }) : super(key: key);

  final AlmanacState almanacState;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlmanacState>(
      lazy: false,
      create: (context) => almanacState,
      child: MaterialApp(
        title: 'Almanac',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? activeDir;
  String activeAirport = 'BIAR_AKUREYRI';

  @override
  Widget build(BuildContext context) {
    if (activeDir != null) {
      return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 200.0,
            leading: TextButton(
              child: Text(
                'Choose $activeAirport',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        child: Container(
                          width: 300,
                          height: 300,
                          child: FutureBuilder<List<FileSystemEntity>>(
                            future: Directory(activeDir!).list().toList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView(
                                  children: [
                                    ...snapshot.data!.map((e) => ListTile(
                                          title: Text(basename(e.path)),
                                          onTap: () {
                                            setState(() {
                                              activeAirport = basename(e.path);
                                            });
                                            Navigator.pop(context);
                                          },
                                        )),
                                  ],
                                );
                              } else
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                            },
                          ),
                        ),
                      )),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'TAXI'),
                Tab(text: 'SID'),
                Tab(text: 'STAR'),
                Tab(text: 'APP'),
                Tab(text: 'GEN'),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: () async {
                  String? result = await FilePicker.platform.getDirectoryPath();
                  if (result != null) {
                    setState(() {
                      activeDir = result;
                    });
                  }
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              AlmanacPage(path: activeDir! + '/' + activeAirport + '/TAXI'),
              AlmanacPage(path: activeDir! + '/' + activeAirport + '/SID'),
              AlmanacPage(path: activeDir! + '/' + activeAirport + '/STAR'),
              AlmanacPage(path: activeDir! + '/' + activeAirport + '/APP'),
              AlmanacPage(path: activeDir! + '/' + activeAirport + '/GEN'),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: TextButton(
            child: Text('Select DB dir'),
            onPressed: () async {
              String? result = await FilePicker.platform.getDirectoryPath();
              if (result != null) {
                setState(() {
                  activeDir = result;
                });
              }
            },
          ),
        ),
      );
    }
  }
}

class AlmanacPage extends StatefulWidget {
  const AlmanacPage({
    Key? key,
    required this.path,
  }) : super(key: key);

  final String path;

  @override
  State<AlmanacPage> createState() => _AlmanacPageState();
}

class _AlmanacPageState extends State<AlmanacPage> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: Directory(widget.path).list().toList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              SizedBox(
                width: 300,
                child: ListView(
                  children: [
                    ...snapshot.data!.map(
                      (e) => ListTile(
                        onTap: () {
                          setState(() {
                            selected = snapshot.data!.indexOf(e);
                          });
                        },
                        title: Text(basename(e.path)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: selected != null
                    ? SfPdfViewer.file(File(snapshot.data![selected!].path))
                    : SizedBox.expand(),
              ),
            ],
          );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
