import 'package:flutter/material.dart';
import '../utils.dart';

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
