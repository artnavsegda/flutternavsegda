import 'package:flutter/material.dart';
import '../../components/product_card.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  bool headerUp = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.offset > 0 && headerUp == false) {
          setState(() {
            headerUp = true;
          });
        } else if (_scrollController.offset < 1) {
          {
            setState(() {
              headerUp = false;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
            controller: _scrollController,
            children: [
              SizedBox(height: 50),
              Image.asset('assets/placeholder/action1/Illustration@3x.png'),
              Text(
                'Нашему организму просто необходимо определенное количество витаминов, чтобы чувствовать себя бодрыми, быть веселыми и не болеть. Сейчас самое подходящее время запастись ими перед долгой, холодно осенью.',
              ),
              SpecialCondition(
                text:
                    'Успейте получить подарок, количество ограничено! Акция действует только в части наших кафе и кондитерских.',
              ),
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

class SpecialCondition extends StatelessWidget {
  const SpecialCondition({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            stops: [0.01, 0.01],
            colors: [Colors.red.shade900, Color(0xFFEFF3F4)]),
        borderRadius: BorderRadius.circular(2.0),
/*                                     color: Colors.black12,
        border: Border(
          left: BorderSide(
              width: 5.0, color: Colors.red),
        ), */
      ),
      child: Text(text, style: const TextStyle()),
    );
  }
}
