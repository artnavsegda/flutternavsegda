import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';

const String authenticate = r'''
mutation authenticate($gUID: String!, $bundleID: String!, $oSType: graphOSTypeEnum!) {
  authenticate(device: {gUID: $gUID, bundleID: $bundleID, oSType: $oSType}) 
  {
    token
  }
}
''';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mutation(
          options: MutationOptions(
            document: gql(authenticate),
            onCompleted: (dynamic resultData) {
              Provider.of<LoginState>(context, listen: false).token =
                  resultData['authenticate']['token'];
            },
          ),
          builder: (context, snapshot) {
            return Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Enter'),
              ),
            );
          }),
    );
  }
}
