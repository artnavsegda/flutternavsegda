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
    return Query(
        options: QueryOptions(document: gql(getClientInfo)),
        builder: (result, {fetchMore, refetch}) {
          return Column(
            children: [
              Text(result.data!['getClientInfo']['name'] ?? ""),
              Text(result.data!['getClientInfo']['phone'].toString()),
              Text(result.data!['getClientInfo']['dateOfBirth'] ?? ""),
              Text(result.data!['getClientInfo']['gender'] ?? ""),
              Text(result.data!['getClientInfo']['eMail'] ?? ""),
              Text(result.data!['getClientInfo']['confirmedPhone'].toString()),
              Text(result.data!['getClientInfo']['confirmedEMail'].toString()),
              Text(result.data!['getClientInfo']['isPassword'].toString()),
              Text(result.data!['getClientInfo']['points'].toString()),
              Text(result.data!['getClientInfo']['picture'] ?? ""),
              Text(result.data!['getClientInfo']['codeInviteFriend'] ?? ""),
            ],
          );
        });
  }
}
