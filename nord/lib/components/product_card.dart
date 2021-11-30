import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/placeholder/product1/Illustration.png'),
        Text('Кекс английский с сухофруктами'),
        Text('420 ₽'),
      ],
    );
  }
}
