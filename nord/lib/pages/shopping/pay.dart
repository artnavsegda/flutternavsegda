import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/components.dart';
import 'package:nord/utils.dart';
import 'success.dart';
import '../../components/components.dart';
import 'package:nord/gql.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key, required this.basket, required this.order})
      : super(key: key);

  final GraphBasket basket;
  final GraphNewOrder order;

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  late GraphNewOrder order;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

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
        title: const Text('Оплата'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 12),
/*                 OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(72.0, 96.0),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {},
                    child: SizedBox(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            width: 72,
                            height: 96,
                          ),
                          Positioned(
                            bottom: 8,
                            child: Text(
                              'Новая\nКарта',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            bottom: 53,
                            child: Icon(
                              SeverMetropol.Icon_Add,
                              color: Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(width: 8), */
                ...widget.basket.bankCards.map((bankCard) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(72.0, 96.0),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            setState(() {
                              order.bankCardID = bankCard.iD;
                            });
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  width: 72,
                                  height: 96,
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 8,
                                  child: Text(
                                    bankCard.mask,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Positioned(
                                  left: 4,
                                  top: 4,
                                  child: Icon(
                                    order.bankCardID == bankCard.iD
                                        ? SeverMetropol.Icon_Checkbox_Checked
                                        : SeverMetropol.Icon_Checkbox_Unchecked,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SliderCombo(
              value: order.paidPoints,
              max: widget.basket.availablePoints,
              onChanged: (newVal) {
                setState(() {
                  order.paidPoints = newVal;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SpecialCondition(
              text:
                  'Сумма на вашем счете будет заморжена и списана только после того, как заказа будет передан',
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Mutation(
                options: MutationOptions(
                  document: gql(addOrder),
                  onError: (error) {
                    showErrorAlert(context, '$error');
                  },
                  onCompleted: (resultData) {
                    if (resultData != null) {
                      GraphOrderResult nordOrderResult =
                          GraphOrderResult.fromJson(resultData['addOrder']);

                      if (nordOrderResult.result == 0) {
                      } else {
                        showErrorAlert(
                            context, nordOrderResult.errorMessage ?? '');
                      }
                    }
                  },
                ),
                builder: (runMutation, result) {
                  return ElevatedButton(
                      onPressed: () {
                        context.pushNamed('webview',
                            params: {'path': 'http://ya.ru'});
                        context.push('/success');
                      },
                      child: const Text('Оплатить'));
                }),
          ),
        ],
      ),
    );
  }
}
