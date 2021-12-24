import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../components/product_card.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddressTile2(),
            //TextField(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Выпечка',
                      style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 32.0,
                    children: [
                      ProductCard(
                        productImage:
                            'assets/placeholder/product1/Illustration.png',
                        productName: 'Торт «Сезонный» с ягодами',
                        productPrice: '420 ₽',
                      ),
                      ProductCard(
                        productImage:
                            'assets/placeholder/product2/Illustration.png',
                        productName: 'Анна Павлова',
                        productPrice: '315 ₽',
                      ),
                      ProductCard(
                        productImage:
                            'assets/placeholder/product1/Illustration.png',
                        productName: 'Торт «Сезонный» с ягодами',
                        productPrice: '420 ₽',
                      ),
                      ProductCard(
                        productImage:
                            'assets/placeholder/product2/Illustration.png',
                        productName: 'Анна Павлова',
                        productPrice: '315 ₽',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
