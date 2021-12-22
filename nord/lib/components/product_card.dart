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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductPage()));
                },
                child: Image.asset(productImage)),
            Text(productName),
            Text(
              productPrice,
              style: TextStyle(fontFamily: 'Forum', fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
