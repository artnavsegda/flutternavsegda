import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';

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

class GraphProductAttribute {
  GraphProductAttribute({
    required this.iD,
    required this.name,
    required this.color,
  });
  int iD;
  String name;
  String color;

  GraphProductAttribute.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        color = json['color'];
}

class GraphProduct {
  GraphProduct({
    required this.iD,
    this.type,
    required this.familyID,
    required this.topCatalogID,
    required this.name,
    this.picture,
    required this.isFavorite,
    required this.favorites,
    required this.stickerPictures,
    required this.attributes,
  });
  int iD;
  String? type;
  int familyID;
  int topCatalogID;
  String name;
  String? picture;
  bool isFavorite;
  int favorites;
  List<String> stickerPictures;
  List<GraphProductAttribute> attributes;

  GraphProduct.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        type = json['type'],
        familyID = json['familyID'],
        topCatalogID = json['topCatalogID'],
        name = json['name'],
        picture = json['picture'],
        isFavorite = json['isFavorite'],
        favorites = json['favorites'],
        stickerPictures = List<String>.from(json['stickerPictures']),
        attributes = List<GraphProductAttribute>.from(json['attributes']
            .map((model) => GraphProductAttribute.fromJson(model)));
}

class GraphTopBlock {
  GraphTopBlock({
    required this.iD,
    required this.name,
    required this.products,
  });
  int iD;
  String name;
  List<GraphProduct> products;

  GraphTopBlock.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        products = List<GraphProduct>.from(
            json['products'].map((model) => GraphProduct.fromJson(model)));
}

const String getTopBlocks = r'''
query getTopBlocks {
  getTopBlocks
  {
    iD
    name
    products {
      iD
      type
      familyID
      topCatalogID
      name
      picture
      isFavorite
      favorites
      stickerPictures
      attributes {
        iD
        name
        color
      }
    }
  }
}
''';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getTopBlocks),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading || result.hasException) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<GraphTopBlock> topBlocks = List<GraphTopBlock>.from(result
            .data!['getTopBlocks']
            .map((model) => GraphTopBlock.fromJson(model)));

        return ListView.builder(
            itemCount: topBlocks.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(topBlocks[index].name),
                  Column(
                      children: topBlocks[index]
                          .products
                          .map(
                            (e) => ListTile(
                              title: Text(e.name),
                              onTap: () {
                                context.goNamed('product', params: {
                                  'tab': 'main',
                                  'id': '${e.iD}',
                                });
                              },
                            ),
                          )
                          .toList()
                          .cast<Widget>()),
                ],
              );
            });
      },
    );
  }
}
