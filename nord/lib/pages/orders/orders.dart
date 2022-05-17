import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

            return ListView(
              children: [
                Center(
                  child: Text(
                    '18 апреля',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Color(0xFF9CA4AC)),
                  ),
                ),
                ...orders.map((order) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.statusName ?? 'Статус'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Заказ №${order.orderId} от 21:40'),
                                Text('${order.price} ₽')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(order.address ?? 'без адреса'),
                                Text('+${order.receivePoints} Б')
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            );
          },
        ));
  }
}
