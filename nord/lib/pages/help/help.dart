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
                    color: Colors.red[900],
                  )),
            ),
            body: ListView(
              children: [
                ...faqGroups.map((faqGroup) => ListTile(
                      title: Text(faqGroup.name),
                      trailing: Icon(
                        SeverMetropol.Icon_East,
                        color: Colors.red[900],
                      ),
                    )),
                ListTile(
                  title: Text('Бонусная программа'),
                  trailing: Icon(
                    SeverMetropol.Icon_East,
                    color: Colors.red[900],
                  ),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpTopicPage(),
                      ),
                    )
                  },
                ),
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
  const HelpTopicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Бонусная программа'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                SeverMetropol.Icon_West,
                color: Colors.red[900],
              )),
        ),
        body: ListView(
          children: [
            ExpansionTile(
              title: Text('Термины и определения'),
              children: [],
            ),
            ExpansionTile(
              title: Text('Общие положения'),
              children: [],
            ),
            ExpansionTile(
              title: Text('Как копить и тратить бонусы'),
              children: [
                Text(
                    '''5% от каждой покупки на бонусный счёт и оплачивайте до 20% от покупок бонусными рублями.
При оплате покупки сообщите сотруднику кондитерской о наличии бонусной карты и вашем желании начислить или списать бонусные рубли.
Отсканируйте QR-код или назовите цифровой код из мобильного приложения. В том случае, если у вас не установлено мобильное приложение, назовите свой номер телефона.
Бонусная программа действительна только в мобильном приложении или по номеру телефона в наших кафе-кондитерских.''')
              ],
            ),
          ],
        ));
  }
}
