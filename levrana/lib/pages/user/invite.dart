import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({Key? key, required this.codeInviteFriend})
      : super(key: key);

  final String codeInviteFriend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        child: Wrap(
          children: [
            Center(
              child: Column(
                children: [
                  Text(codeInviteFriend),
                  TextButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: codeInviteFriend));
                      },
                      child: Text("Скопировать")),
                ],
              ),
            ),
            ElevatedButton(
              child: Text("ПОДЕЛИТСЯ КОДОМ"),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
