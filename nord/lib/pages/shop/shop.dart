import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/utils.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key, required this.shop}) : super(key: key);

  final GraphShop shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FractionallySizedBox(
            heightFactor: 0.55,
            child: PageView(
              children: [
                Image.asset('assets/placeholder/shop.png', fit: BoxFit.cover),
                ...shop.pictures
                    .map((picture) => Image.network(picture, fit: BoxFit.cover))
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            left: 0,
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
          ),
          SafeArea(
            child: DraggableScrollableSheet(
                minChildSize: 0.5,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      controller: scrollController,
                      children: [
                        SizedBox(height: 8),
                        ListTile(
                          subtitle: Text(shop.address ??
                              '194358, Санкт-Петербург, проспект Просвещения, 19'),
                          title: Text(shop.name),
                        ),
                        ListTile(
                          title: Text('Метро',
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFF56626C))),
                          subtitle: Wrap(
                            children: shop.metroStations
                                .map((metroStation) => Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: hexToColor(
                                                metroStation.colorLine),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(metroStation.stationName,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                        SizedBox(width: 8),
                                      ],
                                    ))
                                .toList()
                                .cast<Widget>(),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Телефон',
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFF56626C))),
                          subtitle: Text('+7 (812) 611-09-27',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.red[900])),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(4.0)),
                              ),
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () => Navigator.pop(context),
                                      title: Center(
                                          child: Text(
                                        'Режим работы',
                                      )),
                                      trailing: Icon(
                                        SeverMetropol.Icon_Close,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                    ListTile(
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Понедельник'),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: DottedLine(
                                                dashColor: Colors.grey,
                                                dashLength: 2),
                                          )),
                                          Text('09:30–20:00'),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Вторник'),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: DottedLine(
                                                dashColor: Colors.grey,
                                                dashLength: 2),
                                          )),
                                          Text('09:30–20:00'),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          title: const Text('Режим работы',
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFF56626C))),
                          subtitle: Text('Завтра откроется в 10:00',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.red[900])),
                          trailing: Icon(
                            SeverMetropol.Icon_Expand_More,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Построить маршрут')),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text('Заберу заказ в этом заведении')),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
