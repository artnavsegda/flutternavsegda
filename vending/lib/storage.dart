import 'package:flutter/material.dart';

class StoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        title: Text('Получение'),
        leading: Icon(Icons.add_shopping_cart),
        subtitle: Text('Получение товара по накладной'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => FullScreenDialog(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
      ListTile(
        title: Text('Сдача'),
        leading: Icon(Icons.remove_shopping_cart),
        subtitle: Text('Сдача старого товара на склад'),
        onTap: () {},
      ),
      ListTile(
        title: Text('Сумка'),
        leading: Icon(Icons.backpack_outlined),
        subtitle: Text('Cписок товаров по аппаратам для загрузки'),
        onTap: () {},
      ),
    ]);
  }
}

class FullScreenDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Получение"), actions: <Widget>[
        TextButton(
          onPressed: () {},
          child: Text("Сдать"),
        ),
      ]),
      body: Center(
        child: Text("Full-screen dialog"),
      ),
    );
  }
}
