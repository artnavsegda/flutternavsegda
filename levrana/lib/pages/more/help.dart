import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../gql.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Справка'),
      ),
      body: Query(
        options: QueryOptions(document: gql(getFAQGroups)),
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
              children: result.data!['getFAQGroups']
                  .map(
                    (element) {
                      return Text(element['name']);
                    },
                  )
                  .toList()
                  .cast<Widget>());
        },
      ),
    );
  }
}
