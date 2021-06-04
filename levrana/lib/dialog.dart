import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image(image: AssetImage('assets/Приветствие@2x.png')),
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
                  child: Text("Привет!",
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 150.0,
                  ),
                  child: Text(
                      "Да, теперь Леврана, это не просто магазин косметики. Мы разработали приложение, бонусную систему и много других приятностей для вас."),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ))),
              child: Text("ДАЛЬШЕ"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ),
    ]));
    //
  }
}

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      image: AssetImage('assets/Включить оповещения@2x.png'),
      title: "Будьте на связи",
      body:
          "Разрешите отправлять для вас уведомления, чтобы мы рассказывали о состоянии ваших заказов и проводящихся акциях и скидках",
      confirm: "РАЗРЕШИТЬ",
      cancel: "ПОЗЖЕ",
      onConfirm: () {},
      onCancel: () {},
    );
  }
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      image: AssetImage('assets/Включить оповещения@2x.png'),
      title: "Войти",
      body:
          "В личном кабинете можно будет составлять списки покупок, контролировать счет и тратить бонусы.",
      confirm: "ВОЙТИ",
      cancel: "ПОЗЖЕ",
      onConfirm: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: const Radius.circular(16.0)),
          ),
          builder: (context) {
            // Using Wrap makes the bottom sheet height the height of the content.
            // Otherwise, the height will be half the height of the screen.
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: [
                  Text("Вход",
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      )),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '+7(___) ___-__-__'),
                  ),
                  CheckboxListTile(
                    title: Text(
                        "Ознакомлен с условиями положения о защите персональных данных"),
                    value: false,
                    onChanged: (newValue) {},
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  CheckboxListTile(
                    title: Text(
                        "Даю свое согласие на обработку персональных данных"),
                    value: false,
                    onChanged: (newValue) {},
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("ВОЙТИ")),
                ],
              ),
            );
          },
        );
      },
      onCancel: () {},
    );
  }
}

class Dialog extends StatelessWidget {
  const Dialog(
      {Key? key,
      required this.image,
      required this.title,
      required this.body,
      required this.confirm,
      this.cancel = "ПОЗЖЕ",
      required this.onConfirm,
      this.onCancel})
      : super(key: key);

  final ImageProvider image;
  final String title;
  final String body;
  final String confirm;
  final String cancel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image(image: image),
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
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
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
            Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ))),
                  child: Text(confirm),
                  onPressed: onConfirm,
                ),
                TextButton(onPressed: () {}, child: Text(cancel)),
              ],
            )
          ],
        ),
      ),
    ]));
    //
  }
}
