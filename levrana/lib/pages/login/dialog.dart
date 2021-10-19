import 'package:flutter/material.dart';
import '../../main.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogPage(
        image: AssetImage('assets/Включить оповещения.png'),
        title: "Будьте на связи",
        body:
            "Разрешите отправлять для вас уведомления, чтобы мы рассказывали о состоянии ваших заказов и проводящихся акциях и скидках",
        child: Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ))),
              child: Text("РАЗРЕШИТЬ"),
              onPressed: () {},
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Text("ПОЗЖЕ")),
          ],
        ));
  }
}

class DialogPage extends StatelessWidget {
  const DialogPage(
      {Key? key,
      required this.image,
      required this.title,
      required this.body,
      required this.child})
      : super(key: key);

  final ImageProvider image;
  final String title;
  final String body;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image(
        image: image,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(title,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 150.0,
                  ),
                  child: Text(body),
                ),
              ],
            ),
            child
          ],
        ),
      ),
    ]));
    //
  }
}
