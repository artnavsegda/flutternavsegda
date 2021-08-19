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
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text("Конфигуратор"),
      ),
      body: ListView(
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

              var stageType = result.data!['getConfigurator'][stage]['type'];

              return Column(
                children: [
                  //Text(result.data!['getConfigurator'][stage]['name']),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children:
                              result.data!['getConfigurator'][stage]['name']
                                  .split("*")
                                  .asMap()
                                  .entries
                                  .map(
                                    (element) => TextSpan(
                                        text: element.value,
                                        style: element.key.isEven
                                            ? GoogleFonts.montserrat(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w700,
                                              )
                                            : GoogleFonts.montserrat(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green)),
                                  )
                                  .toList()
                                  .cast<InlineSpan>()),
                    ),
                  ),
                  Text(result.data!['getConfigurator'][stage]['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Flex(
                        direction: stageType == 'IMAGE'
                            ? Axis.horizontal
                            : Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: result.data!['getConfigurator'][stage]
                                ['values']
                            .map((element) {
                              void onPress() {
                                int idToAdd = element['iD'];
                                print(idToAdd);
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
                                case 'ICON':
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: InkWell(
                                      onTap: onPress,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(13.6),
                                            child: Image.network(
                                                element['picture'],
                                                width: 136,
                                                height: 136,
                                                fit: BoxFit.fill),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(element['name'],
                                              style: TextStyle(fontSize: 20.0)),
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
                                          element['name'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0),
                                        )),
                                  );
                                default:
                                  return Text('X');
                              }
                            })
                            .toList()
                            .cast<Widget>()),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        configuratorItemIds = List.from(configuratorItemIds)
                          ..removeLast();
                        stage = stage - 1;
                      });
                    },
                    child: Text(
                        "< Шаг ${stage + 1} из ${result.data!['getConfigurator'].length}",
                        style: TextStyle(fontSize: 20.0)),
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
