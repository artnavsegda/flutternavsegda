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

class Configurator extends StatefulWidget {
  const Configurator({
    Key? key,
  }) : super(key: key);

  @override
  _ConfiguratorState createState() => _ConfiguratorState();
}

class _ConfiguratorState extends State<Configurator> {
  int stage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Конфигуратор"),
      ),
      body: Query(
        options: QueryOptions(document: gql(getConfigurator)),
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
              Text(result.data!['getConfigurator'][stage]['name']),
              Text(result.data!['getConfigurator'][stage]['description']),
              Row(
                  children: result.data!['getConfigurator'][stage]['values']
                      .map((element) => Text(element['name']))
                      .toList()
                      .cast<Widget>()),
              Text(
                  "< Шаг ${stage + 1} из ${result.data!['getConfigurator'].length}"),
            ],
          );
        },
      ),
    );
  }
}
