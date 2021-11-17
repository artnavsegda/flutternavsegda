import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import 'support.dart';
import 'help.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SupportPage()));
          },
          title: const Text("Служба поддержки"),
          leading: const Image(
              image: AssetImage('assets/ic-24/icon-24-support.png')),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpPage()));
          },
          title: const Text("Справка"),
          leading:
              const Image(image: AssetImage('assets/ic-24/icon-24-info.png')),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Уведомления"),
          leading: const Image(
              image: AssetImage('assets/ic-24/icon-24-support.png')),
        ),
        ListTile(
          onTap: () async {
            final InAppReview inAppReview = InAppReview.instance;

            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            }
          },
          title: const Text("Оценить приложение"),
          leading: const Image(
              image: AssetImage('assets/ic-24/icon-24-feedback.png')),
        ),
      ],
    );
  }
}
