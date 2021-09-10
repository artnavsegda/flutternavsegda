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

const String getPoll = r'''
query getPoll($actionID: Int)
{
  getPoll(actionID: $actionID) {
    iD
    name
    comment
    isOther
    isSkip
    isMultiple
    isScale
    scaleMin
    scaleMax
    pollAnswers {
      iD
      name
    }
  }
}
''';

const String setPollResult = r'''
mutation setPollResult($actionID: Int, $answers: [graphPollAnswersClient]) {
  setPollResult(actionID: $actionID, answers: $answers) {
    result
    errorMessage
    point
  }
}
''';

class Poll extends StatefulWidget {
  const Poll({Key? key, required this.actionID}) : super(key: key);

  final int actionID;

  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {
  int stage = 0;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getPoll),
          variables: {
            'actionID': widget.actionID,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          print(result);

          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Text(result.data!['getPoll'].length.toString()),
              Text(result.data!['getPoll'][stage]['name']),
              Column(
                children: result.data!['getPoll'][stage]['pollAnswers']
                    .map((element) {
                      return Row(
                        children: [
                          Radio(
                            value: false,
                            onChanged: (v) {},
                            groupValue: true,
                          ),
                          Text(element['name']),
                        ],
                      );
                    })
                    .toList()
                    .cast<Widget>(),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (stage < result.data!['getPoll'].length - 1)
                      setState(() {
                        stage++;
                      });
                  },
                  child: Text("Далее"))
            ],
          );
        });
  }
}

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

          var dateStart = DateTime.fromMillisecondsSinceEpoch(
              result.data!['getAction']['dateStart'] ?? 0);
          var dateFinish = DateTime.fromMillisecondsSinceEpoch(
              result.data!['getAction']['dateFinish'] ?? 0);

          return Scaffold(
            appBar:
                AppBar(title: Text(result.data!['getAction']['type'] ?? "")),
            body: ListView(
              children: [
                Text(result.data!['getAction']['iD'].toString()),
                //Text(result.data!['getAction']['type']),
                Image.network(result.data!['getAction']['picture']),
                if (dateStart != null && dateFinish != null)
                  Text(
                      "C ${DateFormat.yMMMd().format(dateStart)} по ${DateFormat.yMMMd().format(dateFinish)}"),
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
                if (result.data!['getAction']['type'] == 'POLL')
                  Poll(actionID: actionID)
              ],
            ),
          );
        });
  }
}
