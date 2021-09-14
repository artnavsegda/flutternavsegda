import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'gql.dart';
import 'pages/productBottomSheet.dart';

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

dynamic getPrice(priceList, priceID) {
  var priceMap = Map.fromIterable(priceList,
      key: (e) => e['characteristicValueID'], value: (e) => e);
  return priceMap[priceID];
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
  const ProductCard({Key? key, this.product, this.onTap}) : super(key: key);

  final product;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x10000000),
                ),
                child: Image.network(
                  product['picture'],
                ),
              ),
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
                    print(resultData);
                  },
                ),
                builder: (runMutation, result) {
                  return Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        print(product['type']);
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
