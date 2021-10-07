import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import 'gql.dart';
import 'pages/product/productBottomSheet.dart';

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

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

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product, this.onTap})
      : super(key: key);

  final product;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                color: Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(6.0),
              )),
              InkWell(
                onTap: onTap,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: product['picture'])),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                    ),
                    width: 40,
                    height: 40,
                  )),
              Mutation(
                  options: MutationOptions(
                    document: gql(cartAdd),
                    onCompleted: (resultData) {
                      //print(resultData);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Добавлен в корзину'),
                      ));
                    },
                  ),
                  builder: (runMutation, result) {
                    return Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          //print(product['type']);
                          if (product['type'] != 'SIMPLE')
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: const Radius.circular(16.0)),
                              ),
                              context: context,
                              builder: (context) {
                                return ProductBottomSheet(
                                    product: product, id: product['iD']);
                              },
                            );
                          else
                            runMutation({'productID': product['iD']});
                        },
                        child: Image.asset(
                          'assets/ic-24/icon-24-shopping.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
        Row(
          children: product['attributes']
              .map((element) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      labelStyle:
                          TextStyle(fontSize: 16.0, color: Colors.white),
                      selectedColor: hexToColor(element['color']),
                      selected: true,
                      onSelected: (e) {},
                      label: Text(element['name'])),
                );
              })
              .toList()
              .cast<Widget>(),
        ),
        Text(product['name']),
      ],
    );
  }
}

class CharacteristicsElement extends StatefulWidget {
  const CharacteristicsElement(
      {Key? key, this.element, this.onSelected, this.hideOne = false})
      : super(key: key);

  final element;
  final bool hideOne;
  final Function(int)? onSelected;

  @override
  _CharacteristicsElementState createState() => _CharacteristicsElementState();
}

class _CharacteristicsElementState extends State<CharacteristicsElement> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.element['values'].length == 1 && widget.hideOne)
      return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.element['type'] == 'VOLUME' ||
            widget.element['type'] == 'SIZE')
          Row(children: [
            for (int index = 0;
                index < widget.element['values'].length;
                index++)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: ChoiceChip(
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      color: selected == index ? Colors.white : Colors.black,
                    ),
                    selectedColor: Colors.green,
                    label: Text(widget.element['values'][index]['value']),
                    selected: selected == index,
                    onSelected: (bool newValue) {
                      widget.onSelected!(index);
                      setState(() {
                        selected = index;
                      });
                    }),
              )
          ])
        else if (widget.element['type'] == 'COLOR')
          Row(children: [
            for (int index = 0;
                index < widget.element['values'].length;
                index++)
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
                      color:
                          hexToColor(widget.element['values'][index]['value']),
                      shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(
                                  width: 3,
                                  color: selected == index
                                      ? Colors.white
                                      : hexToColor(widget.element['values']
                                          [index]['value']))) +
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(
                                  width: 2,
                                  color: hexToColor(widget.element['values']
                                      [index]['value'])))),
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
        if (widget.element['values'][selected]['comment'] != null)
          Text("${widget.element['values'][selected]['comment'] ?? ''}")
      ],
    );

    switch (widget.element['type']) {
      case 'VOLUME':
      case 'SIZE':
        return Row(children: [
          for (int index = 0; index < widget.element['values'].length; index++)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ChoiceChip(
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: selected == index ? Colors.white : Colors.black,
                  ),
                  selectedColor: Colors.green,
                  label: Text(widget.element['values'][index]['value']),
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
          for (int index = 0; index < widget.element['values'].length; index++)
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
                    color: hexToColor(widget.element['values'][index]['value']),
                    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                width: 3,
                                color: selected == index
                                    ? Colors.white
                                    : hexToColor(widget.element['values'][index]
                                        ['value']))) +
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                                width: 2,
                                color: hexToColor(widget.element['values']
                                    [index]['value'])))),
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
        return Text(widget.element['name']);
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
