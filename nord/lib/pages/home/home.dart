import 'package:flutter/material.dart';
import '../../components/select_address_bottom_sheet.dart';
import '../../components/product_card.dart';
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
            trailing: Image.asset('assets/Icon Expand More.png'),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xffCD0643), Color(0xffB0063A)])),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: ElevatedButton(
                      child: Text('Войти'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QrPage()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Text("Акции"),
          const Text("Новинки"),
          ProductCard(),
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
