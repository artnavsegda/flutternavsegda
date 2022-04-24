import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'gql.dart';

class LoginState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _loggedIn = false;
  String _token = '';

  late Link gqlLink;
  late GraphQLClient gqlClient;

  LoginState(this.prefs) {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
    token = prefs.getString('token') ?? "";
    gqlLink = AuthLink(getToken: () => 'Bearer ' + token).concat(
      HttpLink(
        'https://demo.cyberiasoft.com/severmetropolservice/graphql',
      ),
    );
    gqlClient = GraphQLClient(
      link: gqlLink,
      cache: GraphQLCache(store: HiveStore()),
    );
  }

  bool get loggedIn => _loggedIn;
  set loggedIn(bool value) {
    _loggedIn = value;
    prefs.setBool('LoggedIn', value);
    notifyListeners();
  }

  String get token => _token;
  set token(String newToken) {
    _token = newToken;
    print(newToken);
    prefs.setString('token', newToken);
    notifyListeners();
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
  }
}

class CartState with ChangeNotifier {
  final SharedPreferences prefs;
  List<GraphCartRow> _cart = [];

  CartState(this.prefs) {
    _cart = (jsonDecode(prefs.getString('cartcontent') ?? "[]") as List)
        .map((model) => GraphCartRow.fromJson(model))
        .toList();
  }

  List<GraphCartRow> get cart => _cart;
  set cart(List<GraphCartRow> value) {
    _cart = value;
    prefs.setString('cartcontent', jsonEncode(_cart));
    notifyListeners();
  }

  addToCart({required int id}) {
    if (cart.any((element) => element.productID == id)) return;
    cart.add(GraphCartRow(
      productID: id,
      rowID: 1,
      characteristics: [],
      quantity: 1,
      productName: 'test',
      amount: 100,
    ));
    notifyListeners();
  }
}
