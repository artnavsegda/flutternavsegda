import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/utils.dart';
import 'package:nord/login_state.dart';

const List<String> weekNames = [
  'Нульник',
  'Понедельник',
  'Вторник',
  'Среда',
  'Четверг',
  'Пятница',
  'Суббота',
  'Воскресенье',
];

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key, required this.shop}) : super(key: key);

  final GraphShop shop;

  @override
  Widget build(BuildContext context) {
    NumberFormat f = NumberFormat("00");
    return Scaffold(
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.34,
            child: PageView(
              children: [
                ...shop.pictures.map((picture) => CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: picture,
                    placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: const Color(0xFFECECEC),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                    errorWidget: (context, url, error) => Container(
                          color: const Color(0xFFECECEC),
                          child:
                              Center(child: const Icon(Icons.no_photography)),
                        )))
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
                initialChildSize: 0.7,
                minChildSize: 0.7,
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
                          title: Text(shop.name ?? 'Просвещения, 19 (ТК Норд)'),
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
                                    ...shop.openingHours.map((e) => ListTile(
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(weekNames[e.weekDay]),
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: DottedLine(
                                                    dashColor: Colors.grey,
                                                    dashLength: 2),
                                              )),
                                              Text(
                                                  '${e.start! ~/ 100}:${f.format(e.start! % 100)}–${e.finish! ~/ 100}:${f.format(e.finish! % 100)}'),
                                            ],
                                          ),
                                        )),
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
                              onPressed: () {
                                MapsLauncher.launchCoordinates(
                                    shop.latitude ?? 0, shop.longitude ?? 0);
                              },
                              child: const Text('Построить маршрут')),
                        ),
                        TextButton(
                            onPressed: () {
                              context.read<FilterState>().update(
                                  newActiveShop: shop, newFilter: 'PICK_UP');
                              context.go('/main');
                            },
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
