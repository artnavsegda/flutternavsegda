import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:nord/sever_metropol_icons.dart';

import '../../gql.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          fetchPolicy: FetchPolicy.cacheFirst,
          document: gql(getFAQGroups),
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

          List<GraphFAQGroup> faqGroups = List<GraphFAQGroup>.from(result
              .data!['getFAQGroups']
              .map((model) => GraphFAQGroup.fromJson(model)));

          return Scaffold(
            appBar: AppBar(
              title: const Text('Справка'),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    SeverMetropol.Icon_West,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ),
            body: ListView(
              children: [
                ...faqGroups.map((faqGroup) => ListTile(
                      title: Text(faqGroup.name),
                      trailing: Icon(
                        SeverMetropol.Icon_East,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpTopicPage(faqGroup),
                          ),
                        )
                      },
                    )),
              ],
            ),
          );
        });
  }
}

class HelpTopicPage extends StatelessWidget {
  const HelpTopicPage(this.faqGroup, {Key? key}) : super(key: key);

  final GraphFAQGroup faqGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(faqGroup.name),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                SeverMetropol.Icon_West,
                color: Theme.of(context).colorScheme.primary,
              )),
        ),
        body: ListView(
          children: [
            ...faqGroup.questions.map((question) => ExpandablePanel(
                  theme: ExpandableThemeData(
                    iconPadding: EdgeInsets.all(16.0),
                    iconColor: Colors.red[900],
                    expandIcon: SeverMetropol.Icon_Expand_More,
                    collapseIcon: SeverMetropol.Icon_Expand_More,
                  ),
                  key: ValueKey(question.iD),
                  //trailing: Icon(SeverMetropol.Icon_Expand_More),
                  header: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      question.question,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  collapsed: const SizedBox.shrink(),
                  expanded: Query(
                      options: QueryOptions(
                        document: gql(getFAQ),
                        fetchPolicy: FetchPolicy.cacheFirst,
                        variables: {
                          'fAQQuestionID': question.iD,
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

                        GraphFAQ faq =
                            GraphFAQ.fromJson(result.data!['getFAQ']);

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(faq.answer),
                        );
                      }),
                )),
          ],
        ));
  }
}

class HelpTopicID extends StatelessWidget {
  const HelpTopicID({Key? key, required this.topicID}) : super(key: key);

  final int topicID;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          fetchPolicy: FetchPolicy.cacheFirst,
          document: gql(getFAQGroups),
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

          List<GraphFAQGroup> faqGroups = List<GraphFAQGroup>.from(result
              .data!['getFAQGroups']
              .map((model) => GraphFAQGroup.fromJson(model)));

          GraphFAQGroup reqTopic =
              faqGroups.firstWhere((element) => element.iD == topicID);

          print(reqTopic);

          return Scaffold(
              appBar: AppBar(
                title: Text(reqTopic.name),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      SeverMetropol.Icon_West,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ),
              body: ListView(
                children: [
                  ...reqTopic.questions.map((question) => ExpandablePanel(
                        theme: ExpandableThemeData(
                          iconPadding: EdgeInsets.all(16.0),
                          iconColor: Colors.red[900],
                          expandIcon: SeverMetropol.Icon_Expand_More,
                          collapseIcon: SeverMetropol.Icon_Expand_More,
                        ),
                        key: ValueKey(question.iD),
                        //trailing: Icon(SeverMetropol.Icon_Expand_More),
                        header: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            question.question,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        collapsed: const SizedBox.shrink(),
                        expanded: Query(
                            options: QueryOptions(
                              document: gql(getFAQ),
                              fetchPolicy: FetchPolicy.cacheFirst,
                              variables: {
                                'fAQQuestionID': question.iD,
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

                              GraphFAQ faq =
                                  GraphFAQ.fromJson(result.data!['getFAQ']);

                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(faq.answer),
                              );
                            }),
                      )),
                ],
              ));
        });
  }
}
