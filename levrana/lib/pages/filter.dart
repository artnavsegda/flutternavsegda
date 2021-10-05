import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'configurator.dart';

import '../gql.dart';

class FiltersPage extends StatelessWidget {
  const FiltersPage({
    Key? key,
    required this.catalogId,
  }) : super(key: key);

  final int catalogId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Фильтры"),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Text(
                'Сбросить',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Query(
            options: QueryOptions(
              document: gql(getFilters),
              variables: {'catalogID': 0},
            ),
            builder: (result, {fetchMore, refetch}) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Configurator(),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 92,
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: <Color>[
                                  Color.fromRGBO(255, 162, 76, 0.22),
                                  Color.fromRGBO(255, 162, 76, 0)
                                ]),
                            color: Color(0xffFFF2C4),
                          ),
                          child: Row(children: [
                            Flexible(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child:
                                  Text("Подобрать косметику в конфигураторе"),
                            )),
                            Image.asset("assets/Bottles.png")
                          ])),
                    ),
                  ),
                  Text("Упорядочить"),
                  Text("Цена"),
                  Text("Лейблы"),
                  Text("Бренды"),
                  Text("Тип продукта"),
                  Text("Тип кожи"),
                ],
              );
            }));
  }
}
