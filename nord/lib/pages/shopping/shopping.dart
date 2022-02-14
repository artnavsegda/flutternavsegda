import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
            return const Center(
              child: Text("Корзина недоступна"),
            );
          }

          if (result.isLoading) {
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
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Сумма заказа',
                          style: TextStyle(fontFamily: 'Forum', fontSize: 24),
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
                                    child: DottedLine(dashColor: Colors.grey)),
                                Text('1 435 ₽',
                                    style: TextStyle(fontFamily: 'Noto Sans')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Доставка'),
                                Expanded(
                                    child: DottedLine(dashColor: Colors.grey)),
                                Text('Бесплатно'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Скидка'),
                                Expanded(
                                    child: DottedLine(dashColor: Colors.grey)),
                                Text('- 110 ₽',
                                    style: TextStyle(fontFamily: 'Noto Sans')),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Общая сумма заказа'),
                                Expanded(
                                    child: DottedLine(dashColor: Colors.grey)),
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
  }) : super(key: key);

  final String name;
  final String image;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
              width: 64,
              height: 64,
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
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Image.asset('assets/Icon-Remove.png'),
                                  style: TextButton.styleFrom(
                                      minimumSize: const Size(24.0, 24.0),
                                      padding: const EdgeInsets.all(0.0)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 32,
                                height: 24,
                                child: const Text('2'),
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Image.asset('assets/Icon-Add.png'),
                                  style: TextButton.styleFrom(
                                      minimumSize: const Size(24.0, 24.0),
                                      padding: const EdgeInsets.all(0.0)),
                                ),
                              ),
                            ],
                          ),
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
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Colors.red.shade900,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
    );
  }
}
