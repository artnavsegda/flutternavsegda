import 'package:flutter/material.dart';
import 'package:nord/components/components.dart';

class GiftBonusModalSheet extends StatelessWidget {
  const GiftBonusModalSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Подарочные бонусы'),
          SliderCombo(),
          const TextField(),
          SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: const Text('Подарить бонусы'))
        ],
      ),
    );
  }
}
