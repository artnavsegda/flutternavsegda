import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/gradient_button.dart';

import '../../components/components.dart';
import 'pay.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

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
                          ElevatedButton(
                              onPressed: () {}, child: const Text('20.10')),
                          OutlinedButton(
                              onPressed: () {}, child: const Text('21.10')),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Время доставки',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                              onPressed: () {},
                              child: const Text('09:00–14:00')),
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text('14:00–18:00')),
                          OutlinedButton(
                              onPressed: () {},
                              child: const Text('18:00–21:00')),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text('Выбрать')),
                      )
                    ],
                  );
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
            subtitle: Text('Курьером в течении 3-х часов\n+ 300 ₽'),
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
              decoration: InputDecoration(
                labelText: 'Комментарий или пожелания по заказу',
              ),
            ),
          ),
          CheckboxListTile(
            value: false,
            onChanged: (value) {},
            title: Text('Бесконтактная доставка'),
          ),
          CheckboxListTile(
            value: false,
            onChanged: (value) {},
            title: Text('Разогреть блюда'),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GradientButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PayPage()));
            },
            child: const Text('Перейти к оплатите')),
      ),
    );
  }
}
