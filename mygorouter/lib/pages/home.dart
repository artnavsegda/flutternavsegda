import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';
import 'main.dart';

const String logoffClient = r'''
mutation logoffClient
{
  logoffClient
  {
    result
    errorMessage
    token
  }
}
''';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LoginState>(context, listen: false).loggedIn) {
      return Mutation(
        options: MutationOptions(
          document: gql(logoffClient),
          onCompleted: (result) {
            Provider.of<LoginState>(context, listen: false).loggedIn = false;
          },
        ),
        builder: (runMutation, result) {
          return TextButton(
            onPressed: () {
              runMutation({});
            },
            child: Text('logout'),
          );
        },
      );
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
  const HomePage({required this.tab, this.catalogID, Key? key})
      : super(key: key);

  final String tab;
  final int? catalogID;

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
        return TextButton(
            onPressed: () {
              context.go('/shop');
            },
            child: Text('Go to catalog'));
      case 'profile':
        return ProfilePage();
      case 'more':
        return Text('more');
      case 'main':
      default:
        return MainPage();
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
