import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getClientInfo = """
query getClientInfo {
  getClientInfo {
    name,
    phone,
    dateOfBirth,
    gender,
    eMail,
    confirmedPhone,
    confirmedEMail
    isPassword,
    points,
    picture,
    codeInviteFriend
  }
}
""";

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(image: AssetImage('assets/Личный кабинет@2x.png')),
          ListView(
            children: [
              ListTile(
                title: Text("Подарки"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-gift.png')),
              ),
              ListTile(
                title: Text("Активировать промокод"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-promo.png')),
              ),
              ListTile(
                title: Text("История заказов"),
                leading: Image(
                    image: AssetImage('assets/ic-24/icon-24-history.png')),
              ),
              ListTile(
                title: Text("Адреса доставки"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-adress.png')),
              ),
              ListTile(
                title: Text("Смена пароля"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-pass.png')),
              ),
              ListTile(
                title: Text("Выйти"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-exit.png')),
              ),
            ],
          ),
          /* Query(
              options: QueryOptions(document: gql(getClientInfo)),
              builder: (result, {fetchMore, refetch}) {
                return Column(
                  children: [
                    Text(result.data!['getClientInfo']['name'] ?? ""),
                    Text(result.data!['getClientInfo']['phone'].toString()),
                    Text(result.data!['getClientInfo']['dateOfBirth'] ?? ""),
                    Text(result.data!['getClientInfo']['gender'] ?? ""),
                    Text(result.data!['getClientInfo']['eMail'] ?? ""),
                    Text(result.data!['getClientInfo']['confirmedPhone']
                        .toString()),
                    Text(result.data!['getClientInfo']['confirmedEMail']
                        .toString()),
                    Text(
                        result.data!['getClientInfo']['isPassword'].toString()),
                    Text(result.data!['getClientInfo']['points'].toString()),
                    Text(result.data!['getClientInfo']['picture'] ?? ""),
                    Text(result.data!['getClientInfo']['codeInviteFriend'] ??
                        ""),
                  ],
                );
              }), */
        ],
      ),
    );
  }
}
