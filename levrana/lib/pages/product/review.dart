import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../gql.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final myController = TextEditingController();
  int rating = 5;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Написать отзыв",
                        style: TextStyle(fontSize: 32.0)),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text("Ваша оценка",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                    RatingBar(
                      itemSize: 27,
                      initialRating: rating / 2.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Image.asset('assets/star.png'),
                        half: Image.asset('assets/star_half.png'),
                        empty: Image.asset('assets/star_border.png'),
                      ),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = (newRating * 2).round();
                        });
                        //print(newRating);
                      },
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(), labelText: 'Отзыв'),
                      controller: myController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Mutation(
                        options: MutationOptions(
                          document: gql(addReviewProduct),
                          onError: (error) {
                            //print(error);
                          },
                          onCompleted: (dynamic resultData) async {
                            //print(resultData);
                            Navigator.pop(context);
                          },
                        ),
                        builder: (
                          RunMutation runMutation,
                          QueryResult? result,
                        ) {
                          return ElevatedButton(
                              onPressed: () {
                                runMutation({
                                  'productID': widget.id,
                                  'text': myController.text,
                                  'mark': rating
                                });
                              },
                              child: const Text("ОТПРАВИТЬ"));
                        }),
                    const SizedBox(width: 16),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("ОТМЕНА")),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
