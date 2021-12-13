import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

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
            const DefaultTabController(
              length: 3,
              child: TabBar(
                unselectedLabelColor: Colors.red,
                labelColor: Colors.black38,
                tabs: [
                  Tab(text: "О продукте"),
                  Tab(text: "Состав"),
                  Tab(text: "Отзывы"),
                ],
              ),
            ),
            Divider(),
            Row(
              children: [
                Column(
                  children: [
                    Text('36 часов'),
                    Text('Срок хранения'),
                  ],
                ),
                Column(
                  children: [
                    Text('3-25℃ – +25℃'),
                    Text('Условия хранения'),
                  ],
                ),
                Column(
                  children: [
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
        bottomSheet: Row(
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Добавить в корзину')),
            TextButton(onPressed: () {}, child: Text('256'))
          ],
        ));
  }
}
