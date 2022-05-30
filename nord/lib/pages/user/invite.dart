import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nord/sever_metropol_icons.dart';
//import 'package:share_plus/share_plus.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({Key? key, required this.codeInviteFriend})
      : super(key: key);

  final String codeInviteFriend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Center(
                child: Text(
              '50 бонусов Вам и каждому другу!',
              style: TextStyle(color: Color(0xFF56626C)),
            )),
            trailing: Icon(
              SeverMetropol.Icon_Close,
              color: Colors.red[900],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
                'Отправьте свой уникальный промокод друзьям, у которых ещё нет приложения «Север-Метрополь».\nПосле первой покупки друга на Ваш и его счёт поступит по 50 бонусов. Приглашайте друзей, получайте бонусы и делайте выгодные покупки!'),
          ),
          ListTile(
            onTap: () {
              Clipboard.setData(ClipboardData(text: codeInviteFriend));
            },
            title: Text(codeInviteFriend),
            trailing: Icon(
              SeverMetropol.Icon_Contact_Support,
              color: Colors.red[900],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Text("Поделиться кодом"),
              onPressed: () {
                //Share.share(codeInviteFriend);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
