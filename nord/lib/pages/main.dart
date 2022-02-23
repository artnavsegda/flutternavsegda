import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../sever_metropol_icons.dart';
import 'catalog/catalog.dart';
import 'home/home.dart';
import 'more/more.dart';
import 'shopping/shopping.dart';
import 'user/user.dart';
import 'user/unregistered.dart';
import '../login_state.dart';

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
    _tabController = TabController(
        vsync: this, length: 5, initialIndex: int.parse(widget.tab));
    _tabController.addListener(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        context.goNamed('home', params: {'tab': '${_tabController.index}'});
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    //_controller.index = HomePage.indexFrom(widget.tab);
    _tabController.animateTo(int.parse(widget.tab));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            HomePage(),
            CatalogPage(),
            Provider.of<LoginState>(context, listen: false).loggedIn
                ? ShoppingPage()
                : Unregistered(),
            Provider.of<LoginState>(context, listen: false).loggedIn
                ? UserPage()
                : Unregistered(),
            MorePage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
              // BoxShadow(
              //   color: Color(0x1F000000),
              //   blurRadius: 14,
              //   offset: Offset(0, 3),
              // ),
              BoxShadow(
                color: Color(0x24000000),
                blurRadius: 10,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            onTap: (index) {
              context.goNamed('home', params: {'tab': '$index'});
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.grey,
            unselectedItemColor: Theme.of(context).colorScheme.primary,
            currentIndex: int.parse(widget.tab),
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
                icon: Consumer<CartState>(builder: (context, model, child) {
                  return Badge(
                    position: BadgePosition.topEnd(top: -12, end: -8),
                    showBadge: model.cartAmount != 0,
                    child: const Icon(SeverMetropol.Icon_Shopping_Bag),
                    badgeColor: Theme.of(context).colorScheme.primary,
                    badgeContent: Text(
                      '${model.cartAmount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  );
                }),
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
