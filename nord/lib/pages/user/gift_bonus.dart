import 'package:flutter/material.dart';

class GiftBonusModalSheet extends StatelessWidget {
  const GiftBonusModalSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Подарочные бонусы'),
        const TextField(),
        Slider(
          onChanged: (newVal) {},
          value: 0,
        ),
        const Text('Вы можете подарить до 120 бонусов'),
        const TextField(),
        ElevatedButton(onPressed: () {}, child: const Text('Подарить бонусы'))
      ],
    );
  }
}
