import 'package:flutter/material.dart';
import '../../components/components.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Оформление заказа'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AddressTile2(),
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
                      ListTile(
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
                      Text('Дата доставки'),
                      Text('Время доставки'),
                      Row(
                        children: [
                          OutlinedButton(
                              onPressed: () {}, child: Text('09:00–14:00')),
                          ElevatedButton(
                              onPressed: () {}, child: Text('14:00–18:00')),
                          OutlinedButton(
                              onPressed: () {}, child: Text('18:00–21:00')),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            onPressed: () {}, child: Text('Выбрать')),
                      )
                    ],
                  );
                },
              );
            },
            leading: Image.asset('assets/Illustration-Colored-Clocks.png'),
            title: Text(
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
          Text('Способы оплаты'),
          TextField(),
          ElevatedButton(onPressed: () {}, child: Text('Оплатить')),
        ],
      ),
    );
  }
}
