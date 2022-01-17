import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LoginState>(context, listen: false).loggedIn) {
      return TextButton(onPressed: () {}, child: Text('logout'));
    } else {
      return TextButton(
          onPressed: () {
            Provider.of<LoginState>(context, listen: false).skipLogin = false;
          },
          child: Text('login'));
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({required this.tab, Key? key}) : super(key: key);

  final String tab;

  static int indexFrom(String tab) {
    switch (tab) {
      case 'shop':
        return 1;
      case 'cart':
        return 2;
      case 'profile':
        return 3;
      case 'more':
        return 4;
      case 'main':
      default:
        return 0;
    }
  }

  static Widget pageFrom(String tab, BuildContext context) {
    switch (tab) {
      case 'shop':
        return Text('shop');
      case 'cart':
        return Text('cart');
      case 'profile':
        return ProfilePage();
      case 'more':
        return Text('more');
      case 'main':
      default:
        return Text('main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pageFrom(tab, context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: indexFrom(tab),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more),
            label: 'More',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/main');
              break;
            case 1:
              context.go('/shop');
              break;
            case 2:
              context.go('/cart');
              break;
            case 3:
              context.go('/profile');
              break;
            case 4:
              context.go('/more');
              break;
          }
        },
      ),
    );
  }
}
