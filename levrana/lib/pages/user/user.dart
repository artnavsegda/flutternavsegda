import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../gql.dart';
import '../../main.dart';
import 'edit_user.dart';
import 'bonus.dart';
import 'promocode.dart';
import 'invite.dart';
import 'set_password.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getClientInfo)),
        builder: (result, {fetchMore, refetch}) {
          //print(result);
          if (result.hasException) {
            return Center(
                child: ElevatedButton(
              child: const Text("Войти в профиль"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StartRoute()),
                );
              },
            ));
          }

          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          GraphClientFullInfo userInfo =
              GraphClientFullInfo.fromJson(result.data!['getClientInfo']);

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Image(
                      image:
                          AssetImage('assets/ic-24/icon-24-edit-profile.png')),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditUserPage()),
                    );
                    refetch!();
                  },
                ),
              ],
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              title:
                  const Text("Профиль", style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Stack(
              children: [
                const Image(
                  image: AssetImage('assets/UserPage.png'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    await refetch!();
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: userInfo.picture != null
                                ? NetworkImage(userInfo.picture ?? "")
                                : MemoryImage(kTransparentImage)
                                    as ImageProvider,
                          ),
                          Text(userInfo.name ?? "Незнакомец",
                              style: const TextStyle(fontSize: 28.0))
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color.fromRGBO(85, 146, 80, 0.0525),
                              blurRadius: 3.13,
                              offset: Offset(0.0, 2.19),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(85, 146, 80, 0.0775),
                              blurRadius: 10.5,
                              offset: Offset(0.0, 7.37),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(85, 146, 80, 0.13),
                              blurRadius: 47,
                              offset: Offset(0.0, 33),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text("Доступно бонусов"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(userInfo.points.toString(),
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold)),
                                const Image(
                                    fit: BoxFit.contain,
                                    width: 48,
                                    height: 48,
                                    image: AssetImage(
                                        'assets/ic-24/icon-24-bonus.png'))
                              ],
                            ),
                            OutlinedButton(
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(223.0, 36.0)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.0)),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return InvitePage(
                                          codeInviteFriend:
                                              userInfo.codeInviteFriend ??
                                                  "no codes");
                                    },
                                  );
                                },
                                child: const Text("ПРИГЛАСИТЬ ДРУГА",
                                    style: TextStyle(fontSize: 16.0))),
                            ElevatedButton(
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(223.0, 36.0)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.0)),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return TransferBonusPage(
                                          maxAmount: userInfo.points);
                                    },
                                  );
                                },
                                child: const Text("ПОДАРИТЬ БОНУСЫ",
                                    style: TextStyle(fontSize: 16.0))),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text("Подарки"),
                        leading: Image(
                            image: AssetImage('assets/ic-24/icon-24-gift.png')),
                      ),
                      ListTile(
                        title: const Text("Активировать промокод"),
                        leading: const Image(
                            image:
                                AssetImage('assets/ic-24/icon-24-promo.png')),
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return const Promocode();
                            },
                          );
                        },
                      ),
                      const ListTile(
                        title: Text("История заказов"),
                        leading: Image(
                            image:
                                AssetImage('assets/ic-24/icon-24-history.png')),
                      ),
                      const ListTile(
                        title: Text("Адреса доставки"),
                        leading: Image(
                            image:
                                AssetImage('assets/ic-24/icon-24-adress.png')),
                      ),
                      ListTile(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return const SetPasswordPage();
                            },
                          );
                        },
                        title: const Text("Смена пароля"),
                        leading: const Image(
                            image: AssetImage('assets/ic-24/icon-24-pass.png')),
                      ),
                      Consumer<AppModel>(builder: (context, model, child) {
                        return Mutation(
                            options: MutationOptions(
                              document: gql(logoffClient),
                              onCompleted: (resultData) async {
                                await model.setToken(
                                    resultData['logoffClient']['token']);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const StartRoute()),
                                );
                              },
                            ),
                            builder: (runMutation, result) {
                              return ListTile(
                                onTap: () async {
                                  runMutation({});
                                },
                                title: const Text("Выйти"),
                                leading: const Image(
                                    image: AssetImage(
                                        'assets/ic-24/icon-24-exit.png')),
                              );
                            });
                      }),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
