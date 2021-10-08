import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
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

          return ExpandableTheme(
            data: ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                iconPlacement: ExpandablePanelIconPlacement.left,
                iconPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                iconRotationAngle: pi / 2,
                expandIcon: Icons.chevron_right,
                collapseIcon: Icons.chevron_right),
            child: ListView(
                children: result.data!['getFAQGroups']
                    .map(
                      (element) {
                        return ExpandablePanel(
                            key: Key(element['iD'].toString()),
                            header: Text(element['name']),
                            collapsed: SizedBox.shrink(),
                            expanded: Column(
                                children: element['questions']
                                    .map((subElement) {
                                      return ExpandableNotifier(
                                        child: ExpandablePanel(
                                            key: Key(
                                                subElement['iD'].toString()),
                                            header:
                                                Text(subElement['question']),
                                            collapsed: SizedBox.shrink(),
                                            expanded: Query(
                                                options: QueryOptions(
                                                  document: gql(getFAQ),
                                                  variables: {
                                                    'fAQQuestionID':
                                                        subElement['iD'],
                                                  },
                                                ),
                                                builder: (result,
                                                    {fetchMore, refetch}) {
                                                  print(result);
                                                  if (result.hasException) {
                                                    return Text(result.exception
                                                        .toString());
                                                  }

                                                  if (result.isLoading) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }

                                                  return Text(
                                                      result.data!['getFAQ']
                                                          ['answer']);
                                                })),
                                      );
                                    })
                                    .toList()
                                    .cast<Widget>()));
                      },
                    )
                    .toList()
                    .cast<Widget>()),
          );
        },
      ),
    );
  }
}
