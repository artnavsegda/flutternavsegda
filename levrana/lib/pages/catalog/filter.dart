import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'selector.dart';

import '../../gql.dart';

class FiltersPage extends StatefulWidget {
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
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late GraphFilter filter;

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Фильтры"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  filter = GraphFilter();
                });
                widget.onFilterChanged(GraphFilter());
              },
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
              variables: {'catalogID': widget.catalogId},
            ),
            builder: (result, {fetchMore, refetch}) {
              //print(result);

              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading && result.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemCount: result.data!['getFilters']['groups'].length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Text(
                        "Упорядочить",
                        style: TextStyle(fontSize: 16.0),
                      );
                    }
                    if (index == 1) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Цена", style: TextStyle(fontSize: 16.0)),
                          Container(
                            height: 38,
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                        onChanged: (value) {
                                          var newVal = int.tryParse(value);
                                          if (newVal != null) {
                                            filter.priceMin = newVal;
                                            widget.onFilterChanged(filter);
                                            setState(() {
                                              filter = filter;
                                            });
                                          }
                                        },
                                        initialValue:
                                            filter.priceMin.toString(),
                                        keyboardType: TextInputType.number)),
                                SizedBox(width: 12),
                                Expanded(
                                    child: TextFormField(
                                        onChanged: (value) {
                                          var newVal = int.tryParse(value);
                                          if (newVal != null) {
                                            filter.priceMax = newVal;
                                            widget.onFilterChanged(filter);
                                            setState(() {
                                              filter = filter;
                                            });
                                          }
                                        },
                                        initialValue:
                                            filter.priceMax.toString(),
                                        keyboardType: TextInputType.number)),
                              ],
                            ),
                          )
                        ],
                      );
                    }

                    final section =
                        result.data!['getFilters']['groups'][index - 2];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectorPage(
                                      title: section['name'],
                                      type: section['type'],
                                      values: section['values'],
                                      filterGroup: filter.groups[section['iD']],
                                      onChangeFilter: (newValue, newId) {
                                        var newFilter =
                                            GraphFilter.from(filter);
                                        if (newValue == true) {
                                          if (filter.groups
                                              .containsKey(section['iD'])) {
                                            newFilter
                                                .groups[section['iD']]?.values
                                                .add(newId);
                                          } else {
                                            newFilter.groups[section['iD']] =
                                                GraphFilterGroup(
                                                    iD: section['iD'],
                                                    values: {newId});
                                          }
                                        } else {
                                          newFilter
                                              .groups[section['iD']]?.values
                                              .remove(newId);
                                          if (newFilter.groups[section['iD']]!
                                              .values.isEmpty)
                                            newFilter.groups
                                                .remove(section['iD']);
                                        }
                                        setState(() {
                                          filter = newFilter;
                                        });
                                        widget.onFilterChanged(newFilter);
                                      },
                                    )));
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section['name'],
                              style: TextStyle(fontSize: 16.0),
                            ),
                            filter.groups[section['iD']]?.values.isNotEmpty ??
                                    false
                                ? Text(
                                    section['values']
                                        .where((element) =>
                                            filter.groups[section['iD']]?.values
                                                .contains(element['iD']) ??
                                            false)
                                        .toList()
                                        .map((element) => element['name'])
                                        .join(', '),
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black45))
                                : SizedBox.shrink(),
/*                             Wrap(
                              spacing: 10,
                              children: section['values']
                                  .where((element) =>
                                      filter.groups[section['iD']]?.values
                                          .contains(element['iD']) ??
                                      false)
                                  .toList()
                                  .map((element) {
                                    return Text(
                                      element['name'],
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black45),
                                    );
                                  })
                                  .toList()
                                  .cast<Widget>(),
                            ) */
                          ]),
                    );

                    return Column(
                      children: [
                        Text(section['name']),
                        Column(
                            children: section['values']
                                .map((element) {
                                  return CheckboxListTile(
                                      value: filter
                                              .groups[section['iD']]?.values
                                              .contains(element['iD']) ??
                                          false,
                                      onChanged: (newValue) {
                                        var newFilter =
                                            GraphFilter.from(filter);
                                        if (newValue == true) {
                                          if (filter.groups
                                              .containsKey(section['iD'])) {
                                            newFilter
                                                .groups[section['iD']]?.values
                                                .add(element['iD']);
                                          } else {
                                            newFilter.groups[section['iD']] =
                                                GraphFilterGroup(
                                                    iD: section['iD'],
                                                    values: {element['iD']});
                                          }
                                        } else {
                                          newFilter
                                              .groups[section['iD']]?.values
                                              .remove(element['iD']);
                                          if (newFilter.groups[section['iD']]!
                                              .values.isEmpty)
                                            newFilter.groups
                                                .remove(section['iD']);
                                        }
                                        setState(() {
                                          filter = newFilter;
                                        });
                                        widget.onFilterChanged(newFilter);
                                      },
                                      title: Text(element['name']));
                                })
                                .toList()
                                .cast<Widget>()),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                ),
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
