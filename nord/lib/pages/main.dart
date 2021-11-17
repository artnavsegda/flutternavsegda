import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
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
          children: [
            Text('1'),
            Text('2'),
            Text('3'),
            Text('4'),
            Text('5'),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon Home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon Grid View.png')),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon Shopping Bag.png')),
              label: 'Shopping',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon Account Circle.png')),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Icon More Horizontal.png')),
              label: 'More',
            ),
          ],
        ));
  }
}
