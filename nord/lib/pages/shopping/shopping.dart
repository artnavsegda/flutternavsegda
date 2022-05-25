import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:nord/pages/error/error.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:provider/provider.dart';
import 'package:nord/login_state.dart';
import 'package:nord/gql.dart';
import 'package:nord/components/components.dart';
import 'cart_is_empty.dart';
import 'cart_tile.dart';

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
                    if (basket.state != 'SUCCESS')
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SpecialCondition(
                            text: basket.state == 'TYPE_ORDER_ERROR'
                                ? 'Выберите адрес доставки или кофейню.'
                                : 'Ой! Не все товары доступны. Удалите их из корзины, чтобы оформить заказ.'),
                      ),
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
                        'Итого',
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
                              Text('Стоимость товара',
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
                              Text('${basket.amount.toInt()} ₽',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                            ],
                          ),
                          if (basket.discount != 0) ...[
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
                                Text('- ${basket.discount.toInt()} ₽',
                                    style: TextStyle(
                                        color: Color(0xFFB0063A),
                                        fontFamily: 'Noto Sans',
                                        fontSize: 16,
                                        fontFamilyFallback: ['Roboto'])),
                              ],
                            ),
                          ],
/*                           SizedBox(height: 24),
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
                          ), */
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
                              Text('${basket.payment.toInt()} ₽',
                                  style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'])),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      context.read<FilterState>().filter == 'DELIVERY'
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              color: Color(0xFFEFF3F4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    basket.deliveryInfo?.message ??
                                        'Так, что за бардак',
                                    style: TextStyle(
                                        fontFamilyFallback: ['Roboto']),
                                  ),
                                  InkWell(
                                    onTap: (() {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(4.0)),
                                        ),
                                        backgroundColor: Colors.white,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return DeliveryTermsBottomSheet(
                                              terms:
                                                  basket.deliveryInfo!.terms);
                                        },
                                      );
                                    }),
                                    child: Icon(SeverMetropol.Icon_Info,
                                        color: Color(0xFFB0063A)),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                  Text('${basket.payment.toInt()} ₽',
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
                              child: ElevatedButton(
                                  onPressed: basket.state == 'SUCCESS'
                                      ? () {
                                          context.push('/registration',
                                              extra: basket);
                                        }
                                      : null,
                                  child: const Text('Оформить заказ')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            );
          });
    });
  }
}

class DeliveryTermsBottomSheet extends StatelessWidget {
  const DeliveryTermsBottomSheet({Key? key, required this.terms})
      : super(key: key);

  final List<GraphTerm> terms;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          title: Center(child: Text('Условия доставки')),
          trailing: Icon(
            SeverMetropol.Icon_Close,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        ...terms.map((term) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Text(
                    term.left,
                    style:
                        TextStyle(fontFamilyFallback: ['Roboto'], fontSize: 16),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: DottedLine(dashColor: Colors.grey, dashLength: 2),
                  )),
                  Text(
                    term.right,
                    style:
                        TextStyle(fontFamilyFallback: ['Roboto'], fontSize: 16),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
