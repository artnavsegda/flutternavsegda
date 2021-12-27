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
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductPage()));
                  },
                  child: Image.asset(productImage)),
              Positioned(
                right: 0,
                bottom: 0,
                child: IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/Icon-Add-to-Shopping-Bag.png')),
              ),
            ],
          ),
          Text(productName),
          Text(
            productPrice,
            style: TextStyle(fontFamily: 'Forum', fontSize: 24),
          ),
        ],
      ),
    );
  }
}
