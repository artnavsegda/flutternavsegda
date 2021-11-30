import 'package:flutter/material.dart';
import '../../components/select_address_bottom_sheet.dart';
import 'qr.dart';

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
                  return const SelectAddressBottomSheet();
                },
              );
            },
            leading:
                Image.asset('assets/Illustration Colored Delivery Options.png'),
            title: const Text("Адрес доставки или кафе"),
          ),
          Container(
            child: ElevatedButton(
              child: Text('Войти'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const QrPage()));
              },
            ),
          ),
          const Text("Акции"),
          const Text("Новинки"),
          const Text("Кондитерские и кафе"),
          Container(
            child: ElevatedButton(
              child: Text('Показать заведения на карте'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
