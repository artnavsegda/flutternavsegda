import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'select_address_bottom_sheet.dart';

class NordCheckboxTile extends StatelessWidget {
  const NordCheckboxTile({
    Key? key,
    required this.title,
  }) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          SeverMetropol.Icon_Checkbox_Checked,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 38),
        Flexible(child: title)
      ],
    );
  }
}

class AddressTile extends StatelessWidget {
  const AddressTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return const SelectAddressBottomSheet();
          },
        );
      },
      leading: Image.asset('assets/Illustration-Colored-Delivery-Options.png'),
      title: const Text("Адрес доставки или кафе"),
      trailing: Icon(
        SeverMetropol.Icon_Expand_More,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class AddressTile2 extends StatelessWidget {
  const AddressTile2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return const SelectAddressBottomSheet();
          },
        );
      },
      leading: Image.asset('assets/Illustration-Colored-Cafe.png'),
      title: const Text(
        "Увидимся в кафе",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 10,
        ),
      ),
      subtitle: Text(
        "5-я Советская, 15-17/12",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        SeverMetropol.Icon_Expand_More,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class RedLine extends CustomPainter {
  @override
  void paint(canvas, size) {
    canvas.drawLine(
        Offset(0, size.height),
        Offset(size.width, 0),
        Paint()
          ..color = Colors.red.shade900
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}

class SpecialCondition extends StatelessWidget {
  const SpecialCondition({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(stops: const [
          0.01,
          0.01
        ], colors: [
          Theme.of(context).colorScheme.primary,
          const Color(0xFFEFF3F4)
        ]),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
