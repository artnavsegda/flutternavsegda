import 'package:flutter/material.dart';
import '../../components/components.dart';

class PayPage extends StatelessWidget {
  const PayPage({Key? key}) : super(key: key);

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
          const AddressTile2(),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text('Способы оплаты',
                style: TextStyle(
                  fontFamily: 'Forum',
                  fontSize: 24,
                )),
          ),
          Row(
            children: [
              OutlinedButton(onPressed: () {}, child: Text('Новая Карта')),
              ElevatedButton(onPressed: () {}, child: Text('На месте')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    TextField(),
                    SizedBox(height: 4),
                    Text('Вы можете использовать до 120 бонусов'),
                  ],
                ),
                Slider(
                  onChanged: (newVal) {},
                  value: 0,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                ElevatedButton(onPressed: () {}, child: const Text('Оплатить')),
          ),
        ],
      ),
    );
  }
}
