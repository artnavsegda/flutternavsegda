import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Печенье «Единорог в ро... '),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 270,
              child: PageView(
                children: [
                  Image.asset('assets/placeholder/unicorn.png'),
                  Image.asset('assets/placeholder/espresso.png'),
                  Image.asset('assets/placeholder/cheesecake.png'),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text('315р'),
                        Text('420р'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Базовая цена.'),
                        Text('За 1 шт.'),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('4.7'),
                    Text('13 отзывов'),
                  ],
                ),
              ],
            ),
            Text('Вес, гр'),
            Row(
              children: [
                OutlinedButton(onPressed: () {}, child: Text('50')),
                ElevatedButton(onPressed: () {}, child: Text('100')),
                OutlinedButton(onPressed: () {}, child: Text('250')),
                OutlinedButton(onPressed: () {}, child: Text('1000')),
              ],
            ),
            Column(
              children: [
                TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Colors.red,
                  labelColor: Colors.black38,
                  tabs: [
                    Tab(text: "О продукте"),
                    Tab(text: "Состав"),
                    Tab(text: "Отзывы"),
                  ],
                ),
              ],
            )
          ],
        ),
        bottomSheet: Row(
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Добавить в корзину')),
            TextButton(onPressed: () {}, child: Text('256'))
          ],
        ));
  }
}
