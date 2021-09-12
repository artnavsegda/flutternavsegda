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

class PollAnswersClient {
  int scale = 0;
  var pollAnswers = <int>[];
}

class Poll extends StatefulWidget {
  const Poll({Key? key, required this.actionID}) : super(key: key);

  final int actionID;

  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {
  int stage = 0;

  var answers = Map<int, PollAnswersClient>();

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
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          print(result.data!['getPoll'][stage]);

          return Column(
            children: [
              Text(result.data!['getPoll'][stage]['iD'].toString()),
              Text(result.data!['getPoll'][stage]['name']),
              Text(result.data!['getPoll'][stage]['comment']),
              if (result.data!['getPoll'][stage]['isScale'] == true)
                Slider(
                  onChanged: (v) {},
                  value: 1,
                  min: result.data!['getPoll'][stage]['scaleMin'].toDouble(),
                  max: result.data!['getPoll'][stage]['scaleMax'].toDouble(),
                )
              else if (result.data!['getPoll'][stage]['isMultiple'] == true)
                Column(
                  children: result.data!['getPoll'][stage]['pollAnswers']
                      .map((element) {
                        return Row(
                          children: [
                            Checkbox(value: false, onChanged: (v) {}),
                            Text(element['name']),
                          ],
                        );
                      })
                      .toList()
                      .cast<Widget>(),
                )
              else
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
              Spacer(),
              Row(
                children: [
                  if (stage != 0)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            stage--;
                          });
                        },
                        child: Text("НАЗАД")),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        if (stage < result.data!['getPoll'].length - 1)
                          setState(() {
                            stage++;
                          });
                      },
                      child: Text("ДАЛЕЕ")),
                ],
              )
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
                AppBar(title: Text(result.data!['getAction']['name'] ?? "")),
            body: result.data!['getAction']['type'] == 'POLL'
                ? SafeArea(child: Poll(actionID: actionID))
                : ListView(
                    children: [
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
                                                    ProductPage(
                                                        id: product['iD'])),
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
