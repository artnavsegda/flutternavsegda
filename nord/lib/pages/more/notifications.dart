import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/pages/error/error.dart';
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

          List<GraphNotification> notifications = List<GraphNotification>.from(
              result.data!['getNotifications']
                  .map((model) => GraphNotification.fromJson(model)));
          return ListView(
            children: [
              ...notifications.map((notification) => ListTile(
                    title: Text(notification.caption ?? 'wtf'),
                    subtitle: Text(notification.text ?? 'wtf'),
                  ))
            ],
          );
        },
      ),
    );
  }
}
