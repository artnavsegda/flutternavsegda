import 'package:flutter/material.dart';
import 'cart_is_empty.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CartIsEmpty();
  }
}
