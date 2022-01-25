import 'package:flutter/material.dart';
import '../../components/components.dart';

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
            icon: Image.asset('assets/Icon-West.png')),
        title: const Text('Оформление заказа'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              'Время доставки',
              style: TextStyle(fontFamily: 'Forum', fontSize: 24),
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
                        child: const Text('Дата доставки',
                            style: TextStyle(
                              fontFamily: 'Forum',
                              fontSize: 24,
                            )),
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
                        child: const Text('Время доставки',
                            style: TextStyle(
                              fontFamily: 'Forum',
                              fontSize: 24,
                            )),
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
                color: Colors.red[900],
                fontSize: 16,
              ),
            ),
            trailing: Image.asset('assets/Icon-Expand-More.png'),
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
              style: TextStyle(fontFamily: 'Forum', fontSize: 24),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: () {}, child: const Text('Перейти к оплатите')),
          ),
        ],
      ),
    );
  }
}
