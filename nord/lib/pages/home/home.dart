import 'package:flutter/material.dart';
import '../../components/select_address_bottom_sheet.dart';
import '../../components/product_card.dart';
import 'action_card.dart';
import 'discount_card.dart';
import '../map/map.dart';

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
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
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
              const ProductCard(
                productImage: 'assets/placeholder/product1/Illustration.png',
                productName: 'Торт «Сезонный» с ягодами',
                productPrice: '420 ₽',
              ),
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
            decoration: const BoxDecoration(
              image: const DecorationImage(
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
                  child: ElevatedButton.icon(
                    label: const ImageIcon(AssetImage('assets/Icon-East.png')),
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
        ],
      ),
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
