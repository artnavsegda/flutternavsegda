import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'review.dart';
import '../../components/gradient_button.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int page = 0;
  bool headerUp = false;
  final _controller = PageController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.offset > 50 && headerUp == false) {
          setState(() {
            headerUp = true;
          });
        } else if (_scrollController.offset < 51) {
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
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              //title: const Text('Печенье «Единорог в ро... '),
              actions: [
                Image.asset('assets/Icon-Share.png'),
              ],
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset('assets/Icon-West.png')),
            ),
            body: ListView(
              controller: _scrollController,
              children: [
                const SizedBox(height: 50),
                SizedBox(
                  height: 270,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView(
                        controller: _controller,
                        children: [
                          Image.asset(
                            'assets/placeholder/unicorn.png',
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            'assets/placeholder/espresso.png',
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            'assets/placeholder/cheesecake.png',
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SmoothPageIndicator(
                            controller: _controller,
                            count: 3,
                            effect: const ExpandingDotsEffect(
                              spacing: 4.0,
                              //radius: 4.0,
                              dotWidth: 5.0,
                              dotHeight: 5.0,
                              expansionFactor: 6,
                              dotColor: Color.fromRGBO(255, 255, 255, 0.5),
                              activeDotColor: Colors.white,
                            ),
                            onDotClicked: (index) {}),
                      ),
                      Positioned(
                          child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            BadgeIcon(
                              title: 'ЗОЖ',
                              color: Color(0xFFA4D65E),
                            ),
                            BadgeIcon(
                              title: 'От шефа',
                              color: Color(0xFFD2AB67),
                            ),
                            BadgeIcon(
                              title: 'С собой',
                              color: Color(0xFFB0063A),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: const [
                              Text(
                                '250 P ',
                                style: TextStyle(
                                    fontFamily: 'Forum', fontSize: 34),
                              ),
                              Text(
                                '420 P',
                                style: TextStyle(
                                    fontFamily: 'Forum',
                                    fontSize: 20,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Tooltip(
                                  preferBelow: false,
                                  triggerMode: TooltipTriggerMode.tap,
                                  message:
                                      'Стоимость в приложении может отличаться от стоимости в кафе. Для уточнения стоимости товара, выберите способ и место его получения.',
                                  child: Text(
                                    'Базовая цена. ',
                                    style:
                                        TextStyle(color: Colors.red.shade900),
                                  )),
                              const Text('За 1 шт.'),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/Icon-Star-Rate.png',
                                color: Color(0xFFD2AB67),
                              ),
                              Text('4.7'),
                            ],
                          ),
                          Text('13 отзывов'),
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
                      const Text('Вес, гр'),
                      Row(
                        children: [
                          OutlinedButton(
                              onPressed: () {}, child: const Text('50')),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('100')),
                          OutlinedButton(
                              onPressed: () {}, child: const Text('250')),
                          OutlinedButton(
                              onPressed: () {}, child: const Text('1000')),
                        ],
                      ),
                    ],
                  ),
                ),
                DefaultTabController(
                  length: 3,
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    /*                   indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.redAccent), */
                    onTap: (newPage) {
                      setState(() {
                        page = newPage;
                      });
                    },
                    unselectedLabelColor: Colors.red.shade900,
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
                      const Divider(),
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
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  'Пищевая ценность на 100 г'),
                                              trailing: Image.asset(
                                                  'assets/Icon-Close.png'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('490.8 Ккал')),
                              const Text('Калорийность'),
                            ],
                          )
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                            'Пирожное состоит из воздушного безе, прослоенного натуральным шоколадом и нежным воздушным кремом из белого шоколада и натуральных сливок. Украшено свежими фруктами и ягодами по сезону: клубникой, ежевикой, малиной, физалисом, голубикой, красной смородиной, киви. Присыпано сахарной пудрой, украшено декором и шоколадной глазурью.'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                        'Мука в/с, сахар, кондитерский жир, яичный желток, сахарная пудра, яичный белок, какао порошок, пищевые красители, ванилин, пищевая сода, лимонная кислота.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Отзывов о товаре пока нет'),
                        const Text(
                            'Будьте первыми. Поделитесь, всё ли понравилось? Мы внимательно изучим Ваше мнение, чтобы знать, как сделать качество продукции лучше.'),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ReviewPage()));
                            },
                            child: const Text('Оставить отзыв'))
                      ],
                    ),
                  )
                ][page],
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GradientButton.icon(
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: "Товар добавлен в корзину",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1);
                        },
                        icon: const Text('Добавить в корзину'),
                        label: const Text('315 ₽')),
                  ),
                  TextButton.icon(
                      onPressed: () {},
                      icon: Image.asset('assets/Icon-Favorite.png'),
                      label: const Text('256')),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            top: headerUp ? 18 : 60,
            left: headerUp ? 72 : 16,
            right: headerUp ? 72 : 16,
            child: AnimatedDefaultTextStyle(
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 400),
              style: TextStyle(
                fontFamily: 'Forum',
                color: Colors.black,
                fontSize: headerUp ? 20 : 34,
              ),
              child: Text(
                'Печенье «Единорог в рожке»',
                //softWrap: headerUp ? false : true,
                overflow: headerUp ? TextOverflow.ellipsis : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
          alignment: Alignment.bottomLeft,
          color: color,
          child: Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.white, height: 1.1),
          ),
        ),
      ),
    );
  }
}
