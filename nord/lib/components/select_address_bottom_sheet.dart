import 'package:flutter/material.dart';
import '../pages/address/address.dart';

class SelectAddressBottomSheet extends StatelessWidget {
  const SelectAddressBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/Illustration-New-Address.png'),
        const Text('Адрес доставки или ближайшего к вам кафе'),
        const Text(
            'Чтобы предложить полный и точный ассортимент товаров, нам важно знать, где Вы собираетесь их получать'),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddressPage()));
            },
            child: Text('Указать адрес')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Позже'))
      ],
    );
  }
}
