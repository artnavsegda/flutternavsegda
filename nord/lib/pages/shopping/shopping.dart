import 'dart:convert';
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
import 'package:nord/utils.dart';
import 'package:nord/gql.dart';

import '../../components/components.dart';
import '../../components/gradient_button.dart';
import 'registration.dart';
import 'cart_is_empty.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  bool headerUp = false;
  bool scrollAtBottom = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.offset > 0 && headerUp == false) {
          setState(() {
            headerUp = true;
          });
        } else if (_scrollController.offset < 1 && headerUp == true) {
          {
            setState(() {
              headerUp = false;
            });
          }
        }

        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            scrollAtBottom == false) {
          setState(() {
            scrollAtBottom = true;
          });
        } else if (_scrollController.offset <
                _scrollController.position.maxScrollExtent &&
            scrollAtBottom == true) {
          setState(() {
            scrollAtBottom = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterState>(builder: (context, model, child) {
      return Query(
          options: QueryOptions(
            document: gql(getBasket),
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {
              'shopID': model.filter == 'PICK_UP' ? model.activeShop!.iD : null,
              'deliveryAddressID':
                  model.filter == 'DELIVERY' ? model.activeAddress!.iD : null,
            },
          ),
          builder: (result, {refetch, fetchMore}) {
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

            GraphBasket basket =
                GraphBasket.fromJson(result.data!['getBasket']);

/*           WidgetsBinding.instance?.addPostFrameCallback((_) {
                context.read<CartState>().cart = basket.rows;
              }); */

            if (basket.rows.isEmpty) {
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
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: AddressTile(),
                ),
                shadowColor: Colors.white,
                elevation: headerUp ? 2 : null,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await refetch!();
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ...basket.rows.map(
                      (item) {
                        return CartTile(
                          key: ValueKey(item.rowID),
                          item: item,
                          reload: () => refetch!(),
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
                        decoration: InputDecoration(
                            labelText: "Промокод",
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                SeverMetropol.Icon_East,
                                size: 24.0,
                              ),
                            )),
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
                              Text('Сумма заказа',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DottedLine(
                                    dashColor: Colors.grey, dashLength: 2),
                              )),
                              Text('${basket.amount} ₽',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                            ],
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Скидка',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DottedLine(
                                    dashColor: Colors.grey, dashLength: 2),
                              )),
                              Text('Бесплатно',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                            ],
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Промокод',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DottedLine(
                                    dashColor: Colors.grey, dashLength: 2),
                              )),
                              Text('- 110 ₽',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                            ],
                          ),
                          Divider(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Общая сумма заказа',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DottedLine(
                                    dashColor: Colors.grey, dashLength: 2),
                              )),
                              Text('${basket.payment} ₽',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(basket.state),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: scrollAtBottom
                        ? null
                        : [
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
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: scrollAtBottom ? 0 : 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Итого',
                                style: TextStyle(
                                    fontFamily: 'Noto Sans',
                                    fontSize: 10,
                                    color: Color(0xFF56626C),
                                    fontFamilyFallback: ['Roboto'])),
                            SizedBox(height: 3),
                            Text('${basket.amount} ₽',
                                style: TextStyle(
                                    fontFamily: 'Noto Sans',
                                    fontSize: 16,
                                    fontFamilyFallback: ['Roboto'])),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        height: 48,
                        width: scrollAtBottom
                            ? MediaQuery.of(context).size.width - 32
                            : 157,
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        child: GradientButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationPage()));
                            },
                            child: const Text('Оформить заказ')),
                      ),
                    ],
                  )),
            );
          });
    });
  }
}

class CartTile extends StatefulWidget {
  const CartTile({
    Key? key,
    required this.item,
    required this.reload,
  }) : super(key: key);

  final GraphCartRow item;
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
            onError: (error) {
              showErrorAlert(context, '$error');
            },
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
                  if (widget.item.picture!.isNotEmpty)
                    CachedNetworkImage(
                      width: 64,
                      height: 64,
                      imageUrl: widget.item.picture!,
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
                    )
                  else
                    Container(
                      width: 64,
                      height: 64,
                      color: const Color(0xFFECECEC),
                      child: Center(
                        child: const Icon(Icons.no_photography),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.item.productName,
                                      style: TextStyle(fontSize: 16)),
/*                                   const Text('450 мл',
                                      style: TextStyle(color: Colors.grey)), */
                                  Mutation(
                                      options: MutationOptions(
                                          document: gql(cartEdit),
                                          onError: (error) {
                                            showErrorAlert(context, '$error');
                                          },
                                          onCompleted: (resultData) {
                                            print(resultData);
                                            if (resultData != null) {
                                              GraphBasisResult nordBasisResult =
                                                  GraphBasisResult.fromJson(
                                                      resultData['cartEdit']);
                                              if (nordBasisResult.result == 0) {
                                                widget.reload();
                                              } else {
                                                showErrorAlert(
                                                    context,
                                                    nordBasisResult
                                                            .errorMessage ??
                                                        '');
                                              }
                                            }
                                          }),
                                      builder: (runMutation, result) {
                                        return Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () {
                                                runMutation({
                                                  'rowID': widget.item.rowID,
                                                  'quantity':
                                                      widget.item.quantity - 1,
                                                });
                                              },
                                              icon: Icon(
                                                  SeverMetropol.Icon_Remove,
                                                  color: Colors.red[900]),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 32,
                                              height: 24,
                                              child: Text(
                                                  '${widget.item.quantity.round()}'),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () {
                                                runMutation({
                                                  'rowID': widget.item.rowID,
                                                  'quantity':
                                                      widget.item.quantity + 1,
                                                });
                                              },
                                              icon: Icon(SeverMetropol.Icon_Add,
                                                  color: Colors.red[900]),
                                            ),
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${widget.item.amount.floor()} ₽',
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'],
                                    )),
                                if (widget.item.oldAmount != null)
                                  CustomPaint(
                                    painter: RedLine(),
                                    child: Text(
                                        '${widget.item.oldAmount!.floor()}  ₽',
                                        style: TextStyle(
                                            fontFamily: 'Noto Sans',
                                            color: Colors.grey,
                                            fontFamilyFallback: ['Roboto'])),
                                  ),
                              ],
                            ),
                          ],
                        ),
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
                  'rowIDs': [widget.item.rowID]
                });
              }),
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  autoClose: false,
                  onPressed: (context) {
                    Slidable.of(context)!
                        .dismiss(ResizeRequest(Duration(milliseconds: 300), () {
                      setState(() {
                        _visible = false;
                      });
                      runMutation({
                        'rowIDs': [widget.item.rowID]
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
