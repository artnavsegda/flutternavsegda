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
    return Scaffold(
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
                      ),
                    )),
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
            Expanded(
              child: SfPdfViewer.file(File("C:\\LH01.pdf")),
            ),
          ],
        ));
  }
}
