import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/pages/error/error.dart';
import 'package:nord/utils.dart';
import '../../components/gradient_button.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Заказ №$id'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                SeverMetropol.Icon_West,
                color: Theme.of(context).colorScheme.primary,
              )),
        ),
        body: Query(
            options: QueryOptions(
              document: gql(getOrder),
              variables: {
                'orderID': id,
              },
            ),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                return ErrorPage(
                  reload: () {
                    refetch!();
                  },
                  errorText: result.exception?.graphqlErrors[0].message ?? '',
                );
              }

              if (result.isLoading && result.data == null) {
                return Scaffold(
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              GraphFullOrder orderInfo =
                  GraphFullOrder.fromJson(result.data!['getOrder']);

              return ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF3F4),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 19, horizontal: 16),
                    margin: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Оценка заказа',
                          style: TextStyle(fontSize: 16),
                        ),
                        RatingBar(
                          itemSize: 27,
                          initialRating: 4.0,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Icon(
                              SeverMetropol.Icon_Star_Rate,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            half: Icon(
                              SeverMetropol.Icon_Star_Rate_Outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            empty: Icon(
                              SeverMetropol.Icon_Star_Rate_Outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (newRating) {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Детали заказа',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ListTile(
                    title: Text('Доставка по адресу',
                        style:
                            TextStyle(fontSize: 10, color: Color(0xFF56626C))),
                    subtitle: Text(orderInfo.address,
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF1D242C))),
                  ),
                  ListTile(
                    title: Text('Дата и время доставки',
                        style:
                            TextStyle(fontSize: 10, color: Color(0xFF56626C))),
                    subtitle: Text(
                        DateFormat('d MMMM, hh:mm', 'ru_RU')
                            .format(orderInfo.date),
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF1D242C))),
                  ),
                  if (orderInfo.clientComment != null)
                    ListTile(
                      title: Text('Комментарий клиента',
                          style: TextStyle(
                              fontSize: 10, color: Color(0xFF56626C))),
                      subtitle: Text(orderInfo.clientComment ?? '',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFF1D242C))),
                    ),
                  if (orderInfo.dispecherComment != null)
                    ListTile(
                      title: Text('Комментарий диспетчера',
                          style: TextStyle(
                              fontSize: 10, color: Color(0xFF56626C))),
                      subtitle: Text(orderInfo.dispecherComment ?? '',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFF1D242C))),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Детали оплаты',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  SizedBox(height: 10),
                  RowTile(
                      left: 'Оплачено',
                      right: '${orderInfo.price.toInt().toString()} ₽'),
                  Divider(
                    height: 42,
                    indent: 16,
                    endIndent: 16,
                  ),
                  RowTile(
                      left: 'Сумма заказа',
                      right: '${orderInfo.price.toInt().toString()} ₽'),
                  SizedBox(height: 26),
                  RowTile(
                      left: 'Доставка',
                      right: orderInfo.deliveryPrice > 0
                          ? '${orderInfo.deliveryPrice.toInt().toString()} ₽'
                          : 'Бесплатно'),
                  SizedBox(height: 26),
                  RowTile(
                      left: 'Скидка',
                      right: '${orderInfo.discount.toInt().toString()} ₽'),
                  SizedBox(height: 26),
                  RowTile(
                      left: 'Оплачено баллами',
                      right: '${orderInfo.paidPoints.toInt().toString()} Б'),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      'Чек оплаты',
                      style: TextStyle(color: Color(0xFFB0063A)),
                    ),
                    trailing: Icon(
                      SeverMetropol.Icon_Site,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Состав заказа',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ...orderInfo.purchases.map((purchase) => OrderCartTile(
                        purchase: purchase,
                      )),
                  SizedBox(height: 16),
                  if (orderInfo.possibleCancel)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Mutation(
                        options: MutationOptions(
                          document: gql(cancelOrder),
                          onError: (error) {
                            showErrorAlert(
                                context, error!.graphqlErrors[0].message);
                          },
                          onCompleted: (resultData) {
                            print(resultData);
                            if (resultData != null) {
                              GraphBasisResult nordResult =
                                  GraphBasisResult.fromJson(
                                      resultData['cancelOrder']);
                              if (nordResult.result == 0) {
                                Navigator.pop(context);
                              }
                              if (nordResult.errorMessage?.isNotEmpty ?? false)
                                showErrorAlert(
                                    context, nordResult.errorMessage ?? '');
                            }
                          },
                        ),
                        builder: (runMutation, result) {
                          return GradientButton(
                              onPressed: () {
                                runMutation({'orderID': orderInfo.orderId});
                              },
                              child: Text('Отменить заказ'));
                        },
                      ),
                    )
                ],
              );
            }));
  }
}

class RowTile extends StatelessWidget {
  const RowTile({
    Key? key,
    required this.left,
    required this.right,
  }) : super(key: key);

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        textBaseline: TextBaseline.ideographic,
        children: [
          Text(left, style: TextStyle(fontSize: 16)),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: DottedLine(dashColor: Colors.grey, dashLength: 2),
          )),
          Text(right,
              style: TextStyle(fontSize: 16, fontFamilyFallback: ['Roboto']))
        ],
      ),
    );
  }
}

class OrderCartTile extends StatelessWidget {
  const OrderCartTile({
    Key? key,
    required this.purchase,
  }) : super(key: key);

  final GraphCartRow purchase;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            width: 64,
            height: 64,
            imageUrl: purchase.picture!,
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
                        Text(purchase.productName,
                            style: TextStyle(fontSize: 16)),
                        Text(purchase.modifiers ?? '',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${purchase.amount.toInt().toString()} ₽',
                            style: TextStyle(
                                fontSize: 16, fontFamilyFallback: ['Roboto'])),
                        Text('X ${purchase.quantity.toInt().toString()}',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
