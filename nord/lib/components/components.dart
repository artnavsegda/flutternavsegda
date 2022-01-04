import 'package:flutter/material.dart';
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
        SizedBox(child: Image.asset('assets/Icon-Checkbox-Checked.png')),
        SizedBox(width: 38),
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
      trailing: Image.asset('assets/Icon-Expand-More.png'),
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
      title: Text(
        "Увидимся в кафе",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 10,
        ),
      ),
      subtitle: Text(
        "5-я Советская, 15-17/12",
        style: TextStyle(
          color: Colors.red[900],
          fontSize: 16,
        ),
      ),
      trailing: Image.asset('assets/Icon-Expand-More.png'),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({Key? key}) : super(key: key);

  const factory GradientButton.icon() = _GradientButtonWithIcon;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _GradientButtonWithIcon extends GradientButton {
  const _GradientButtonWithIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
