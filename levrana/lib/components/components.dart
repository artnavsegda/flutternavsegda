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

class GraphCharacteristicsValue {
  GraphCharacteristicsValue(
    this.iD,
    this.value,
    this.comment,
  );
  int iD;
  String value;
  String? comment;

  GraphCharacteristicsValue.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        value = json['value'],
        comment = json['comment'];
}

class GraphCharacteristics {
  GraphCharacteristics(
    this.iD,
    this.name,
    this.type,
    this.isPrice,
    this.values,
  );
  int iD;
  String name;
  String? type;
  bool isPrice;
  List<GraphCharacteristicsValue> values;

  GraphCharacteristics.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        type = json['type'],
        isPrice = json['isPrice'],
        values = List<GraphCharacteristicsValue>.from(json['values']
            .map((model) => GraphCharacteristicsValue.fromJson(model)));
}

class CharacteristicsElement extends StatefulWidget {
  const CharacteristicsElement(
      {Key? key, required this.element, this.onSelected, this.hideOne = false})
      : super(key: key);

  final GraphCharacteristics element;
  final bool hideOne;
  final Function(int)? onSelected;

  @override
  _CharacteristicsElementState createState() => _CharacteristicsElementState();
}

class _CharacteristicsElementState extends State<CharacteristicsElement> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.element.values.length == 1 && widget.hideOne)
      return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.element.type == 'VOLUME' || widget.element.type == 'SIZE')
          Row(children: [
            for (int index = 0; index < widget.element.values.length; index++)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: ChoiceChip(
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      color: selected == index ? Colors.white : Colors.black,
                    ),
                    selectedColor: Colors.green,
                    label: Text(widget.element.values[index].value),
                    selected: selected == index,
                    onSelected: (bool newValue) {
                      widget.onSelected!(index);
                      setState(() {
                        selected = index;
                      });
                    }),
              )
          ])
        else if (widget.element.type == 'COLOR')
          Row(children: [
            for (int index = 0; index < widget.element.values.length; index++)
              GestureDetector(
                onTap: () {
                  widget.onSelected!(index);
                  setState(() {
                    selected = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(3),
                  decoration: ShapeDecoration(
                    color: hexToColor(widget.element.values[index].value),
                    shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                            width: 3,
                            color: selected == index
                                ? Colors.white
                                : hexToColor(
                                    widget.element.values[index].value),
                          ),
                        ) +
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                            width: 2,
                            color:
                                hexToColor(widget.element.values[index].value),
                          ),
                        ),
                  ),
                  child: SizedBox(
                    height: 22,
                    width: 35,
                  ),
                ),
              )
/*             ChoiceChip(
                label: SizedBox(
                  width: 20,
                ), //Text(widget.element['values'][index]['value']),
                selected: selected == index,
                backgroundColor:
                    hexToColor(widget.element['values'][index]['value']),
                selectedColor:
                    hexToColor(widget.element['values'][index]['value']),
                onSelected: (bool newValue) {
                  widget.onSelected!(index);
                  setState(() {
                    selected = index;
                  });
                }) */
          ]),
        if (widget.element.values[selected].comment != null)
          Text("${widget.element.values[selected].comment ?? ''}")
      ],
    );

    switch (widget.element.type) {
      case 'VOLUME':
      case 'SIZE':
        return Row(children: [
          for (int index = 0; index < widget.element.values.length; index++)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ChoiceChip(
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: selected == index ? Colors.white : Colors.black,
                  ),
                  selectedColor: Colors.green,
                  label: Text(widget.element.values[index].value),
                  selected: selected == index,
                  onSelected: (bool newValue) {
                    widget.onSelected!(index);
                    setState(() {
                      selected = index;
                    });
                  }),
            )
        ]);
      case 'COLOR':
        return Row(children: [
          for (int index = 0; index < widget.element.values.length; index++)
            GestureDetector(
              onTap: () {
                widget.onSelected!(index);
                setState(() {
                  selected = index;
                });
              },
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: ShapeDecoration(
                    color: hexToColor(widget.element.values[index].value),
                    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                width: 3,
                                color: selected == index
                                    ? Colors.white
                                    : hexToColor(
                                        widget.element.values[index].value))) +
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                width: 2,
                                color: hexToColor(
                                    widget.element.values[index].value)))),
                child: SizedBox(
                  height: 22,
                  width: 35,
                ),
              ),
            )
/*             ChoiceChip(
                label: SizedBox(
                  width: 20,
                ), //Text(widget.element['values'][index]['value']),
                selected: selected == index,
                backgroundColor:
                    hexToColor(widget.element['values'][index]['value']),
                selectedColor:
                    hexToColor(widget.element['values'][index]['value']),
                onSelected: (bool newValue) {
                  widget.onSelected!(index);
                  setState(() {
                    selected = index;
                  });
                }) */
        ]);
      default:
        return SizedBox.shrink();
        return Text(widget.element.name);
    }
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
