import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/gradient_button.dart';
import 'package:nord/pages/error/error.dart';
import 'package:nord/gql.dart';
import 'package:nord/utils.dart';
import 'enter_address.dart';

class DeliveryAddressPage extends StatelessWidget {
  const DeliveryAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
        title: const Text('Адреса доставки'),
      ),
      body: Query(
          options: QueryOptions(
              fetchPolicy: FetchPolicy.networkOnly,
              document: gql(getClientInfo)),
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
            }

            GraphClientFullInfo userInfo =
                GraphClientFullInfo.fromJson(result.data!['getClientInfo']);

            return ListView(
              children: [
                if (userInfo.deliveryAddresses.isEmpty) ...[
                  Image.asset(
                    'assets/Illustration-New-Address.png',
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Избранные адреса',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        'Домашний, рабочий или ближайшего кафе ― сохраните основные адреса, чтобы каждый раз не заполнять их снова'),
                  ),
                ] else
                  ...userInfo.deliveryAddresses.map(
                    (deliveryAddress) => DeliveryAddressTile(
                      key: ValueKey(deliveryAddress.iD),
                      deliveryAddress: deliveryAddress,
                      reload: () => refetch!(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GradientButton(
                    child: Text('Добавить новый адрес'),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnterAddress()));
                      refetch!();
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class DeliveryAddressTile extends StatefulWidget {
  const DeliveryAddressTile({
    Key? key,
    required this.deliveryAddress,
    required this.reload,
  }) : super(key: key);

  final GraphDeliveryAddress deliveryAddress;
  final Function() reload;

  @override
  State<DeliveryAddressTile> createState() => _DeliveryAddressTileState();
}

class _DeliveryAddressTileState extends State<DeliveryAddressTile> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Mutation(
        options: MutationOptions(
            document: gql(delDeliveryAddress),
            onError: (error) {
              showErrorAlert(context, '$error');
            },
            onCompleted: (resultData) {
              widget.reload();
            }),
        builder: (runMutation, result) {
          return Slidable(
            key: UniqueKey(),
            child: ListTile(
              title: Text(widget.deliveryAddress.description ?? 'WTF'),
              subtitle: Text(widget.deliveryAddress.address),
              trailing: Icon(
                SeverMetropol.Icon_Edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              dismissible: DismissiblePane(onDismissed: () {
                setState(() {
                  _visible = false;
                });
                runMutation({'addressID': widget.deliveryAddress.iD});
              }),
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  autoClose: false,
                  onPressed: (context) async {
                    await Slidable.of(context)!
                        .dismiss(ResizeRequest(Duration(milliseconds: 300), () {
                      setState(() {
                        _visible = false;
                      });
                      runMutation({'addressID': widget.deliveryAddress.iD});
                    }));
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  icon: SeverMetropol.Icon_Delete,
                ),
              ],
            ),
          );
        });
  }
}
