import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../gql.dart';
import '../../components/components.dart';
import '../../components/product_card.dart';
import '../product/product.dart';

class Poll extends StatefulWidget {
  const Poll({Key? key, required this.actionID}) : super(key: key);

  final int actionID;

  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {
  int stage = 0;

  var answers = <int, PollAnswersClient>{};

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
            return const Text('Только зарегистрированным пользователям');
          }

          if (result.isLoading) {
            return const Center(
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

          return Padding(
            //padding: MediaQuery.of(context).viewInsets,
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(stageData.name, style: const TextStyle(fontSize: 22.0)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SpecialCondition(text: stageData.comment ?? ""),
                ),
                if (stageData.isScale == true)
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(stageData.scaleMin.toString(),
                              style: const TextStyle(fontSize: 18.0)),
                          Expanded(
                            child: Slider(
                              divisions:
                                  stageData.scaleMax! - stageData.scaleMin!,
                              onChanged: (value) {
                                setState(() {
                                  answers[stageData.iD] = PollAnswersClient(
                                      pollID: stageData.iD,
                                      scale: value.round());
                                });
                              },
                              value: answers[stageData.iD]?.scale.toDouble() ??
                                  stageData.scaleMin!.toDouble(),
                              min: stageData.scaleMin!.toDouble(),
                              max: stageData.scaleMax!.toDouble(),
                            ),
                          ),
                          Text(stageData.scaleMax.toString(),
                              style: const TextStyle(fontSize: 18.0)),
                        ],
                      ),
                      Text(answers[stageData.iD]?.scale.toString() ?? "",
                          style: const TextStyle(fontSize: 20.0))
                    ],
                  )
                else if (stageData.isMultiple == true)
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: stageData.pollAnswers.length,
                    itemBuilder: (context, index) {
                      var element = stageData.pollAnswers[index];
                      return LevranaCheckboxTitle(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          title: Flexible(child: Text(element.name)),
                          value: answers[stageData.iD]
                                  ?.pollAnswers
                                  .contains(element.iD) ??
                              false,
                          onChanged: (value) {
                            //print(element['iD']);
                            setState(() {
                              if (value != true) {
                                answers[stageData.iD]
                                    ?.pollAnswers
                                    .remove(element.iD);
                              } else {
                                (answers[stageData.iD] != null)
                                    ? answers[stageData.iD]
                                        ?.pollAnswers
                                        .add(element.iD)
                                    : answers[stageData.iD] = PollAnswersClient(
                                        pollID: stageData.iD,
                                        pollAnswers: {element.iD});
                              }
                            });
                          });
                    },
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: stageData.pollAnswers.length,
                    itemBuilder: (context, index) {
                      var element = stageData.pollAnswers[index];
                      return LevranaRadioTitle(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        title: Flexible(child: Text(element.name)),
                        value: answers[stageData.iD]
                                ?.pollAnswers
                                .contains(element.iD) ??
                            false,
                        onChanged: (v) {
                          setState(() {
                            (answers[stageData.iD] != null)
                                ? answers[stageData.iD]?.pollAnswers = {
                                    element.iD
                                  }
                                : answers[stageData.iD] = PollAnswersClient(
                                    pollID: stageData.iD,
                                    pollAnswers: {element.iD});

                            answers[stageData.iD] = PollAnswersClient(
                                pollID: stageData.iD,
                                pollAnswers: {element.iD});
                          });
                        },
                      );
                    },
                  ),
                if ((stageData.isOther == true))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Ваш вариант'),
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
                  ),
                const Spacer(),
                Row(
                  children: [
                    if (stage != 0)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              stage--;
                            });
                          },
                          child: const Text("НАЗАД")),
                    const Spacer(),
                    (stage < poll.length - 1)
                        ? TextButton(
                            onPressed: isActive
                                ? () {
                                    setState(() {
                                      stage++;
                                    });
                                  }
                                : null,
                            child: const Text("ДАЛЕЕ"))
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
                                  child: const Text("ЗАКОНЧИТЬ"));
                            }),
                  ],
                )
              ],
            ),
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
          document: gql(getDraw),
          variables: {
            'actionID': widget.actionID,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: Column(
              children: [
                CheckboxTitle(
                  title:
                      "Я прочитал(а) и соглашаюсь с правилами проведения акции",
                  value: iAgree,
                  onChanged: (newValue) => setState(() {
                    iAgree = newValue!;
                  }),
                ),
                const SizedBox(height: 16),
                Mutation(
                    options: MutationOptions(
                      document: gql(setDrawTakePart),
                      onError: (error) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Ошибка'),
                            content: Text(error!.graphqlErrors[0].message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      onCompleted: (resultData) {
                        //print(resultData);
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
                                child: const Text("ОТКАЗАТСЯ")),
                          ),
                          const SizedBox(
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
                                child: const Text("УЧАВСТВОВАТЬ")),
                          ),
                        ],
                      );
                    }),
                const SizedBox(height: 16),
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
          document: gql(getAction),
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
            return const Center(
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
            body: action.type == 'POLL'
                ? SafeArea(child: Poll(actionID: actionID))
                : Stack(
                    children: [
                      ListView(
                        children: [
                          CachedNetworkImage(
                              imageUrl: action.picture ?? "",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.no_photography),
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
                                        style: const TextStyle(fontSize: 20.0))
                                  else if (action.dateStart != null)
                                    Text(
                                        "C ${DateFormat.yMMMd('ru_RU').format(dateStart)}",
                                        style: const TextStyle(fontSize: 20.0))
                                  else if (action.dateFinish != null)
                                    Text(
                                        "По ${DateFormat.yMMMd('ru_RU').format(dateFinish)}",
                                        style: const TextStyle(fontSize: 20.0)),
                                  const SizedBox(height: 16),
                                  if (action.specialConditions != null)
                                    SpecialCondition(
                                        text: action.specialConditions ?? ""),
                                  if (action.type == 'DRAWING')
                                    SafeArea(child: Draw(actionID: actionID)),
                                  MarkdownBody(
                                    data: action.description ?? "",
                                    onTapLink: (text, url, title) {
                                      launch(url!);
                                      //print(url);
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  action.products.length > 1
                                      ? const Text("Товары из акции",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold))
                                      : const SizedBox.shrink(),
                                  const SizedBox(height: 16),
                                  Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: action.products
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
                                                                    id: product
                                                                        .iD)),
                                                      )),
                                            ),
                                          )
                                          .toList()
                                          .cast<Widget>()),
                                  Column(
                                    children: action.shops
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
                              child: const Text("ПОДРОБНЫЕ УСЛОВИЯ АКЦИИ"),
                            ))
                    ],
                  ),
          );
        });
  }
}

class SpecialCondition extends StatelessWidget {
  const SpecialCondition({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            stops: [0.01, 0.01], colors: [Colors.red, Colors.black12]),
        borderRadius: BorderRadius.circular(3.0),
/*                                     color: Colors.black12,
        border: Border(
          left: BorderSide(
              width: 5.0, color: Colors.red),
        ), */
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
