import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/gql.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Уведомления')),
      body: Query(
        options: QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(getNotifications),
        ),
        builder: (result, {fetchMore, refetch}) {
          return ListView();
        },
      ),
    );
  }
}
