import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/components.dart';

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
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
        title: const Text('Оплата'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(width: 16),
              OutlinedButton(
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
              SizedBox(width: 8),
              ElevatedButton(
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
                            'На\nместе',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          left: 4,
                          top: 4,
                          child: Icon(
                            SeverMetropol.Icon_Checkbox_Unchecked,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SliderCombo(),
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
