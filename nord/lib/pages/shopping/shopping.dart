import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nord/pages/error/error.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nord/sever_metropol_icons.dart';

import '../../components/components.dart';
import '../../components/gradient_button.dart';
import 'registration.dart';
import 'cart_is_empty.dart';
import '../../gql.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getCart)),
        builder: (result, {refetch, fetchMore}) {
          //print(result);

          if (result.hasException) {
            return ErrorPage(reload: () {
              refetch!();
            });
          }

          if (result.isLoading && result.data == null) {
            return RefreshIndicator(
              onRefresh: () async {
                await refetch!();
                //await Future.delayed(Duration(seconds: 5));
              },
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          List<GraphCartRow> cart = List<GraphCartRow>.from(result
              .data!['getCart']
              .map((model) => GraphCartRow.fromJson(model)));

          if (cart.isEmpty) {
            return CartIsEmpty();
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Корзина'),
              actions: [
                Mutation(
                    options: MutationOptions(
                        document: gql(cartClear),
                        onCompleted: (resultData) {
                          refetch!();
                        }),
                    builder: (runMutation, result) {
                      return TextButton(
                          onPressed: () {
                            runMutation({});
                          },
                          child: const Text('Очистить'));
                    }),
              ],
            ),
            body: Column(
              children: [
                const AddressTile2(),
                Expanded(
                  child: ListView(
                    children: [
                      ...cart.map(
                        (item) {
                          return CartTile(
                            name: item.productName,
                            image: item.picture ?? '',
                            price: item.amount,
                            id: item.rowID,
                            reload: () => refetch!(),
                            quantity: item.quantity,
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Сумма заказа',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: "Промокод",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text('Сумма заказа'),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DottedLine(
                                      dashColor: Colors.grey, dashLength: 2),
                                )),
                                Text('1 435 ₽',
                                    style: TextStyle(fontFamily: 'Noto Sans')),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Скидка'),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DottedLine(
                                      dashColor: Colors.grey, dashLength: 2),
                                )),
                                Text('Бесплатно'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Промокод'),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DottedLine(
                                      dashColor: Colors.grey, dashLength: 2),
                                )),
                                Text('- 110 ₽',
                                    style: TextStyle(fontFamily: 'Noto Sans')),
                              ],
                            ),
                            Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Общая сумма заказа'),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DottedLine(
                                      dashColor: Colors.grey, dashLength: 2),
                                )),
                                Text('1 325 ₽',
                                    style: TextStyle(fontFamily: 'Noto Sans')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Итого'),
                        Text('1 325 ₽',
                            style: TextStyle(fontFamily: 'Noto Sans')),
                      ],
                    ),
                  ),
                  GradientButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationPage()));
                      },
                      child: const Text('Оформить заказ'))
                ],
              ),
            ),
          );
        });
  }
}

class CartTile extends StatelessWidget {
  const CartTile({
    Key? key,
    required this.name,
    required this.image,
    required this.price,
    required this.id,
    required this.quantity,
    required this.reload,
  }) : super(key: key);

  final String name;
  final String image;
  final double price;
  final int id;
  final int quantity;
  final Function() reload;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              width: 64,
              height: 64,
              imageUrl: image,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: const Color(0xFFECECEC),
                highlightColor: Colors.white,
                child: Container(
                  color: const Color(0xFFECECEC),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFFECECEC),
                child: Center(
                  child: const Icon(Icons.no_photography),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name /* 'Чай каркаде с\nапельсином' */,
                              style: TextStyle(fontSize: 16)),
                          const Text('450 мл',
                              style: TextStyle(color: Colors.grey)),
                          Mutation(
                              options: MutationOptions(
                                  document: gql(cartEdit),
                                  onCompleted: (resultData) {
                                    reload();
                                  }),
                              builder: (runMutation, result) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: TextButton(
                                        onPressed: () {
                                          runMutation({
                                            'rowIDs': [id],
                                            'quantity': quantity - 1,
                                          });
                                        },
                                        child: Icon(
                                          SeverMetropol.Icon_Remove,
                                        ),
                                        style: TextButton.styleFrom(
                                            minimumSize: const Size(24.0, 24.0),
                                            padding: const EdgeInsets.all(0.0)),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 32,
                                      height: 24,
                                      child: Text('$quantity'),
                                    ),
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: TextButton(
                                        onPressed: () {
                                          runMutation({
                                            'rowIDs': [id],
                                            'quantity': quantity + 1,
                                          });
                                        },
                                        child: Icon(
                                          SeverMetropol.Icon_Add,
                                        ),
                                        style: TextButton.styleFrom(
                                            minimumSize: const Size(24.0, 24.0),
                                            padding: const EdgeInsets.all(0.0)),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${price.floor()} ₽',
                              style: TextStyle(
                                  fontFamily: 'Noto Sans', fontSize: 16)),
                          CustomPaint(
                            painter: RedLine(),
                            child: const Text('250 ₽',
                                style: TextStyle(
                                    fontFamily: 'Noto Sans',
                                    color: Colors.grey)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Mutation(
              options: MutationOptions(
                  document: gql(cartDelete),
                  onCompleted: (resultData) {
                    reload();
                  }),
              builder: (runMutation, result) {
                return SlidableAction(
                  onPressed: (context) {
                    runMutation({
                      'rowIDs': [id]
                    });
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  icon: SeverMetropol.Icon_Delete,
                );
              }),
        ],
      ),
    );
  }
}
