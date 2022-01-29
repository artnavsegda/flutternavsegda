import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import '../sever_metropol_icons.dart';
import 'catalog/catalog.dart';
import 'home/home.dart';
import 'more/more.dart';
import 'shopping/shopping.dart';
import 'user/user.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.tab}) : super(key: key);

  final String tab;

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
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 5.0,
                offset: Offset(0.0, 5),
              ),
              // BoxShadow(
              //   color: Color(0x1F000000),
              //   blurRadius: 14,
              //   offset: Offset(0.0, 3),
              // ),
              BoxShadow(
                color: Color(0x24000000),
                blurRadius: 10,
                offset: Offset(0.0, 8),
              )
            ],
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            onTap: (index) {
              _tabController.animateTo(index);
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.red.shade900,
            currentIndex: _tabController.index,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(SeverMetropol.Icon_Home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(SeverMetropol.Icon_Grid_View),
                label: 'Catalog',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  position: BadgePosition.topEnd(top: -12, end: -8),
                  child: const Icon(SeverMetropol.Icon_Shopping_Bag),
                  badgeColor: Colors.red.shade900,
                  badgeContent: const Text(
                    '5',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                label: 'Shopping',
              ),
              const BottomNavigationBarItem(
                icon: Icon(SeverMetropol.Icon_Account_Circle),
                label: 'User',
              ),
              const BottomNavigationBarItem(
                icon: Icon(SeverMetropol.Icon_More_Horizontal),
                label: 'More',
              ),
            ],
          ),
        ));
  }
}
