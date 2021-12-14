import 'package:flutter/material.dart';
import '../pages/product/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
  }) : super(key: key);

  final String productName;
  final String productImage;
  final String productPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProductPage()));
            },
            child: Image.asset(productImage)),
        Text(productName),
        Text(productPrice),
      ],
    );
  }
}
