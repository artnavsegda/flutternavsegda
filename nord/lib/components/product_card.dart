import 'package:flutter/material.dart';
import '../pages/product/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProductPage()));
            },
            child: Image.asset('assets/placeholder/product1/Illustration.png')),
        Text('Кекс английский с сухофруктами'),
        Text('420 ₽'),
      ],
    );
  }
}
