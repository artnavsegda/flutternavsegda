import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getAction = r'''
query getAction($actionID: Int) {
  getAction(actionID: $actionID) {
    iD
    name
    specialConditions
    description
    uRL
    familyName
    dateStart
    dateFinish
    picture
    squarePicture
    type
    products {
      iD
    }
  }
}
''';

class ActionPage extends StatelessWidget {
  const ActionPage({Key? key, required this.actionID}) : super(key: key);

  final int actionID;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getAction),
          variables: {
            'actionID': actionID,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
              appBar:
                  AppBar(title: Text(result.data!['getAction']['name'] ?? "")),
              body: ListView(children: [
                Image.network(result.data!['getAction']['picture']),
                Text(
                    "C ${result.data!['getAction']['dateStart']} по ${result.data!['getAction']['dateFinish']}"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MarkdownBody(
                    data: result.data!['getAction']['description'] ?? "",
                    onTapLink: (text, url, title) {
                      launch(url!);
                      print(url);
                    },
                  ),
                ),
              ]));
        });
  }
}
