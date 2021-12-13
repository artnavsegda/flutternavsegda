import 'package:flutter/material.dart';
import 'review.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int page = 0;

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
                      children: const [
                        Text('315р'),
                        Text('420р'),
                      ],
                    ),
                    Row(
                      children: const [
                        Text('Базовая цена.'),
                        Text('За 1 шт.'),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: const [
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
            DefaultTabController(
              length: 3,
              child: TabBar(
                onTap: (newPage) {
                  setState(() {
                    page = newPage;
                  });
                },
                unselectedLabelColor: Colors.red,
                labelColor: Colors.black38,
                tabs: const [
                  Tab(text: "О продукте"),
                  Tab(text: "Состав"),
                  Tab(text: "Отзывы"),
                ],
              ),
            ),
            [
              Column(
                children: [
                  Divider(),
                  Row(
                    children: [
                      Column(
                        children: const [
                          Text('36 часов'),
                          Text('Срок хранения'),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('3-25℃ – +25℃'),
                          Text('Условия хранения'),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('490.8 Ккал'),
                          Text('Калорийность'),
                        ],
                      )
                    ],
                  ),
                  Divider(),
                  Text(
                      'Пирожное состоит из воздушного безе, прослоенного натуральным шоколадом и нежным воздушным кремом из белого шоколада и натуральных сливок. Украшено свежими фруктами и ягодами по сезону: клубникой, ежевикой, малиной, физалисом, голубикой, красной смородиной, киви. Присыпано сахарной пудрой, украшено декором и шоколадной глазурью.'),
                ],
              ),
              Text(
                  'Мука в/с, сахар, кондитерский жир, яичный желток, сахарная пудра, яичный белок, какао порошок, пищевые красители, ванилин, пищевая сода, лимонная кислота.'),
              Column(
                children: [
                  Text('Отзывов о товаре пока нет'),
                  Text(
                      'Будьте первыми. Поделитесь, всё ли понравилось? Мы внимательно изучим Ваше мнение, чтобы знать, как сделать качество продукции лучше.'),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReviewPage()));
                      },
                      child: Text('Оставить отзыв'))
                ],
              )
            ][page],
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
