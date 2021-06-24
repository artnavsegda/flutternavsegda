import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Image(
                image: AssetImage('assets/ic-24/icon-24-edit-profile.png')),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditUserPage()),
              );
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Профиль", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Image(image: AssetImage('assets/Личный кабинет.png')),
          ListView(
            children: [
              ListTile(
                  title: Text("Михаил Сунцов",
                      style: GoogleFonts.montserrat(fontSize: 28)),
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        AssetImage('assets/ic-24/icon-24-gift.png'),
                  )),
              Container(
                child: Column(
                  children: [
                    Text("Доступно бонусов"),
                    Text("943"),
                    ElevatedButton(
                        onPressed: () {}, child: Text("Пригласить друга")),
                    ElevatedButton(
                        onPressed: () {}, child: Text("Подарить бонусы")),
                  ],
                ),
              ),
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

class EditUserPage extends StatelessWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Редактирование профиля",
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Image(
              image: AssetImage(
                  'assets/Личный кабинет • Редактирование профиля@2x.png')),
          ListView(
            children: [
              CircleAvatar(
                radius: 86,
                backgroundImage: AssetImage('assets/ic-24/icon-24-gift@3x.png'),
              ),
              Text(""),
              TextField(),
              Text(""),
              TextField(),
              Text(""),
              TextField(),
              Text(""),
              TextField(),
              Text(""),
              TextField(),
              Text(""),
              TextField(),
              ElevatedButton(onPressed: () {}, child: Text("Сохранить"))
            ],
          )
        ],
      ),
    );
  }
}
