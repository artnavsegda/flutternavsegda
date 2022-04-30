import 'package:flutter/material.dart';
import 'package:nord/gql.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/utils.dart';

import '../pages/shop/shop.dart';

class ShopTile extends StatelessWidget {
  const ShopTile({
    Key? key,
    this.onTap,
    required this.shop,
  }) : super(key: key);

  final GraphShop shop;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ShopPage(shop: shop)));
      },
      title: Text(
        shop.address ?? 'Нет адреса',
        style: TextStyle(color: Colors.red[900]),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Сегодня открыто до 22:00'),
          Wrap(
            children: [
              ...shop.metroStations
                  .map((metroStation) => Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: hexToColor(metroStation.colorLine),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(metroStation.stationName),
                          SizedBox(width: 8),
                        ],
                      ))
                  .toList()
                  .cast<Widget>(),
            ],
          ),
        ],
      ),
      trailing: Icon(
        SeverMetropol.Icon_Direction,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
