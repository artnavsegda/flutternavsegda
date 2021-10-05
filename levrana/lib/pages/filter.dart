import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'configurator.dart';

import '../gql.dart';

class GraphFilter {
  GraphFilter({this.priceMin = 0, this.priceMax = 0});
  int priceMin;
  int priceMax;

  Map<String, dynamic> toJson() => {
        'priceMin': priceMin,
        'priceMax': priceMax,
      };
}

class FiltersPage extends StatelessWidget {
  const FiltersPage(
      {Key? key,
      required this.catalogId,
      required this.filter,
      required this.onFilterChanged})
      : super(key: key);

  final int catalogId;
  final GraphFilter filter;
  final ValueChanged<GraphFilter> onFilterChanged;

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
              variables: {'catalogID': catalogId},
            ),
            builder: (result, {fetchMore, refetch}) {
              print(result);

              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading && result.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.separated(
                itemCount: result.data!['getFilters']['groups'].length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Text("Упорядочить");
                  }
                  if (index == 1) {
                    return Column(
                      children: [
                        Text("Цена"),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                                    onChanged: (value) {
                                      var newVal = int.tryParse(value);
                                      if (newVal != null) {
                                        filter.priceMin = newVal;
                                        onFilterChanged(filter);
                                      }
                                    },
                                    initialValue: filter.priceMin.toString(),
                                    keyboardType: TextInputType.number)),
                            Expanded(
                                child: TextFormField(
                                    onChanged: (value) {
                                      var newVal = int.tryParse(value);
                                      if (newVal != null) {
                                        filter.priceMax = newVal;
                                        onFilterChanged(filter);
                                      }
                                    },
                                    initialValue: filter.priceMax.toString(),
                                    keyboardType: TextInputType.number)),
                          ],
                        )
                      ],
                    );
                  }

                  final section =
                      result.data!['getFilters']['groups'][index - 2];
                  return Text(section['name']);
                },
                separatorBuilder: (context, index) {
                  return Text("A");
                },
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
/*                   InkWell(
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
                  ), */
/*                   Text("Упорядочить"),
                  Text("Цена"),
                  Text("Лейблы"),
                  Text("Бренды"),
                  Text("Тип продукта"),
                  Text("Тип кожи"), */
                ],
              );
            }));
  }
}
