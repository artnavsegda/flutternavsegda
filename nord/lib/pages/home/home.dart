import 'package:flutter/material.dart';
import '../../components/product_card.dart';
import 'action_card.dart';
import 'discount_card.dart';
import '../map/map.dart';
import '../../components/components.dart';
import '../../components/gradient_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const AddressTile2(),
          const CardLoggedIn(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Акции",
                style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
          ),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 12,
                ),
                const ActionCard(
                    actionName: 'Взрывная весна!\nОткрой новые вкусы сладко...',
                    actionImage: 'assets/placeholder/action/Illustration.png',
                    actionDate: '15 октября–27 ноября'),
                const ActionCard(
                    actionName: 'Шокодень',
                    actionImage: 'assets/placeholder/cake.png',
                    actionDate: 'Только до 31 октября'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Новинки",
                style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 16,
              ),
              const ProductCard(
                productImage: 'assets/placeholder/product1/Illustration.png',
                productName: 'Торт «Сезонный» с ягодами',
                productPrice: '420 ₽',
              ),
              SizedBox(width: 8),
              const ProductCard(
                productImage: 'assets/placeholder/product2/Illustration.png',
                productName: 'Анна Павлова',
                productPrice: '315 ₽',
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Кондитерские и кафе",
                style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000), //Color.fromRGBO(0, 0, 0, 0.12),
                  blurRadius: 20.0,
                  offset: Offset(0.0, 4.0),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                image: const DecorationImage(
                  image: AssetImage("assets/Map.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        //elevation: 0.0,
                        visualDensity: VisualDensity.compact,
                      ),
                      label:
                          const ImageIcon(AssetImage('assets/Icon-East.png')),
                      icon: const Text('Показать заведения на карте'),
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
          ),
        ],
      ),
    );
  }
}
