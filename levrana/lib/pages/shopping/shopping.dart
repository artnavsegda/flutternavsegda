import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cart.dart';
import 'favorites.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: TabBar(
                  unselectedLabelColor: Colors.black38,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Montserrat',
                  ),
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Montserrat',
                  ),
                  tabs: [
                    Tab(text: "Корзина"),
                    Tab(text: "Отложенные"),
                  ]),
            ),
          ),
          body: TabBarView(
            children: [ShoppingCartPage(), FavouritesPage()],
          ),
        ),
      ),
    );
  }
}
