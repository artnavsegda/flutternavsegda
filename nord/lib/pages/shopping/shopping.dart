import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nord/pages/error/error.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:provider/provider.dart';
import 'package:nord/login_state.dart';

import '../../components/components.dart';
import '../../components/gradient_button.dart';
import 'registration.dart';
import 'cart_is_empty.dart';
import '../../gql.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  bool headerUp = false;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getCart),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
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

          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Provider.of<CartState>(context, listen: false).cartAmount =
                cart.length;
          });

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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await refetch!();
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView(
                      children: [
                        ...cart.map(
                          (item) {
                            return CartTile(
                              key: ValueKey(item.rowID),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      style:
                                          TextStyle(fontFamily: 'Noto Sans')),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      style:
                                          TextStyle(fontFamily: 'Noto Sans')),
                                ],
                              ),
                              Divider(height: 32),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      style:
                                          TextStyle(fontFamily: 'Noto Sans')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                  // BoxShadow(
                  //   color: Color(0x1F000000),
                  //   blurRadius: 10,
                  //   offset: Offset(0, 1),
                  // ),
                  BoxShadow(
                    color: Color(0x24000000),
                    blurRadius: 5,
                    offset: Offset(0, 4),
                  )
                ],
              ),
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

class CartTile extends StatefulWidget {
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
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Mutation(
        options: MutationOptions(
            document: gql(cartDelete),
            onCompleted: (resultData) {
              widget.reload();
            }),
        builder: (runMutation, result) {
          return Slidable(
            key: UniqueKey(),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    width: 64,
                    height: 64,
                    imageUrl: widget.image,
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
                                Text(
                                    widget
                                        .name /* 'Чай каркаде с\nапельсином' */,
                                    style: TextStyle(fontSize: 16)),
                                const Text('450 мл',
                                    style: TextStyle(color: Colors.grey)),
                                Mutation(
                                    options: MutationOptions(
                                        document: gql(cartEdit),
                                        onCompleted: (resultData) {
                                          widget.reload();
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
                                                  'rowIDs': [widget.id],
                                                  'quantity':
                                                      widget.quantity - 1,
                                                });
                                              },
                                              child: Icon(
                                                SeverMetropol.Icon_Remove,
                                              ),
                                              style: TextButton.styleFrom(
                                                  minimumSize:
                                                      const Size(24.0, 24.0),
                                                  padding: const EdgeInsets.all(
                                                      0.0)),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 32,
                                            height: 24,
                                            child: Text('${widget.quantity}'),
                                          ),
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: TextButton(
                                              onPressed: () {
                                                runMutation({
                                                  'rowIDs': [widget.id],
                                                  'quantity':
                                                      widget.quantity + 1,
                                                });
                                              },
                                              child: Icon(
                                                SeverMetropol.Icon_Add,
                                              ),
                                              style: TextButton.styleFrom(
                                                  minimumSize:
                                                      const Size(24.0, 24.0),
                                                  padding: const EdgeInsets.all(
                                                      0.0)),
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
                                Text('${widget.price.floor()} ₽',
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
              extentRatio: 0.2,
              dismissible: DismissiblePane(onDismissed: () {
                setState(() {
                  _visible = false;
                });
                runMutation({
                  'rowIDs': [widget.id]
                });
              }),
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  autoClose: false,
                  onPressed: (context) {
                    print(Slidable.of(context));
                    Slidable.of(context)!
                        .dismiss(ResizeRequest(Duration(milliseconds: 300), () {
                      setState(() {
                        _visible = false;
                      });
                      runMutation({
                        'rowIDs': [widget.id]
                      });
                    }));
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  icon: SeverMetropol.Icon_Delete,
                )
              ],
            ),
          );
        });
  }
}
