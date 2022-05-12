import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import 'package:nord/gql.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/gradient_button.dart';
import '../../components/components.dart';
import 'pay.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key, required this.basket}) : super(key: key);

  final GraphBasket basket;

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
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return SelectDateBottomSheet(slots: basket.slots);
                },
              );
            },
            leading: Image.asset('assets/Illustration-Colored-Clocks.png'),
            title: const Text(
              "Заберу",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            subtitle: Text(
              "В ближайшее время",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              SeverMetropol.Icon_Expand_More,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SwitchListTile(
            value: false,
            onChanged: (value) {},
            title: Text('Экспресс-доставка'),
            subtitle: Text(
              'Курьером в течении 3-х часов\n+ 300 ₽',
              style: TextStyle(
                  fontFamily: 'Noto Sans', fontFamilyFallback: ['Roboto']),
            ),
            secondary: Image.asset('assets/Illustration-Colored-Moto.png'),
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
              maxLines: 3,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Комментарий или пожелания по заказу',
                hintText: 'Комментарий или пожелания по заказу',
              ),
            ),
          ),
/*           CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: false,
            onChanged: (value) {},
            title: Text('Бесконтактная доставка'),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: false,
            onChanged: (value) {},
            title: Text('Разогреть блюда'),
          ), */
          ListTile(
            onTap: () {},
            leading: Icon(
              SeverMetropol.Icon_Checkbox_Checked,
              color: Colors.red[900],
            ),
            title: Text('Бесконтактная доставка'),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              SeverMetropol.Icon_Checkbox_Unchecked,
              color: Colors.red[900],
            ),
            title: Text('Разогреть блюда'),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: GradientButton(
                onPressed: () {
                  context.push('/pay');
                },
                child: const Text('Перейти к оплате')),
          ),
        ],
      ),
    );
  }
}

class SelectDateBottomSheet extends StatelessWidget {
  const SelectDateBottomSheet({
    Key? key,
    required this.slots,
  }) : super(key: key);

  final GraphSlots slots;

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
        SwitchListTile(
          title: const Text('Получить поскорее'),
          value: false,
          onChanged: (newVal) {},
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Дата доставки',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        Row(
          children: [
            SizedBox(width: 16),
            SizedBox.square(
              dimension: 80,
              child: ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ср',
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        '20.10',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            ),
            SizedBox(width: 8),
            SizedBox.square(
              dimension: 80,
              child: OutlinedButton(
                  onPressed: () {},
                  child: Column(
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
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Время доставки',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: slots.times.length,
            itemBuilder: (context, index) => OutlinedButton(
                onPressed: () {}, child: Text(slots.times[index].name)),
            separatorBuilder: (context, index) => SizedBox(width: 8),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(onPressed: () {}, child: const Text('Выбрать')),
        )
      ],
    );
  }
}
