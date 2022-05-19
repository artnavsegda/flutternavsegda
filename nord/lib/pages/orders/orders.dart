import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/pages/error/error.dart';
import 'order.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                SeverMetropol.Icon_West,
                color: Theme.of(context).colorScheme.primary,
              )),
          title: const Text('История заказов'),
        ),
        body: Query(
          options: QueryOptions(document: gql(getOrders)),
          builder: (result, {fetchMore, refetch}) {
            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (result.hasException) {
              return ErrorPage(
                  reload: () {
                    refetch!();
                  },
                  errorText: result.exception.toString());
              return SingleChildScrollView(
                child: Text(result.exception.toString()),
              );
            }

            List<GraphOrder> orders = List<GraphOrder>.from(result
                .data!['getOrders']
                .map((model) => GraphOrder.fromJson(model)));

            final groups = groupBy(orders, (GraphOrder order) {
              return DateFormat.MMMMd('ru_RU').format(order.date);
            });

            return ListView(children: [
              ...groups.entries
                  .map((e) => Column(
                        children: [
                          Text(
                            e.key,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Color(0xFF9CA4AC)),
                          ),
                          ...e.value.map((order) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderPage(
                                        id: order.orderId,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(order.statusName ?? 'Статус',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF56626C))),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        textBaseline: TextBaseline.ideographic,
                                        children: [
                                          Text(
                                            'Заказ №${order.orderId} от ' +
                                                DateFormat.Hm('ru_RU')
                                                    .format(order.date),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFFB0063A)),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: DottedLine(
                                                dashColor: Colors.grey,
                                                dashLength: 2),
                                          )),
                                          Text(
                                            '${order.price.toInt().toString()} ₽',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamilyFallback: ['Roboto']),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            order.address ?? 'без адреса',
                                            style: TextStyle(
                                                color: Color(0xFF56626C)),
                                          ),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFA4D65E),
                                                borderRadius:
                                                    BorderRadius.circular(2.0),
                                              ),
                                              child: Text(
                                                '+${order.receivePoints} Б',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ))
                  .toList(),
            ]);
          },
        ));
  }
}
