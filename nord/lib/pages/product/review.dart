import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nord/sever_metropol_icons.dart';

import '../../components/gradient_button.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваш отзыв'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Colors.red[900],
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Оценка товара'),
                RatingBar(
                  itemSize: 27,
                  initialRating: 4.0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Icon(
                      SeverMetropol.Icon_Star_Rate,
                      color: Colors.red[900],
                    ),
                    half: Icon(
                      SeverMetropol.Icon_Star_Rate_Outlined,
                      color: Colors.red[900],
                    ),
                    empty: Icon(
                      SeverMetropol.Icon_Star_Rate_Outlined,
                      color: Colors.red[900],
                    ),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (newRating) {},
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            const TextField(
              decoration: const InputDecoration(
                  labelText: "Впечатление",
                  hintText: "Поделитесь впечатлением (необязательно)"),
            ),
            Spacer(),
            GradientButton(
                onPressed: () {}, child: const Text('Оправить отзыв'))
          ],
        ),
      ),
    );
  }
}
