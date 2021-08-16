import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'product.dart';

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
      name
      picture
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

          var dateStart = result.data!['getAction']['dateStart'];
          var dateFinish = result.data!['getAction']['dateFinish'];

          return Scaffold(
            appBar:
                AppBar(title: Text(result.data!['getAction']['name'] ?? "")),
            body: ListView(
              children: [
                Image.network(result.data!['getAction']['picture']),
                if (dateStart != null && dateFinish != null)
                  Text(
                      "C ${new DateTime.fromMillisecondsSinceEpoch(dateStart)} по ${new DateTime.fromMillisecondsSinceEpoch(dateFinish)}"),
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
                Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: result.data!['getAction']['products']
                        .map(
                          (product) => FractionallySizedBox(
                            widthFactor: 0.45,
                            child: ProductCard(
                                product: product,
                                onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductPage(id: product['iD'])),
                                    )),
                          ),
                        )
                        .toList()
                        .cast<Widget>()),
              ],
            ),
          );
        });
  }
}
