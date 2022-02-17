import 'package:flutter/material.dart';
import 'package:nord/gql.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/utils.dart';

import '../pages/shop/shop.dart';

class ShopTile extends StatelessWidget {
  const ShopTile({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final GraphShop shop;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ShopPage(shop: shop)));
      },
      title: Text(
        shop.address ?? 'Невский, 6',
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
                          Text('⬤ ',
                              style: TextStyle(
                                  fontSize: 7.0,
                                  color: hexToColor(metroStation.colorLine))),
                          Text(metroStation.stationName),
                          SizedBox(width: 10)
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
