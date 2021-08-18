import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

const String getConfigurator = r'''
query getConfigurator
{
  getConfigurator {
    iD
    type
    name
    description
    values {
      iD
      name
      picture
    }
  }
}
''';

const String getConfiguratorProducts = r'''
query getConfiguratorProducts($configuratorItemIds: [Int])
{
  getConfiguratorProducts(first: 5, configuratorItemIds: $configuratorItemIds) {
		totalCount
    items {
      iD
      name
      picture
    }
  }
}
''';

class Configurator extends StatefulWidget {
  const Configurator({
    Key? key,
  }) : super(key: key);

  @override
  _ConfiguratorState createState() => _ConfiguratorState();
}

class _ConfiguratorState extends State<Configurator> {
  int stage = 0;

  List<int> configuratorItemIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Конфигуратор"),
      ),
      body: Column(
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

              return Column(
                children: [
                  //Text(result.data!['getConfigurator'][stage]['name']),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: result.data!['getConfigurator'][stage]['name']
                            .split("*")
                            .asMap()
                            .entries
                            .map(
                              (element) => TextSpan(
                                  text: element.value,
                                  style: element.key.isEven
                                      ? TextStyle(fontWeight: FontWeight.normal)
                                      : TextStyle(fontWeight: FontWeight.bold)),
                            )
                            .toList()
                            .cast<InlineSpan>()),
                  ),
                  Text(result.data!['getConfigurator'][stage]['description']),
                  Row(
                      children: result.data!['getConfigurator'][stage]['values']
                          .map((element) {
                            switch (result.data!['getConfigurator'][stage]
                                ['type']) {
                              case 'IMAGE':
                                return ElevatedButton(
                                  child: Text(element['name']),
                                  onPressed: () {
                                    int idToAdd = element['iD'];
                                    print(idToAdd);
                                    setState(() {
                                      configuratorItemIds =
                                          List.from(configuratorItemIds)
                                            ..add(idToAdd);
                                      stage = stage + 1;
                                    });
                                  },
                                );
                              default:
                                return Text('X');
                            }
                          })
                          .toList()
                          .cast<Widget>()),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        configuratorItemIds = List.from(configuratorItemIds)
                          ..removeLast();
                        stage = stage - 1;
                      });
                    },
                    child: Text(
                        "< Шаг ${stage + 1} из ${result.data!['getConfigurator'].length}"),
                  ),
                ],
              );
            },
          ),
          Query(
              options: QueryOptions(
                document: gql(getConfiguratorProducts),
                fetchPolicy: FetchPolicy.networkOnly,
                variables: {
                  'configuratorItemIds': configuratorItemIds,
                },
              ),
              builder: (result, {fetchMore, refetch}) {
                print(configuratorItemIds);
                print(result);
                //refetch!();
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Wrap(
                    children: result.data!['getConfiguratorProducts']['items']
                        .map((element) => Text(element['name']))
                        .toList()
                        .cast<Widget>());
              })
        ],
      ),
    );
  }
}
