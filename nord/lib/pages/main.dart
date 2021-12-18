import 'package:flutter/material.dart';

import 'catalog/catalog.dart';
import 'home/home.dart';
import 'more/more.dart';
import 'shopping/shopping.dart';
import 'user/user.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: const [
            HomePage(),
            CatalogPage(),
            ShoppingPage(),
            UserPage(),
            MorePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _tabController.animateTo(index);
          },
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.red,
          currentIndex: _tabController.index,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon-Home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon-Grid-View.png')),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon-Shopping-Bag.png')),
              label: 'Shopping',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon-Account-Circle.png')),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon-More-Horizontal.png')),
              label: 'More',
            ),
          ],
        ));
  }
}
