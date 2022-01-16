import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
              //print('token:' + resultData['authenticate']['token']);
              Provider.of<LoginState>(context, listen: false).token =
                  resultData['authenticate']['token'];
            },
          ),
          builder: (runMutation, result) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  var data = await DeviceInfoPlugin().iosInfo;
                  runMutation({
                    'gUID': data.identifierForVendor,
                    'bundleID': "ru.levrana.mobile",
                    'oSType': "IOS",
                  });
                },
                child: Text('Enter'),
              ),
            );
          }),
    );
  }
}
