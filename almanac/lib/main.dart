import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
          appBar: AppBar(
            leadingWidth: 200.0,
            leading: TextButton(
              child: Text(
                'Choose',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
            ),
          ),
          body: Row(
            children: [
              SizedBox(
                width: 300,
                child: FutureBuilder<List<FileSystemEntity>>(
                  future: Directory('/').list().toList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: [
                          ...snapshot.data!.map((e) => Text(e.path)),
                        ],
                      );
                    } else
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: SfPdfViewer.file(
                    File("C:\\EFF_charts_2202\\BIKF_KEFLAVIK\\APP\\H01.pdf")),
              ),
            ],
          )),
    );
  }
}
