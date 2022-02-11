import 'package:flutter/material.dart';
import '../pages/address/address.dart';
import '../../components/gradient_button.dart';

class SelectAddressBottomSheet extends StatelessWidget {
  const SelectAddressBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/Illustration-New-Address.png',
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Адрес доставки или ближайшего к вам кафе',
                style: TextStyle(fontFamily: 'Forum', fontSize: 24),
              ),
              const SizedBox(height: 8),
              const Text(
                  'Чтобы предложить полный и точный ассортимент товаров, нам важно знать, где Вы собираетесь их получать'),
              const SizedBox(height: 24),
              GradientButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddressPage()));
                  },
                  child: const Text('Указать адрес')),
              const SizedBox(height: 8),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Позже')),
            ],
          ),
        )
      ],
    );
  }
}
