import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../graphql/levrana.dart';
//import '../../gql.dart';
import '../../components/components.dart';
import '../../components/productCard.dart';
import '../product/product.dart';

class PollAnswersClient {
  PollAnswersClient({
    this.scale = 0,
    this.pollAnswers = const <int>{},
    this.other = "",
    required this.pollID,
  });
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
          document: GetPollQuery(
                  variables: GetPollArguments(actionID: widget.actionID))
              .document,
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

          List<GraphPoll> poll = List<GraphPoll>.from(result.data!['getPoll']
              .map((model) => GraphPoll.fromJson(model)));

          var stageData = poll[stage];

          //print(stageData);

          var isActive = ((stageData.isSkip == true) ||
              (answers[stageData.iD]?.pollAnswers.isNotEmpty ?? false) ||
              ((answers[stageData.iD]?.scale ?? 0) != 0));

          return Column(
            children: [
              Text(stageData.name, style: TextStyle(fontSize: 22.0)),
              Text(stageData.comment ?? "", style: TextStyle(fontSize: 20.0)),
              if (stageData.isScale == true)
                Slider(
                  divisions: stageData.scaleMax! - stageData.scaleMin!,
                  onChanged: (value) {
                    setState(() {
                      answers[stageData.iD] = PollAnswersClient(
                          pollID: stageData.iD, scale: value.round());
                    });
                  },
                  value: answers[stageData.iD]?.scale.toDouble() ??
                      stageData.scaleMin!.toDouble(),
                  min: stageData.scaleMin!.toDouble(),
                  max: stageData.scaleMax!.toDouble(),
                )
              else if (stageData.isMultiple == true)
                Column(
                  children: stageData.pollAnswers!
                      .map((element) => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(element!.name),
                          value: answers[stageData.iD]
                                  ?.pollAnswers
                                  .contains(element.iD) ??
                              false,
                          onChanged: (value) {
                            //print(element['iD']);
                            setState(() {
                              if (value != true)
                                answers[stageData.iD]
                                    ?.pollAnswers
                                    .remove(element.iD);
                              else
                                (answers[stageData.iD] != null)
                                    ? answers[stageData.iD]
                                        ?.pollAnswers
                                        .add(element.iD)
                                    : answers[stageData.iD] = PollAnswersClient(
                                        pollID: stageData.iD,
                                        pollAnswers: {element.iD});
                            });
                          }))
                      .toList()
                      .cast<Widget>(),
                )
              else
                Column(
                  children: stageData.pollAnswers!
                      .map((element) => RadioListTile<bool?>(
                            title: Text(element!.name),
                            value: answers[stageData.iD]
                                ?.pollAnswers
                                .contains(element.iD),
                            onChanged: (v) {
                              //print(answers);
                              setState(() {
                                //print(element['iD']);

                                (answers[stageData.iD] != null)
                                    ? answers[stageData.iD]?.pollAnswers = {
                                        element.iD
                                      }
                                    : answers[stageData.iD] = PollAnswersClient(
                                        pollID: stageData.iD,
                                        pollAnswers: {element!.iD});

                                answers[stageData.iD] = PollAnswersClient(
                                    pollID: stageData.iD,
                                    pollAnswers: {element!.iD});
                              });
                            },
                            groupValue: true,
                          ))
                      .toList()
                      .cast<Widget>(),
                ),
              if ((stageData.isOther == true))
                TextField(
                  decoration: const InputDecoration(labelText: 'Ваш вариант'),
                  onChanged: (text) {
                    setState(() {
                      (answers[stageData.iD] != null)
                          ? answers[stageData.iD]?.other = text
                          : answers[stageData.iD] = PollAnswersClient(
                              pollID: stageData.iD, other: text);
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
                  (stage < poll.length - 1)
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
                            document: SetPollResultMutation(
                                    variables: SetPollResultArguments(
                                        actionID: widget.actionID))
                                .document,
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

class Draw extends StatefulWidget {
  const Draw({Key? key, required this.actionID}) : super(key: key);

  final int actionID;

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  bool iAgree = false;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: GetDrawQuery(
                  variables: GetDrawArguments(actionID: widget.actionID))
              .document,
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

          print(result);

          return Center(
            child: Column(
              children: [
/*                 Column(
                  children: result.data!['getDraw']['levels']
                      .map((element) {
                        return Row(children: [
                          Text("${element['level']}"),
                          Text("${element['position']}"),
                          Text("${element['endPosition']}"),
                        ]);
                      })
                      .toList()
                      .cast<Widget>(),
                ), */
                CheckboxTitle(
                  title:
                      "Я прочитал(а) и соглашаюсь с правилами проведения акции",
                  value: iAgree,
                  onChanged: (newValue) => setState(() {
                    iAgree = newValue!;
                  }),
                ),
                SizedBox(height: 16),
                Mutation(
                    options: MutationOptions(
                      document: SetDrawTakePartMutation(
                              variables: SetDrawTakePartArguments(
                                  actionID: widget.actionID))
                          .document,
                      onError: (error) {
                        print(error);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Ошибка'),
                            content: Text(error!.graphqlErrors[0].message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      onCompleted: (resultData) {
                        print(resultData);
                      },
                    ),
                    builder: (runMutation, mutationResult) {
                      return Row(
                        children: [
/*                           ElevatedButton(
                              onPressed: () => runMutation(
                                  {'actionID': actionID, 'mode': 'WAIT'}),
                              child: Text("WAIT")), */
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () => runMutation({
                                      'actionID': widget.actionID,
                                      'mode': 'NO'
                                    }),
                                child: Text("ОТКАЗАТСЯ")),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: iAgree
                                    ? () => runMutation({
                                          'actionID': widget.actionID,
                                          'mode': 'YES'
                                        })
                                    : null,
                                child: Text("УЧАВСТВОВАТЬ")),
                          ),
                        ],
                      );
                    }),
                SizedBox(height: 16),
              ],
            ),
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
          fetchPolicy: FetchPolicy.cacheFirst,
          document:
              GetActionQuery(variables: GetActionArguments(actionID: actionID))
                  .document,
          variables: {
            'actionID': actionID,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                  child: Text(
                result.exception.toString(),
              )),
            );
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          GraphActionCard action =
              GraphActionCard.fromJson(result.data!['getAction']);

          initializeDateFormatting();

          var dateStart =
              DateTime.fromMillisecondsSinceEpoch(action.dateStart ?? 0);
          var dateFinish =
              DateTime.fromMillisecondsSinceEpoch(action.dateFinish ?? 0);

          return Scaffold(
            appBar: AppBar(title: Text(action.name)),
            body: action.type == ActionType.poll
                ? SafeArea(child: Poll(actionID: actionID))
                : Stack(
                    children: [
                      ListView(
                        children: [
                          FadeInImage.memoryNetwork(
                              imageErrorBuilder:
                                  (context, exception, stackTrace) =>
                                      Icon(Icons.no_photography),
                              placeholder: kTransparentImage,
                              image: action.picture ?? "",
                              fit: BoxFit.fill),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (action.dateStart != null &&
                                      action.dateFinish != null)
                                    Text(
                                        "C ${DateFormat.yMMMd('ru_RU').format(dateStart)} по ${DateFormat.yMMMd('ru_RU').format(dateFinish)}",
                                        style: TextStyle(fontSize: 20.0))
                                  else if (action.dateStart != null)
                                    Text(
                                        "C ${DateFormat.yMMMd('ru_RU').format(dateStart)}",
                                        style: TextStyle(fontSize: 20.0))
                                  else if (action.dateFinish != null)
                                    Text(
                                        "По ${DateFormat.yMMMd('ru_RU').format(dateFinish)}",
                                        style: TextStyle(fontSize: 20.0)),
                                  SizedBox(height: 16),
                                  if (action.specialConditions != null)
                                    Container(
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 2),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(stops: [
                                          0.01,
                                          0.01
                                        ], colors: [
                                          Colors.red,
                                          Colors.black12
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(3.0),
/*                                     color: Colors.black12,
                                        border: Border(
                                          left: BorderSide(
                                              width: 5.0, color: Colors.red),
                                        ), */
                                      ),
                                      child: Text(
                                          action.specialConditions ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  if (action.type == ActionType.drawing)
                                    SafeArea(child: Draw(actionID: actionID)),
                                  MarkdownBody(
                                    data: action.description ?? "",
                                    onTapLink: (text, url, title) {
                                      launch(url!);
                                      //print(url);
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  action.products!.length > 1
                                      ? Text("Товары из акции",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold))
                                      : SizedBox.shrink(),
                                  SizedBox(height: 16),
                                  Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: action.products!
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
                                                                    id: product!
                                                                        .iD)),
                                                      )),
                                            ),
                                          )
                                          .toList()
                                          .cast<Widget>()),
                                  Column(
                                    children: action.shops!
                                        .map((shop) => ShopCard(shop: shop))
                                        .toList()
                                        .cast<Widget>(),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      if (action.uRL != null)
                        Positioned(
                            left: 16,
                            right: 16,
                            bottom: MediaQuery.of(context).padding.bottom + 16,
                            child: ElevatedButton(
                              onPressed: () {
                                launch(result.data!['getAction']['uRL']);
                              },
                              child: Text("ПОДРОБНЫЕ УСЛОВИЯ АКЦИИ"),
                            ))
                    ],
                  ),
          );
        });
  }
}
