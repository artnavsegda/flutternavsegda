import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';
import 'main.dart';
import '../gql.dart';

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
            context.push('/login');
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
            //Provider.of<LoginState>(context, listen: false).skipLogin = false;
            context.push('/login');
          },
          child: Text('login'));
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({required this.tab, Key? key}) : super(key: key);

  final String tab;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 5, vsync: this, initialIndex: int.parse(widget.tab));
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
      body: TabBarView(controller: _tabController, children: [
        MainPage(),
        Center(child: Text('shop')),
        Center(
          child: TextButton(
              onPressed: () {
                context.go('/shop');
              },
              child: Text('Go to catalog')),
        ),
        ProfilePage(),
        Center(child: Text('more')),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: int.parse(widget.tab),
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
          context.goNamed('home', params: {'tab': '$index'});
        },
      ),
    );
  }
}
