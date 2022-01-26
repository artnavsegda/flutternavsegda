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
        title: const Text('Оплата'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            child:
                ElevatedButton(onPressed: () {}, child: const Text('Оплатить')),
          ),
        ],
      ),
    );
  }
}
