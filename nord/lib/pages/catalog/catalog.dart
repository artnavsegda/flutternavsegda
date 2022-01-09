import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../components/components.dart';
import '../../components/product_card.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemScrollController itemScrollController = ItemScrollController();

    var elementList = [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Выпечка',
                style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 32.0,
              children: const [
                ProductCard(
                  productImage: 'assets/placeholder/product1/Illustration.png',
                  productName: 'Торт «Сезонный» с ягодами',
                  productPrice: '420 ₽',
                ),
                ProductCard(
                  productImage: 'assets/placeholder/product2/Illustration.png',
                  productName: 'Анна Павлова',
                  productPrice: '315 ₽',
                ),
                ProductCard(
                  productImage: 'assets/placeholder/product1/Illustration.png',
                  productName: 'Торт «Сезонный» с ягодами',
                  productPrice: '420 ₽',
                ),
                ProductCard(
                  productImage: 'assets/placeholder/product2/Illustration.png',
                  productName: 'Анна Павлова',
                  productPrice: '315 ₽',
                ),
              ],
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Кексы',
                style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 32.0,
              children: const [
                ProductCard(
                  productImage: 'assets/placeholder/product1/Illustration.png',
                  productName: 'Торт «Сезонный» с ягодами',
                  productPrice: '420 ₽',
                ),
                ProductCard(
                  productImage: 'assets/placeholder/product2/Illustration.png',
                  productName: 'Анна Павлова',
                  productPrice: '315 ₽',
                ),
                ProductCard(
                  productImage: 'assets/placeholder/product1/Illustration.png',
                  productName: 'Торт «Сезонный» с ягодами',
                  productPrice: '420 ₽',
                ),
                ProductCard(
                  productImage: 'assets/placeholder/product2/Illustration.png',
                  productName: 'Анна Павлова',
                  productPrice: '315 ₽',
                ),
              ],
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AddressTile2(),
            Row(
              children: [
                const SizedBox(width: 16.0),
                const Flexible(
                  child: TextField(
                    decoration: InputDecoration(
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
                const SizedBox(width: 8.0),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(36.0, 36.0),
                      padding: const EdgeInsets.all(0.0)),
                  onPressed: () {},
                  child: Image.asset('assets/Icon-Favorite-Outlined.png'),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
            DefaultTabController(
              length: 8,
              child: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                onTap: (newPage) {
                  itemScrollController.scrollTo(
                      index: newPage,
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOutCubic);
                },
                unselectedLabelColor: Colors.red.shade900,
                labelColor: Colors.black38,
                tabs: const [
                  Tab(text: "Выпечка"),
                  Tab(text: "Кексы"),
                  Tab(text: "Конфеты"),
                  Tab(text: "Мороженое"),
                  Tab(text: "Выпечка"),
                  Tab(text: "Кексы"),
                  Tab(text: "Конфеты"),
                  Tab(text: "Мороженое"),
                ],
              ),
            ),
/*             SingleChildScrollView(
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
                )), */
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: 2,
                itemScrollController: itemScrollController,
                itemBuilder: (context, index) {
                  return elementList[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
