import 'package:flutter/material.dart';
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
          leading: Image.asset('assets/Icon-Question-Answer.png'),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpPage()));
          },
          title: const Text("Справка"),
          leading: Image.asset('assets/Icon-Contact-Support.png'),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Оценить приложение"),
          leading: Image.asset('assets/Icon-Star-Rate-Outlined.png'),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutPage()));
          },
          title: const Text("О приложении"),
          leading: Image.asset('assets/Icon-Info.png'),
        ),
      ],
    );
  }
}
