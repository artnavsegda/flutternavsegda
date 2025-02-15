import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OTdkODJiOC04NTU1LTQ3NTctYjU4OS1hODM0ZDBhMWIxODgiLCJkZXZpY2VJZCI6IjQzODEzRjlBLTUwODktNEU0Ni1BRTBBLURCRTA1NjUxMTEwRSIsIm9TVHlwZSI6IjEiLCJjbGllbnRJZCI6IjQzNTM1MyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJEZXZpY2UiLCJDbGllbnQiXSwiZXhwIjozMzI2NDUxOTc3MywiaXNzIjoiTG95YWx0eSIsImF1ZCI6IkN5YmVyaWFTb2Z0In0.q_yLPpzNyJ2Ky2YFcMX_8stbW_7zEwlnBES6oV9n6iw';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(title: 'Subscription demo'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _result = 'press button to start';

  void _doSubWork() {
    print('do work');
    setState(() {
      _result = 'waiting for data';
    });
    final _wsLink =
        WebSocketLink('wss://demo.cyberiasoft.com/LoyaltyService/graphql',
            config: SocketClientConfig(initialPayload: {
              'Authorization': 'Bearer $token',
            }, headers: {
              "Authorization": "Bearer $token"
            }),
            subProtocol: GraphQLProtocol.graphqlWs);
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _wsLink,
    );
    var subscription = client.subscribe(SubscriptionOptions(
      document: gql(supportMessageAdded),
      variables: {"authorization": "$token"},
    ));
    subscription.listen(
      (result) {
        print('recieved some kind of data');
        print(result);
        setState(() {
          _result = '${result.data}';
        });
      },
      onError: (error) {
        print("error");
        print(error);
        setState(() {
          _result = '${error}';
        });
      },
      onDone: () {
        print("done");
        setState(() {
          _result = 'work done';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Result is:',
            ),
            Text(
              '$_result',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
                onPressed: _doSubWork, child: Text('Open subscription'))
          ],
        ),
      ),
    );
  }
}

const String supportMessageAdded = r'''
subscription supportMessageAdded($authorization: String!) {
  supportMessageAdded(authorization: $authorization) {
    iD
    date
    text
    managerID
    manager
  }
}
''';
