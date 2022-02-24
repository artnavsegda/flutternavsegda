import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
/*                 ListTile(
                  title: Text('Бонусная программа'),
                  trailing: Icon(
                    SeverMetropol.Icon_East,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpTopicPage(),
                      ),
                    )
                  },
                ), */
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      '''Для улучшения работы приложения компания может использовать статистические и иные технические данные о действих пользователя при работе с приложением (перемещение между экранами, нажатие кнопок и т.д.). Персональная данные или любая финансовая информация не используется для данных целей.

Основные положения сбора и хранения информации вы можете найти в Положении об Обработке и защите персональных данных.'''),
                )
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
            ...faqGroup.questions.map((question) => ExpansionTile(
                  trailing: Icon(SeverMetropol.Icon_Expand_More),
                  title: Text(question.question),
                  children: [
                    Query(
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

                          return Text(faq.answer);
                        })
                  ],
                )),
          ],
        ));
  }
}
