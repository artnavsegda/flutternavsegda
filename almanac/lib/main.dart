import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 200.0,
          leading: TextButton(
            child: Text(
              'Choose',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: Container(
                        width: 300,
                        height: 300,
                        child: FutureBuilder<List<FileSystemEntity>>(
                          future: Directory('/EFF_charts_2202').list().toList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                children: [
                                  ...snapshot.data!.map((e) => ListTile(
                                        title: Text(basename(e.path)),
                                        onTap: () {
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
        ),
        body: AlmanacPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String? result = await FilePicker.platform.getDirectoryPath();
          },
        ),
      ),
    );
  }
}

class AlmanacPage extends StatelessWidget {
  const AlmanacPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: FutureBuilder<List<FileSystemEntity>>(
            future: Directory('/').list().toList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    ...snapshot.data!.map((e) => ListTile(title: Text(e.path))),
                  ],
                );
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ),
        Expanded(
          child: SfPdfViewer.file(File("C:\\L01.pdf")),
        ),
      ],
    );
  }
}
