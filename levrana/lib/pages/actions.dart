import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../gql.dart';
import '../components.dart';
import 'product.dart';

class PollAnswersClient {
  PollAnswersClient(
      {this.scale = 0,
      this.pollAnswers = const <int>{},
      this.other = "",
      required this.pollID});
  int scale;
  Set<int> pollAnswers;
  String other;
  int pollID;

  Map<String, dynamic> toJson() => {
        'pollID': pollID,
        'pollAnswers': pollAnswers.toList(),
        'other': other,
        'scale': scale,
      };
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
            return Text('Только зарегистрированным пользователям');
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var stageData = result.data!['getPoll'][stage];

          //print(stageData);

          var isActive = ((stageData['isSkip'] == true) ||
              (answers[stageData['iD']]?.pollAnswers.isNotEmpty ?? false) ||
              ((answers[stageData['iD']]?.scale ?? 0) != 0));

          return Column(
            children: [
              Text(stageData['name'], style: TextStyle(fontSize: 22.0)),
              Text(stageData['comment'], style: TextStyle(fontSize: 20.0)),
              if (stageData['isScale'] == true)
                Slider(
                  divisions: stageData['scaleMax'] - stageData['scaleMin'],
                  onChanged: (value) {
                    setState(() {
                      answers[stageData['iD']] = PollAnswersClient(
                          pollID: stageData['iD'], scale: value.round());
                    });
                  },
                  value: answers[stageData['iD']]?.scale.toDouble() ??
                      stageData['scaleMin'].toDouble(),
                  min: stageData['scaleMin'].toDouble(),
                  max: stageData['scaleMax'].toDouble(),
                )
              else if (stageData['isMultiple'] == true)
                Column(
                  children: stageData['pollAnswers']
                      .map((element) => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(element['name']),
                          value: answers[stageData['iD']]
                                  ?.pollAnswers
                                  .contains(element['iD']) ??
                              false,
                          onChanged: (value) {
                            //print(element['iD']);
                            setState(() {
                              if (value != true)
                                answers[stageData['iD']]
                                    ?.pollAnswers
                                    .remove(element['iD']);
                              else
                                (answers[stageData['iD']] != null)
                                    ? answers[stageData['iD']]
                                        ?.pollAnswers
                                        .add(element['iD'])
                                    : answers[stageData['iD']] =
                                        PollAnswersClient(
                                            pollID: stageData['iD'],
                                            pollAnswers: {element['iD']});
                            });
                          }))
                      .toList()
                      .cast<Widget>(),
                )
              else
                Column(
                  children: stageData['pollAnswers']
                      .map((element) => RadioListTile<bool?>(
                            title: Text(element['name']),
                            value: answers[stageData['iD']]
                                ?.pollAnswers
                                .contains(element['iD']),
                            onChanged: (v) {
                              //print(answers);
                              setState(() {
                                //print(element['iD']);

                                (answers[stageData['iD']] != null)
                                    ? answers[stageData['iD']]?.pollAnswers = {
                                        element['iD']
                                      }
                                    : answers[stageData['iD']] =
                                        PollAnswersClient(
                                            pollID: stageData['iD'],
                                            pollAnswers: {element['iD']});

                                answers[stageData['iD']] = PollAnswersClient(
                                    pollID: stageData['iD'],
                                    pollAnswers: {element['iD']});
                              });
                            },
                            groupValue: true,
                          ))
                      .toList()
                      .cast<Widget>(),
                ),
              if ((stageData['isOther'] == true))
                TextField(
                  decoration: const InputDecoration(hintText: 'Ваш вариант'),
                  onChanged: (text) {
                    setState(() {
                      (answers[stageData['iD']] != null)
                          ? answers[stageData['iD']]?.other = text
                          : answers[stageData['iD']] = PollAnswersClient(
                              pollID: stageData['iD'], other: text);
                    });
                  },
                  maxLines: null,
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
                  (stage < result.data!['getPoll'].length - 1)
                      ? TextButton(
                          onPressed: isActive
                              ? () {
                                  setState(() {
                                    stage++;
                                  });
                                }
                              : null,
                          child: Text("ДАЛЕЕ"))
                      : Mutation(
                          options: MutationOptions(
                            document: gql(setPollResult),
                            onCompleted: (dynamic resultData) {
                              //print(resultData);
                              Navigator.pop(context);
                            },
                          ),
                          builder: (runMutation, result) {
                            //print(result);
                            return TextButton(
                                onPressed: isActive
                                    ? () {
                                        //print("Finish");
                                        //print(widget.actionID);
                                        runMutation({
                                          'actionID': widget.actionID,
                                          'answers': answers.values.toList()
                                        });
                                      }
                                    : null,
                                child: Text("ЗАКОНЧИТЬ"));
                          }),
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

          //print(result);

          initializeDateFormatting();

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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (result.data!['getAction']['dateStart'] !=
                                  null)
                                Text(
                                    "C ${DateFormat.yMMMd('ru_RU').format(dateStart)}",
                                    style: TextStyle(fontSize: 20.0))
                              else if (result.data!['getAction']
                                      ['dateFinish'] !=
                                  null)
                                Text(
                                    "По ${DateFormat.yMMMd('ru_RU').format(dateFinish)}",
                                    style: TextStyle(fontSize: 20.0))
                              else if (result.data!['getAction']['dateStart'] !=
                                      null &&
                                  result.data!['getAction']['dateFinish'] !=
                                      null)
                                Text(
                                    "C ${DateFormat.yMMMd('ru_RU').format(dateStart)} по ${DateFormat.yMMMd('ru_RU').format(dateFinish)}",
                                    style: TextStyle(fontSize: 20.0)),
                              SizedBox(height: 16),
                              MarkdownBody(
                                data: result.data!['getAction']
                                        ['description'] ??
                                    "",
                                onTapLink: (text, url, title) {
                                  launch(url!);
                                  //print(url);
                                },
                              ),
                              SizedBox(height: 16),
                              result.data!['getAction']['products'].length > 1
                                  ? Text("Товары из акции",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                      ))
                                  : SizedBox.shrink(),
                              SizedBox(height: 16),
                              Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children:
                                      result.data!['getAction']['products']
                                          .map(
                                            (product) => FractionallySizedBox(
                                              widthFactor: 0.47,
                                              child: ProductCard(
                                                  product: product,
                                                  onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductPage(
                                                                    id: product[
                                                                        'iD'])),
                                                      )),
                                            ),
                                          )
                                          .toList()
                                          .cast<Widget>()),
                              Column(
                                children: result.data!['getAction']['shops']
                                    .map((shop) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF5F5F5),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              child: Image.network(
                                                shop['pictures'][0],
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    shop['name'],
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(shop['address'],
                                                      style: TextStyle(
                                                          fontSize: 12.0)),
                                                  ...shop['metroStations']
                                                      .map((metroStation) {
                                                        return Row(
                                                          children: [
                                                            Text('*',
                                                                style: TextStyle(
                                                                    color: hexToColor(
                                                                        metroStation[
                                                                            'colorLine']))),
                                                            Expanded(
                                                              child: Text(
                                                                  metroStation[
                                                                      'stationName'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0)),
                                                            ),
                                                          ],
                                                        );
                                                      })
                                                      .toList()
                                                      .cast<Widget>(),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    })
                                    .toList()
                                    .cast<Widget>(),
                              ),
                            ]),
                      ),
                    ],
                  ),
          );
        });
  }
}
