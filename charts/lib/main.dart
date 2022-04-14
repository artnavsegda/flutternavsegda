import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await WindowManager.instance.setFullScreen(true);
  });
  runApp(MyApp(almanacState: AlmanacState(prefs)));
}

class AlmanacState extends ChangeNotifier {
  final SharedPreferences prefs;
  String? _activeDir;
  String? _activeAirport;
  ThemeMode themeMode = ThemeMode.light;

  AlmanacState(this.prefs) {
    activeDir = prefs.getString('activeDir');
    activeAirport = prefs.getString('activeAirport');
  }

  String? get activeDir => _activeDir;
  set activeDir(String? newDir) {
    if (newDir != null) {
      _activeDir = newDir;
      prefs.setString('activeDir', newDir);
      notifyListeners();
    }
  }

  String? get activeAirport => _activeAirport;
  set activeAirport(String? newAirport) {
    if (newAirport != null) {
      _activeAirport = newAirport;
      prefs.setString('activeAirport', newAirport);
      notifyListeners();
    }
  }

  void flipMode() {
    if (themeMode == ThemeMode.light)
      themeMode = ThemeMode.dark;
    else
      themeMode = ThemeMode.light;
    notifyListeners();
  }
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
      child: Consumer<AlmanacState>(builder: (context, model, child) {
        return MaterialApp(
          themeMode: model.themeMode,
          title: 'Charts',
/*         theme: ThemeData(
              primarySwatch: Colors.indigo,
            ), */
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            /* dark theme settings */
          ),
          home: MainPage(),
        );
      }),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AlmanacState>(
      builder: (context, model, child) {
        if (model.activeDir != null) {
          return DefaultTabController(
            length: 6,
            child: Scaffold(
              appBar: AppBar(
                title: model.activeAirport != null
                    ? Text('${model.activeAirport!.replaceAll('_', ' ')}')
                    : null,
                //leadingWidth: 200.0,
                leading: IconButton(
                  icon: Icon(Icons.airplanemode_active),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: Container(
                              width: 400,
                              height: 600,
                              child: FutureBuilder<List<FileSystemEntity>>(
                                future:
                                    Directory(model.activeDir!).list().toList(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView(
                                      children: [
                                        ...snapshot.data!.map((e) => ListTile(
                                              title: Text(basename(
                                                  e.path.replaceAll('_', ' '))),
                                              onTap: () {
                                                model.activeAirport =
                                                    basename(e.path);
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
                    Tab(text: 'MINIMA'),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.brightness_medium),
                    onPressed: () async {
                      model.flipMode();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.folder),
                    onPressed: () async {
                      String? result =
                          await FilePicker.platform.getDirectoryPath();
                      if (result != null) {
                        model.activeDir = result;
                      }
                    },
                  ),
                  IconButton(
                      onPressed: () async {
                        if (await WindowManager.instance.isFullScreen())
                          WindowManager.instance.setFullScreen(false);
                        else
                          WindowManager.instance.setFullScreen(true);
                      },
                      icon: Icon(Icons.fullscreen)),
                  IconButton(
                      onPressed: () {
                        exit(0);
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              body: model.activeAirport == null
                  ? Center(
                      child: Text('Select airport'),
                    )
                  : TabBarView(
                      children: [
                        AlmanacPage(
                            path: model.activeDir! +
                                '/' +
                                model.activeAirport! +
                                '/TAXI'),
                        AlmanacPage(
                            path: model.activeDir! +
                                '/' +
                                model.activeAirport! +
                                '/SID'),
                        AlmanacPage(
                            path: model.activeDir! +
                                '/' +
                                model.activeAirport! +
                                '/STAR'),
                        AlmanacPage(
                            path: model.activeDir! +
                                '/' +
                                model.activeAirport! +
                                '/APP'),
                        AlmanacPage(
                            path: model.activeDir! +
                                '/' +
                                model.activeAirport! +
                                '/GEN'),
                        AlmanacPage(
                            path: model.activeDir! +
                                '/' +
                                model.activeAirport! +
                                '/MINIMA'),
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
                    model.activeDir = result;
                  }
                },
              ),
            ),
          );
        }
      },
    );
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
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: Directory(widget.path).list().toList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> docList = snapshot.data!
              .map(
                (e) {
                  return e.path.split('.')[0];
                },
              )
              .toSet()
              .toList();

          String suffix = '.pdf';
          if (context.read<AlmanacState>().themeMode == ThemeMode.dark)
            suffix = '.night.pdf';

          return Row(
            children: [
              SizedBox(
                width: 300,
                child: ListView(
                  children: [
                    ...docList.map(
                      (e) => ListTile(
                        selected: docList.indexOf(e) == selected,
                        onTap: () {
                          setState(() {
                            selected = docList.indexOf(e);
                          });
                        },
                        title: Text(basename(e)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: selected != null
                    ? SfPdfViewer.file(File(docList[selected] + suffix))
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
