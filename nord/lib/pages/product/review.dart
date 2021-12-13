import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваш отзыв'),
      ),
      body: Column(
        children: [
          Text('Оценка товара'),
          TextField(),
          ElevatedButton(onPressed: () {}, child: Text('Оправить отзыв'))
        ],
      ),
    );
  }
}
