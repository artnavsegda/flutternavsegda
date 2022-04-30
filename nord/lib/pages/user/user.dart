import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../login_state.dart';
import '../../sever_metropol_icons.dart';
import '../orders/orders.dart';
import 'package:nord/pages/address/delivery_address.dart';
import 'package:nord/gql.dart';
import 'package:nord/pages/error/error.dart';
import '../loyalty/loyalty.dart';

import 'edit_user.dart';
import 'gift_bonus.dart';
import 'set_password.dart';
import 'promocode.dart';
import 'invite.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getClientInfo)),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.hasException) {
            return ErrorPage(
                reload: () {
                  refetch!();
                },
                errorText: result.exception.toString());
            return SingleChildScrollView(
              child: Text(result.exception.toString()),
            );
          }

          GraphClientFullInfo userInfo =
              GraphClientFullInfo.fromJson(result.data!['getClientInfo']);

          return ListView(
            children: [
              ListTile(
                leading: CircleAvatar(
                  foregroundImage: userInfo.picture!.isNotEmpty
                      ? NetworkImage(userInfo.picture ?? '')
                      : AssetImage('assets/Round-Metropol.png')
                          as ImageProvider,
                ),
                onTap: () async {
                  //context.push('/editProfile');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditUser(userInfo)),
                  );
                  refetch!();
                },
                title: Text(userInfo.name ?? "Север Метрополь"),
                trailing: Icon(SeverMetropol.Icon_Edit,
                    color: Theme.of(context).colorScheme.primary),
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color(
                              0x1F000000), //Color.fromRGBO(0, 0, 0, 0.12),
                          blurRadius: 20.0,
                          offset: Offset(0.0, 6.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Color(0xffCD0643),
                            Color(0xffB0063A)
                          ])),
                  child: Material(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 12,
                          left: 16,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'У вас',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(userInfo.points.toString() + ' бонусов',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(color: Colors.white)),
                              Text(
                                userInfo.loyaltyTierPointOrder.toString() +
                                    '% начисление',
                                style: TextStyle(
                                    color: Color(0xB2FFFFFF), fontSize: 12),
                              ),
                              Row(
                                children: [
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
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
                                      child: const Text('Позвать друга')),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(4.0)),
                                          ),
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return GiftBonusModalSheet(
                                                maxBonus: userInfo.points);
                                          },
                                        );
                                      },
                                      child: const Text('Подарить бонусы'))
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoyaltyPage()));
                            },
                            icon: Icon(
                              SeverMetropol.Icon_Info,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Подарки"),
                leading: Icon(SeverMetropol.Icon_Present,
                    color: Theme.of(context).colorScheme.primary),
              ),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const Promocode();
                    },
                  );
                },
                title: const Text("Промокод"),
                leading: Icon(SeverMetropol.Icon_Redeem_Card,
                    color: Theme.of(context).colorScheme.primary),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrdersPage()));
                },
                title: const Text("История заказов"),
                leading: Icon(SeverMetropol.Icon_History,
                    color: Theme.of(context).colorScheme.primary),
              ),
              ListTile(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeliveryAddressPage()));
                },
                title: const Text("Адреса доставки"),
                leading: Icon(SeverMetropol.Icon_Place,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const Divider(
                color: Color(0xFFEFF3F4),
                thickness: 2,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                onTap: () async {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const SetPasswordPage();
                    },
                  );
                },
                title: const Text("Смена пароля"),
                leading: Icon(SeverMetropol.Icon_Lock,
                    color: Theme.of(context).colorScheme.primary),
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(logoffClient),
                  onCompleted: (result) {
                    context.read<LoginState>().loggedIn = false;
                    context.push('/login');
                  },
                ),
                builder: (runMutation, result) {
                  return ListTile(
                    onTap: () async {
                      context.read<CartState>().cart.clear();
                      runMutation({});
                    },
                    title: const Text("Выход из приложения"),
                    leading: Icon(SeverMetropol.Icon_Logout,
                        color: Theme.of(context).colorScheme.primary),
                  );
                },
              ),
            ],
          );
        });
  }
}
