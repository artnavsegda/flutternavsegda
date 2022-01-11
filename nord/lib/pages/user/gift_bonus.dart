import 'package:flutter/material.dart';

class GiftBonusModalSheet extends StatelessWidget {
  const GiftBonusModalSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Подарочные бонусы'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  TextField(),
                  SizedBox(height: 4),
                  Text('Вы можете подарить до 120 бонусов'),
                ],
              ),
              Slider(
                onChanged: (newVal) {},
                value: 0,
              ),
            ],
          ),
        ),
        const TextField(),
        ElevatedButton(onPressed: () {}, child: const Text('Подарить бонусы'))
      ],
    );
  }
}
