import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/utils.dart';

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
              SizedBox(
                height: 300,
                child: PageView(
                  children: [
                    Image.asset('assets/placeholder/shop.png',
                        fit: BoxFit.cover),
                    ...shop.pictures.map(
                        (picture) => Image.network(picture, fit: BoxFit.cover))
                  ],
                ),
              ),
              Positioned(
                top: 36,
                left: 12,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(32.0, 32.0),
                      shape: const CircleBorder(),
                      primary: Colors.white54,
                      onPrimary: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      SeverMetropol.Icon_Close,
                      color: Theme.of(context).colorScheme.primary,
                    )),
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
                  title: Wrap(
                    children: shop.metroStations
                        .map((metroStation) => Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text('⬤ ',
                                    style: TextStyle(
                                        fontSize: 7.0,
                                        color: hexToColor(
                                            metroStation.colorLine))),
                                Text(metroStation.stationName),
                                SizedBox(width: 10)
                              ],
                            ))
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
                  trailing: Icon(
                    SeverMetropol.Icon_Expand_More,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
