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
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title:
            const Text("Бонусная карта", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          const Image(
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
                return const Center(child: Text("Карта недоступна"));
              }

              if (result.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              GraphClientFullInfo userInfo =
                  GraphClientFullInfo.fromJson(result.data!['getClientInfo']);

              String phone = "+" + userInfo.phone.toString();

              Future<PhoneNumber> futurePhone = PhoneNumberUtil().parse(phone);

              return Column(children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
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
                        data: userInfo.clientGUID,
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
                            const Text("Показать на кассе",
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
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green));
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                            const Text(
                                "Поднесите телефон к QR сканеру чтобы начислить или списать бонусы."),
                          ],
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text("ДОБАВИТЬ В WALLET"),
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
