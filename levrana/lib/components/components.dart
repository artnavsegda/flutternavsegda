import 'package:flutter/material.dart';
import '../utils.dart';

dynamic getPrice(priceList, priceID) {
  var priceMap = Map.fromIterable(priceList,
      key: (e) => e['characteristicValueID'], value: (e) => e);
  return priceMap[priceID];
}

class CheckboxTitle extends StatelessWidget {
  const CheckboxTitle(
      {Key? key, this.title = "", required this.value, required this.onChanged})
      : super(key: key);

  final String title;
  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24.0,
            width: 32.0,
            child: LevranaCheckbox(
              value: value,
              onChanged: onChanged,
            ),
          ),
          Flexible(
            child: InkWell(
                onTap: () {
                  onChanged(!value);
                },
                child: Text(title, style: TextStyle(fontSize: 14))),
          )
        ],
      ),
    );
  }
}

class LevranaCheckboxTitle extends StatelessWidget {
  const LevranaCheckboxTitle({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.title,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onChanged!(!value),
        child: Row(children: [
          value
              ? Image.asset('assets/checkbox/checked.png')
              : Image.asset('assets/checkbox/unchecked.png'),
          SizedBox(
            width: 10,
          ),
          title
        ]));
  }
}

class LevranaCheckbox extends StatelessWidget {
  const LevranaCheckbox(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onChanged!(!value),
        child: value
            ? Image.asset('assets/checkbox/checked.png')
            : Image.asset('assets/checkbox/unchecked.png'));
  }
}

class LevranaBigCheckbox extends StatelessWidget {
  const LevranaBigCheckbox(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onChanged!(!value),
        child: value
            ? Image.asset('assets/bigCheckbox/checked.png')
            : Image.asset('assets/bigCheckbox/unchecked.png'));
  }
}

class RedLine extends CustomPainter {
  @override
  void paint(canvas, size) {
    canvas.drawLine(
        Offset(0, size.height),
        Offset(size.width, 0),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}

class TextCharacteristic extends StatelessWidget {
  const TextCharacteristic({Key? key, this.element}) : super(key: key);

  final element;

  @override
  Widget build(BuildContext context) {
    if (element['type'] == 'TEXT')
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(element['name'], style: TextStyle(color: Colors.grey)),
        Text(element['values']
            .map((element) => element['value'])
            .reduce((value, element) => value + ', ' + element))
      ]);
    else
      return Container();
  }
}

class ShopCard extends StatelessWidget {
  const ShopCard({
    required this.shop,
    Key? key,
  }) : super(key: key);

  final shop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.network(
              shop['pictures'][0],
              fit: BoxFit.cover,
              width: 80,
              height: 80,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop['name'],
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                Text(shop['address'], style: TextStyle(fontSize: 12.0)),
                ...shop['metroStations']
                    .map((metroStation) {
                      return Row(
                        children: [
                          Text('⬤ ',
                              style: TextStyle(
                                  fontSize: 7.0,
                                  color:
                                      hexToColor(metroStation['colorLine']))),
                          Expanded(
                            child: Text(metroStation['stationName'],
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ],
                      );
                    })
                    .toList()
                    .cast<Widget>(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
