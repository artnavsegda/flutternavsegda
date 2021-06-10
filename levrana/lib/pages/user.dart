import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getClientInfo = """
query getClientInfo {
  getClientInfo {
    name,
    phone,
    name,
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
    return Query(
        options: QueryOptions(
          document:
              gql(getClientInfo), // this is the query string you just created
        ),
        builder: (result, {fetchMore, refetch}) {
          return Column(
            children: [
              Text(result.data!['getClientInfo']['name']),
            ],
          );
        });
  }
}
