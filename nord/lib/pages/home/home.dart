import 'package:flutter/material.dart';
import '../../components/select_address_bottom_sheet.dart';
import '../../components/product_card.dart';
import 'qr.dart';
import 'action_card.dart';
import '../map/map.dart';

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
                Image.asset('assets/Illustration-Colored-Delivery-Options.png'),
            title: const Text("Адрес доставки или кафе"),
            trailing: Image.asset('assets/Icon-Expand-More.png'),
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
                    child: Image.asset('assets/Logo-Blue.png'),
                  ),
                  Positioned(
                    left: 16,
                    top: 40,
                    child: Image.asset('assets/Logo-Red.png'),
                  ),
                  Positioned(
                    right: 22,
                    top: 22,
                    child:
                        Image.asset('assets/Special-Icon-QR-Code-Scanner.png'),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
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
          const Text("Акции",
              style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
          SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ActionCard(
                    actionName: 'Взрывная весна!\nОткрой новые вкусы сладко...',
                    actionImage: 'assets/placeholder/action/Illustration.png',
                    actionDate: '15 октября–27 ноября'),
                ActionCard(
                    actionName: 'Шокодень',
                    actionImage: 'assets/placeholder/cake.png',
                    actionDate: 'Только до 31 октября'),
              ],
            ),
          ),
          const Text("Новинки",
              style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          const Text("Кондитерские и кафе",
              style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Map.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    child: Text('Показать заведения на карте'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapPage()));
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
