import 'package:flutter/material.dart';

class CartIsEmpty extends StatelessWidget {
  const CartIsEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/Illustration Empty Cart.png'),
        const Text('В корзине ничего нет...'),
        const Text(
            'Загляните в каталог — там всегда можно найти вкусные новинки или, если ищете что-то конкретное, воспользуйтесь поиском'),
        ElevatedButton(
            onPressed: () {
              DefaultTabController.of(context)!.animateTo(1);
            },
            child: const Text('Перейти в каталог'))
      ],
    );
  }
}
