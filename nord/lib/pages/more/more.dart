import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.asset("assets/Logos.png"),
        ListTile(
          onTap: () {},
          title: const Text("Служба поддержки"),
          leading: Image.asset('assets/Icon Question Answer.png'),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Справка"),
          leading: Image.asset('assets/Icon Contact Support.png'),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("Оценить приложение"),
          leading: Image.asset('assets/Icon Star Rate Outlined.png'),
        ),
        ListTile(
          onTap: () async {},
          title: const Text("О приложении"),
          leading: Image.asset('assets/Icon Info.png'),
        ),
      ],
    );
  }
}
