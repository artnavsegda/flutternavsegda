import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../sever_metropol_icons.dart';
import '../support/support.dart';
import '../help/help.dart';
import 'about.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.asset("assets/Logos.png"),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SupportPage()));
          },
          title: const Text("Служба поддержки"),
          leading: Icon(SeverMetropol.Icon_Question_Answer,
              color: Theme.of(context).colorScheme.primary),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpPage()));
          },
          title: const Text("Справка"),
          leading: Icon(SeverMetropol.Icon_Contact_Support,
              color: Theme.of(context).colorScheme.primary),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Уведомления"),
          leading: Icon(SeverMetropol.Icon_Notification,
              color: Theme.of(context).colorScheme.primary),
        ),
        ListTile(
          onTap: () async {
            final InAppReview inAppReview = InAppReview.instance;

            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            }
          },
          title: const Text("Оценить приложение"),
          leading: Icon(SeverMetropol.Icon_Star_Rate_Outlined,
              color: Theme.of(context).colorScheme.primary),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutPage()));
          },
          title: const Text("О приложении"),
          leading: Icon(SeverMetropol.Icon_Info,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
