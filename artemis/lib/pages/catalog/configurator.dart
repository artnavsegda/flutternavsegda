import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../gql.dart';
import '../../components/productCard.dart';
import '../product/product.dart';

class Configurator extends StatefulWidget {
  const Configurator({
    Key? key,
  }) : super(key: key);

  @override
  _ConfiguratorState createState() => _ConfiguratorState();
}

class _ConfiguratorState extends State<Configurator> {
  late ScrollController _controller;
  int stage = 0;
  List<int> configuratorItemIds = [];

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future Function()? fetchMoreCB;

    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text("Конфигуратор"),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            if (_controller.offset + 100 >=
                    _controller.position.maxScrollExtent &&
                !_controller.position.outOfRange) {
              print("refetch parent");
              fetchMoreCB!();
            }
          }
          return false;
        },
        child: ListView(
          controller: _controller,
          children: [
            Query(
              options: QueryOptions(document: gql(getConfigurator)),
              builder: (result, {fetchMore, refetch}) {
                //print(result);
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<GraphConfiguratorStep> configuratorSteps =
                    List<GraphConfiguratorStep>.from(result
                        .data!['getConfigurator']
                        .map((model) => GraphConfiguratorStep.fromJson(model)));

                if (stage == configuratorSteps.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              configuratorItemIds =
                                  List.from(configuratorItemIds)..removeLast();
                              stage = stage - 1;
                            });
                          },
                          child: Text("Назад")),
                    ),
                  );
                }

                var stageType = configuratorSteps[stage].type;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: configuratorSteps[stage]
                                .name
                                .split("*")
                                .asMap()
                                .entries
                                .map(
                                  (element) => TextSpan(
                                      text: element.value,
                                      style: element.key.isEven
                                          ? TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 32.0,
                                              fontWeight: FontWeight.bold)
                                          : TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 32.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                )
                                .toList()
                                .cast<InlineSpan>()),
                      ),
                    ),
                    Text(configuratorSteps[stage].description ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 8.0),
                      child: Flex(
                          direction: stageType == 'IMAGE'
                              ? Axis.horizontal
                              : Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: configuratorSteps[stage]
                              .values
                              .map((element) {
                                void onPress() {
                                  int idToAdd = element.iD;
                                  //print(idToAdd);
                                  setState(() {
                                    configuratorItemIds =
                                        List.from(configuratorItemIds)
                                          ..add(idToAdd);
                                    stage = stage + 1;
                                  });
                                }

                                switch (result.data!['getConfigurator'][stage]
                                    ['type']) {
                                  case 'IMAGE':
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 12.0),
                                      child: InkWell(
                                        onTap: onPress,
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(13.6),
                                              child: Image.network(
                                                  element.picture ?? "",
                                                  width: 136,
                                                  height: 136,
                                                  fit: BoxFit.fill),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(element.name,
                                                style:
                                                    TextStyle(fontSize: 20.0)),
                                          ],
                                        ),
                                      ),
                                    );
                                  case 'TEXT':
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            minimumSize:
                                                Size(double.infinity, 92),
                                          ),
                                          onPressed: onPress,
                                          child: Text(
                                            element.name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0),
                                          )),
                                    );
                                  case 'ICON':
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            minimumSize:
                                                Size(double.infinity, 92),
                                          ),
                                          onPressed: onPress,
                                          child: Row(
                                            children: [
                                              Image.network(
                                                  element.picture ?? "",
                                                  width: 60),
                                              SizedBox(width: 16.0),
                                              Text(
                                                element.name,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0),
                                              ),
                                            ],
                                          )),
                                    );
                                  default:
                                    return Text('X');
                                }
                              })
                              .toList()
                              .cast<Widget>()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          if (stage != 0)
                            setState(() {
                              configuratorItemIds =
                                  List.from(configuratorItemIds)..removeLast();
                              stage = stage - 1;
                            });
                        },
                        child: Text(
                            "< Шаг ${stage + 1} из ${configuratorSteps.length}",
                            style: TextStyle(fontSize: 20.0)),
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Вам подойдет эта косметика",
                  style: TextStyle(fontSize: 32.0),
                  textAlign: TextAlign.center),
            ),
            Query(
                options: QueryOptions(
                  document: gql(getConfiguratorProducts),
                  variables: {
                    'configuratorItemIds': configuratorItemIds,
                    'cursor': null
                  },
                ),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final GraphProductConnection productConnection =
                      GraphProductConnection.fromJson(
                          result.data!['getConfiguratorProducts']);

                  final PageInfo pageInfo = productConnection.pageInfo;
                  final String fetchMoreCursor = pageInfo.endCursor ?? "";

                  final List<GraphProduct> items = productConnection.items;

                  bool hasNextPage = items.length <
                      result.data!['getConfiguratorProducts']['totalCount'];

                  FetchMoreOptions opts = FetchMoreOptions(
                    variables: {'cursor': fetchMoreCursor},
                    updateQuery: (previousResultData, fetchMoreResultData) {
                      final List<dynamic> items = [
                        ...previousResultData!['getConfiguratorProducts']
                            ['items'] as List<dynamic>,
                        ...fetchMoreResultData!['getConfiguratorProducts']
                            ['items'] as List<dynamic>
                      ];

                      fetchMoreResultData['getConfiguratorProducts']['items'] =
                          items;

                      return fetchMoreResultData;
                    },
                  );

                  fetchMoreCB = () async {
                    print("refetch children");
                    if (hasNextPage) {
                      await fetchMore!(opts);
                    }
                  };

                  return Column(
                    children: [
                      Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 16,
                          runSpacing: 16,
                          children: items
                              .map(
                                (element) => FractionallySizedBox(
                                  widthFactor: 0.43,
                                  child: ProductCard(
                                    product: element,
                                    onTap: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductPage(id: element.iD)),
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                              .cast<Widget>()),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
