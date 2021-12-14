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
                    left: 16,
                    top: 16,
                    child: Image.asset('assets/Logo Blue.png'),
                  ),
                  Positioned(
                    left: 16,
                    top: 40,
                    child: Image.asset('assets/Logo Red.png'),
                  ),
                  Positioned(
                    right: 22,
                    top: 22,
                    child:
                        Image.asset('assets/Special Icon QR Code Scanner.png'),
                  ),
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
          Row(
            children: [
              ProductCard(
                productImage: 'assets/placeholder/product1/Illustration.png',
                productName: 'Торт «Сезонный» с ягодами',
                productPrice: '420 ₽',
              ),
              ProductCard(
                productImage: 'assets/placeholder/product2/Illustration.png',
                productName: 'Анна Павлова',
                productPrice: '315 ₽',
              ),
            ],
          ),
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
