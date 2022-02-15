import 'package:flutter/material.dart';
import '../../gql.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key, required this.shop}) : super(key: key);

  final GraphShop shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Image.asset('assets/placeholder/shop.png'),
              Positioned(
                top: 36,
                left: 12,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(32.0, 32.0),
                      shape: const CircleBorder(),
                      primary: Colors.white54, // <-- Button color
                      onPrimary: Colors.red, // <-- Splash color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/Icon-Close.png')),
              )
            ],
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  isThreeLine: true,
                  subtitle: Text(shop.address ??
                      '194358, Санкт-Петербург, проспект Просвещения, 19'),
                  title: Text(shop.name),
                ),
                ListTile(
                  subtitle: Text('Метро'),
                  title: Row(
                    children: shop.metroStations
                        .map((metroStation) {
                          return Row(
                            children: [
                              Text('⬤ ',
                                  style: TextStyle(
                                      fontSize: 7.0,
                                      color:
                                          hexToColor(metroStation.colorLine))),
                              Text(metroStation.stationName),
                            ],
                          );
                        })
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
                Divider(),
                ListTile(
                  subtitle: Text('Телефон'),
                  title: Text('+7 (812) 611-09-27'),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ListTile(
                              title: Center(
                                  child: Text(
                                'Режим работы',
                              )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Понедельник'),
                                Text('09:30–20:00'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Вторник'),
                                Text('09:30–20:00'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Среда'),
                                Text('09:30–20:00'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Четверг'),
                                Text('09:30–20:00'),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  subtitle: const Text('Режим работы'),
                  title: const Text('Завтра откроется в 10:00'),
                  trailing: Image.asset('assets/Icon-Expand-More.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text('Построить маршрут')),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text('Заберу заказ в этом заведении')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
