import 'package:flutter/material.dart';
import '../../components/product_card.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  bool headerUp = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            //title: Text('Взрывная весна! Откр...'),
            actions: [
              Image.asset('assets/Icon-Share.png'),
            ],
          ),
          body: ListView(
            children: [
              SizedBox(height: 50),
              Image.asset('assets/placeholder/action1/Illustration@3x.png'),
              Text(
                'Нашему организму просто необходимо определенное количество витаминов, чтобы чувствовать себя бодрыми, быть веселыми и не болеть. Сейчас самое подходящее время запастись ими перед долгой, холодно осенью.',
              ),
              Text(
                  'Успейте получить подарок, количество ограничено! Акция действует только в части наших кафе и кондитерских.'),
              Text('Важно'),
              Text(
                  'Важно Сумма чека должна быть не менее 500 рублей без учёта бонусов. Приз выпадает за каждый чек на сумму более 500 рублей в акционный период. Подробнее об акции и условиях проведения читайте на сайте.'),
              TextButton(onPressed: () {}, child: Text('Найти ближайшее кафе')),
              Text('Товары, участвующие в акции'),
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
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          top: headerUp ? 65 : 100,
          left: headerUp ? 72 : 16,
          right: headerUp ? 72 : 16,
          child: AnimatedDefaultTextStyle(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 400),
            style: TextStyle(
              fontFamily: 'Forum',
              color: Colors.black,
              fontSize: headerUp ? 20 : 34,
            ),
            child: Text(
              'Взрывная весна! Открой новые вкусы сладкой весны.',
              //softWrap: headerUp ? false : true,
              overflow: headerUp ? TextOverflow.ellipsis : null,
            ),
          ),
        ),
      ],
    );
  }
}
