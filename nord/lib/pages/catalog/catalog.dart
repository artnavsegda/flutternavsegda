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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AddressTile2(),
            Row(
              children: [
                SizedBox(width: 16.0),
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: 'Найти в каталоге',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(2.0),
                          ),
                        ),
                        filled: true),
                  ),
                ),
                SizedBox(width: 8.0),
                OutlinedButton(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(36.0, 36.0)),
                      padding: MaterialStateProperty.all(EdgeInsets.all(0.0))),
                  onPressed: () {},
                  child: Image.asset('assets/Icon-Favorite-Outlined.png'),
                ),
                SizedBox(width: 8.0),
              ],
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton(onPressed: () {}, child: Text('Выпечка')),
                    TextButton(onPressed: () {}, child: Text('Кексы')),
                    TextButton(onPressed: () {}, child: Text('Конфеты')),
                    TextButton(onPressed: () {}, child: Text('Мороженое')),
                    TextButton(onPressed: () {}, child: Text('Выпечка')),
                    TextButton(onPressed: () {}, child: Text('Выпечка')),
                    TextButton(onPressed: () {}, child: Text('Выпечка')),
                  ],
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Выпечка',
                          style:
                              TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
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
                      Text('Выпечка',
                          style:
                              TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
