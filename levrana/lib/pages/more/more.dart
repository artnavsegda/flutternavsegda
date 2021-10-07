import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import 'support.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SupportPage()));
          },
          title: Text("Служба поддержки"),
          leading: Image(image: AssetImage('assets/ic-24/icon-24-support.png')),
        ),
        ListTile(
          title: Text("Справка"),
          leading: Image(image: AssetImage('assets/ic-24/icon-24-info.png')),
        ),
        ListTile(
          title: Text("Уведомления"),
          leading: Image(image: AssetImage('assets/ic-24/icon-24-support.png')),
        ),
        ListTile(
          onTap: () async {
            final InAppReview inAppReview = InAppReview.instance;

            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            }
          },
          title: Text("Оценить приложение"),
          leading:
              Image(image: AssetImage('assets/ic-24/icon-24-feedback.png')),
        ),
      ],
    );
  }
}
