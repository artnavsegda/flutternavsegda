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
        options: QueryOptions(
          fetchPolicy: FetchPolicy.cacheFirst,
          document: gql(getFAQGroups),
        ),
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
            child: ListView(children: [
              SizedBox(
                height: 24,
              ),
              ...result.data!['getFAQGroups']
                  .map(
                    (element) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ExpandablePanel(
                            key: Key(element['iD'].toString()),
                            header: Text(
                              element['name'],
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            collapsed: SizedBox.shrink(),
                            expanded: Column(
                                children: element['questions']
                                    .map((subElement) {
                                      return ExpandableNotifier(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: ExpandablePanel(
                                              key: Key(
                                                  subElement['iD'].toString()),
                                              header: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Text(
                                                    subElement['question']),
                                              ),
                                              collapsed: SizedBox.shrink(),
                                              expanded: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16, left: 24.0),
                                                child: Query(
                                                    options: QueryOptions(
                                                      document: gql(getFAQ),
                                                      fetchPolicy: FetchPolicy
                                                          .cacheFirst,
                                                      variables: {
                                                        'fAQQuestionID':
                                                            subElement['iD'],
                                                      },
                                                    ),
                                                    builder: (result,
                                                        {fetchMore, refetch}) {
                                                      print(result);
                                                      if (result.hasException) {
                                                        return Text(result
                                                            .exception
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
                                                    }),
                                              )),
                                        ),
                                      );
                                    })
                                    .toList()
                                    .cast<Widget>())),
                      );
                    },
                  )
                  .toList()
                  .cast<Widget>()
            ]),
          );
        },
      ),
    );
  }
}
