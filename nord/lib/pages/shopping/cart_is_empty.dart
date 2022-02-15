import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/gradient_button.dart';

class CartIsEmpty extends StatelessWidget {
  const CartIsEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Image.asset('assets/Illustration-Empty-Cart.png'),
          const SizedBox(height: 24),
          Text('В корзине ничего нет...',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 9),
          const Text(
              'Загляните в каталог — там всегда можно найти вкусные новинки или, если ищете что-то конкретное, воспользуйтесь поиском'),
          const SizedBox(height: 24),
          GradientButton(
              onPressed: () {
                context.go('/shop');
              },
              child: const Text('Перейти в каталог'))
        ],
      ),
    );
  }
}
