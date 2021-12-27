import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
          RatingBar(
            itemSize: 27,
            initialRating: 4.0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            ratingWidget: RatingWidget(
              full: Image.asset('assets/Icon-Star-Rate.png'),
              half: Image.asset('assets/Icon-Star-Rate-Outlined.png'),
              empty: Image.asset('assets/Icon-Star-Rate-Outlined.png'),
            ),
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (newRating) {
              print(newRating);
            },
          ),
          TextField(),
          ElevatedButton(onPressed: () {}, child: Text('Оправить отзыв'))
        ],
      ),
    );
  }
}
