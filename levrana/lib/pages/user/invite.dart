import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({Key? key, required this.codeInviteFriend})
      : super(key: key);

  final String codeInviteFriend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(15.0),
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
                      child: const Text("Скопировать")),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text("ПОДЕЛИТСЯ КОДОМ"),
              onPressed: () {
                Share.share(codeInviteFriend);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
