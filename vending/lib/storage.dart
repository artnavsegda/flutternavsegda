import 'package:flutter/material.dart';

class StoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        title: Text('Получение'),
        leading: Icon(Icons.add_shopping_cart),
        subtitle: Text('Metadata'),
      ),
      ListTile(
        title: Text('Сдача'),
        leading: Icon(Icons.remove_shopping_cart),
        subtitle: Text('Сдача старого товара на склад'),
      ),
      ListTile(
        title: Text('Сумка'),
        leading: Icon(Icons.backpack_outlined),
        subtitle: Text('Cписок товаров по аппаратам для загрузки'),
      ),
    ]);
  }
}
