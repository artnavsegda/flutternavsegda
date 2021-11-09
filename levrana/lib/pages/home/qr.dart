import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:phone_number/phone_number.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../gql.dart';

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  void initState() {
    super.initState();
    ScreenBrightness.setScreenBrightness(1.0);
  }

  @override
  void dispose() {
    super.dispose();
    ScreenBrightness.resetScreenBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Бонусная карта", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Image(
            image: AssetImage('assets/QR.png'),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Query(
            options: QueryOptions(
              document: gql(getClientInfo),
              fetchPolicy: FetchPolicy.cacheFirst,
            ),
            builder: (result, {fetchMore, refetch}) {
              //print(result.data);

              if (result.hasException) {
                return Center(child: Text("Карта недоступна"));
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              String phone =
                  "+" + result.data!['getClientInfo']['phone'].toString();

              Future<PhoneNumber> futurePhone = PhoneNumberUtil().parse(phone);

              return Column(children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color.fromRGBO(85, 146, 80, 0.1696),
                              blurRadius: 0.0,
                              offset: Offset(0.0, 2),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(85, 146, 80, 0.250),
                              blurRadius: 15.11,
                              offset: Offset(0.0, 12.02),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(85, 146, 80, 0.250),
                              blurRadius: 80,
                              offset: Offset(0.0, 42),
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: QrImage(
                        data: result.data!['getClientInfo']['clientGUID'],
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          runSpacing: 8,
                          children: [
                            Text("Показать на кассе",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold)),
                            FutureBuilder<Object>(
                                future: futurePhone,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var phoneNumber =
                                        snapshot.data as PhoneNumber;

                                    return Text(phoneNumber.international,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green));
                                  } else
                                    return Center(
                                        child: CircularProgressIndicator());
                                }),
                            Text(
                                "Поднесите телефон к QR сканеру чтобы начислить или списать бонусы."),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            minimumSize: Size(double.infinity, 48),
                          ),
                          child: Text("ДОБАВИТЬ В WALLET"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            },
          ),
        ],
      ),
    );
  }
}
