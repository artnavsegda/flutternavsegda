import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return SelectAddressBottomSheet();
                },
              );
            },
            leading:
                Image.asset('assets/Illustration Colored Delivery Options.png'),
            title: Text("Адрес доставки или кафе"),
          ),
          Text("Акции"),
        ],
      ),
    );
  }
}

class SelectAddressBottomSheet extends StatelessWidget {
  const SelectAddressBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/Illustration New Address.png'),
          const Text('Адрес доставки или ближайшего к вам кафе'),
          const Text(
              'Чтобы предложить полный и точный ассортимент товаров, нам важно знать, где Вы собираетесь их получать'),
          ElevatedButton(onPressed: () {}, child: Text('Указать адрес')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Позже'))
        ],
      ),
    );
  }
}
