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
              SliderTheme(
                data: SliderThemeData(
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 2.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                ),
                child: Slider(
                  inactiveColor: Colors.grey,
                  onChanged: (newVal) {},
                  value: 0.2,
                ),
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
