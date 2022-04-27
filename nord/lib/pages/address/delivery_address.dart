import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/gradient_button.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/pages/error/error.dart';
import 'package:nord/gql.dart';
import 'address.dart';

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
                    (e) => ListTile(
                      title: Text('Домашний адрес'),
                      subtitle: Text('Дачный проспект, 36к3, квартира 410'),
                      trailing: Icon(
                        SeverMetropol.Icon_Edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GradientButton(
                    child: Text('Добавить новый адрес'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddressPage()));
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
