import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import 'package:nord/gql.dart';
import 'package:nord/router/routes.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/gradient_button.dart';
import '../../components/components.dart';
import 'pay.dart';

class OrderDate {
  OrderDate({
    required this.deliveryDate,
    required this.deliveryTimeID,
    required this.deliveryExpress,
  });

  String deliveryDate;
  int deliveryTimeID;
  bool deliveryExpress;
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key, required this.basket}) : super(key: key);

  final GraphBasket basket;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late GraphNewOrder order;

  @override
  void initState() {
    super.initState();
    order = GraphNewOrder(
      deliveryDate: widget.basket.slots.dates[0].date,
      deliveryTimeID: widget.basket.slots.times[0].iD,
      deliveryExpress: false,
      bankCardID: widget.basket.bankCards[0].iD,
      wishes: [],
    );
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
        title: const Text('Оформление заказа'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Время доставки',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ListTile(
            onTap: () async {
              OrderDate? newOrderDate = await showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(4.0)),
                ),
                backgroundColor: Colors.white,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return SelectDateBottomSheet(
                      basket: widget.basket,
                      orderDate: OrderDate(
                        deliveryDate: order.deliveryDate,
                        deliveryTimeID: order.deliveryTimeID,
                        deliveryExpress: order.deliveryExpress,
                      ));
                },
              );
              if (newOrderDate != null) {
                setState(() {
                  order.deliveryDate = newOrderDate.deliveryDate;
                  order.deliveryTimeID = newOrderDate.deliveryTimeID;
                  order.deliveryExpress = newOrderDate.deliveryExpress;
                });
              }
            },
            leading: Image.asset('assets/Illustration-Colored-Clocks.png'),
            subtitle: Text(
              "Доставка: " +
                  (order.deliveryExpress
                      ? 'ко времени: ${widget.basket.deliveryInfo?.expressPrice ?? 300} ₽'
                      : 'бесплатно'),
              style: TextStyle(
                  color: Color(0xFF56626C), fontFamilyFallback: ['Roboto']),
            ),
            title: Text(
              "20 октября с 14:00 до 18:00",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: Icon(
              SeverMetropol.Icon_Expand_More,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            title: Text(
              'Отдельные пожелания',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  order.clientComment = value;
                });
              },
              maxLines: 3,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Комментарий или пожелания по заказу',
                hintText: 'Комментарий или пожелания по заказу',
              ),
            ),
          ),
          ...widget.basket.wishes.map(
            (wish) => ListTile(
              onTap: () {
                setState(() {
                  order.wishes.contains(wish.iD)
                      ? order.wishes.remove(wish.iD)
                      : order.wishes.add(wish.iD);
                });
              },
              leading: Icon(
                order.wishes.contains(wish.iD)
                    ? SeverMetropol.Icon_Checkbox_Checked
                    : SeverMetropol.Icon_Checkbox_Unchecked,
                color: Colors.red[900],
              ),
              title: Text(wish.name),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: GradientButton(
                onPressed: () {
                  context.push('/pay',
                      extra: PayPageArguments(widget.basket, order));
                },
                child: const Text('Перейти к оплате')),
          ),
        ],
      ),
    );
  }
}

class SelectDateBottomSheet extends StatefulWidget {
  const SelectDateBottomSheet({
    Key? key,
    required this.basket,
    required this.orderDate,
  }) : super(key: key);

  final GraphBasket basket;
  final OrderDate orderDate;

  @override
  State<SelectDateBottomSheet> createState() => _SelectDateBottomSheetState();
}

class _SelectDateBottomSheetState extends State<SelectDateBottomSheet> {
  late OrderDate orderDate;

  @override
  void initState() {
    super.initState();
    orderDate = widget.orderDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const ListTile(
          title: Center(
              child: Text(
            'Дата и время доставки',
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Дата', style: Theme.of(context).textTheme.headlineSmall),
        ),
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.basket.slots.dates.length,
              itemBuilder: (context, index) {
                var content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'чт',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '21.10',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
                onPressed() {
                  setState(() {
                    orderDate.deliveryDate =
                        widget.basket.slots.dates[index].date;
                  });
                }

                return SizedBox.square(
                    dimension: 80,
                    child: widget.basket.slots.dates[index].date ==
                            orderDate.deliveryDate
                        ? GradientButton(onPressed: onPressed, child: content)
                        : OutlinedButton(onPressed: onPressed, child: content));
              },
              separatorBuilder: (context, index) => SizedBox(width: 8)),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Text('Время', style: Theme.of(context).textTheme.headlineSmall),
        ),
        if (widget.basket.deliveryInfo?.express ?? false)
          SwitchListTile(
            value: orderDate.deliveryExpress,
            onChanged: (value) {
              setState(() {
                orderDate.deliveryExpress = value;
                value
                    ? orderDate.deliveryTimeID =
                        widget.basket.slots.expressTimes[0].iD
                    : orderDate.deliveryTimeID =
                        widget.basket.slots.times[0].iD;
              });
            },
            title: Text('Доставка ко времени'),
            subtitle: Text(
              'Стоимость: 299 ₽',
              style: TextStyle(
                  fontFamily: 'Noto Sans', fontFamilyFallback: ['Roboto']),
            ),
            secondary: Image.asset('assets/Illustration-Colored-Moto.png'),
          ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: orderDate.deliveryExpress
                ? widget.basket.slots.expressTimes.length
                : widget.basket.slots.times.length,
            itemBuilder: (context, index) {
              var time = orderDate.deliveryExpress
                  ? widget.basket.slots.expressTimes[index]
                  : widget.basket.slots.times[index];

              var content = Text(time.name);
              onPressed() {
                setState(() {
                  orderDate.deliveryTimeID = time.iD;
                });
              }

              return orderDate.deliveryTimeID == time.iD
                  ? GradientButton(onPressed: onPressed, child: content)
                  : OutlinedButton(onPressed: onPressed, child: content);
            },
            separatorBuilder: (context, index) => SizedBox(width: 8),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, orderDate);
              },
              child: const Text('Выбрать')),
        )
      ],
    );
  }
}
