import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final wsLink =
        WebSocketLink('wss://demo.cyberiasoft.com/LoyaltyService/graphql',
            config: SocketClientConfig(initialPayload: {
              'Authorization':
                  'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OTdkODJiOC04NTU1LTQ3NTctYjU4OS1hODM0ZDBhMWIxODgiLCJkZXZpY2VJZCI6IjQzODEzRjlBLTUwODktNEU0Ni1BRTBBLURCRTA1NjUxMTEwRSIsIm9TVHlwZSI6IjEiLCJjbGllbnRJZCI6IjQzNTM1MyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJEZXZpY2UiLCJDbGllbnQiXSwiZXhwIjozMzI2NDUxOTc3MywiaXNzIjoiTG95YWx0eSIsImF1ZCI6IkN5YmVyaWFTb2Z0In0.q_yLPpzNyJ2Ky2YFcMX_8stbW_7zEwlnBES6oV9n6iw',
            }, headers: {
              "Authorization":
                  "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OTdkODJiOC04NTU1LTQ3NTctYjU4OS1hODM0ZDBhMWIxODgiLCJkZXZpY2VJZCI6IjQzODEzRjlBLTUwODktNEU0Ni1BRTBBLURCRTA1NjUxMTEwRSIsIm9TVHlwZSI6IjEiLCJjbGllbnRJZCI6IjQzNTM1MyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJEZXZpY2UiLCJDbGllbnQiXSwiZXhwIjozMzI2NDUxOTc3MywiaXNzIjoiTG95YWx0eSIsImF1ZCI6IkN5YmVyaWFTb2Z0In0.q_yLPpzNyJ2Ky2YFcMX_8stbW_7zEwlnBES6oV9n6iw"
            }),
            subProtocol: GraphQLProtocol.graphqlWs);
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: wsLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _result = 0;

  void _doWork() {
    print('start work');
    final _wsLink =
        WebSocketLink('wss://demo.cyberiasoft.com/LoyaltyService/graphql',
            config: SocketClientConfig(initialPayload: {
              'Authorization':
                  'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OTdkODJiOC04NTU1LTQ3NTctYjU4OS1hODM0ZDBhMWIxODgiLCJkZXZpY2VJZCI6IjQzODEzRjlBLTUwODktNEU0Ni1BRTBBLURCRTA1NjUxMTEwRSIsIm9TVHlwZSI6IjEiLCJjbGllbnRJZCI6IjQzNTM1MyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJEZXZpY2UiLCJDbGllbnQiXSwiZXhwIjozMzI2NDUxOTc3MywiaXNzIjoiTG95YWx0eSIsImF1ZCI6IkN5YmVyaWFTb2Z0In0.q_yLPpzNyJ2Ky2YFcMX_8stbW_7zEwlnBES6oV9n6iw',
            }, headers: {
              "Authorization":
                  "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OTdkODJiOC04NTU1LTQ3NTctYjU4OS1hODM0ZDBhMWIxODgiLCJkZXZpY2VJZCI6IjQzODEzRjlBLTUwODktNEU0Ni1BRTBBLURCRTA1NjUxMTEwRSIsIm9TVHlwZSI6IjEiLCJjbGllbnRJZCI6IjQzNTM1MyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJEZXZpY2UiLCJDbGllbnQiXSwiZXhwIjozMzI2NDUxOTc3MywiaXNzIjoiTG95YWx0eSIsImF1ZCI6IkN5YmVyaWFTb2Z0In0.q_yLPpzNyJ2Ky2YFcMX_8stbW_7zEwlnBES6oV9n6iw"
            }),
            subProtocol: GraphQLProtocol.graphqlWs);
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _wsLink,
    );
    var subscription = client.subscribe(SubscriptionOptions(
      document: gql(supportMessageAdded),
      variables: {
        "authorization":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OTdkODJiOC04NTU1LTQ3NTctYjU4OS1hODM0ZDBhMWIxODgiLCJkZXZpY2VJZCI6IjQzODEzRjlBLTUwODktNEU0Ni1BRTBBLURCRTA1NjUxMTEwRSIsIm9TVHlwZSI6IjEiLCJjbGllbnRJZCI6IjQzNTM1MyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJEZXZpY2UiLCJDbGllbnQiXSwiZXhwIjozMzI2NDUxOTc3MywiaXNzIjoiTG95YWx0eSIsImF1ZCI6IkN5YmVyaWFTb2Z0In0.q_yLPpzNyJ2Ky2YFcMX_8stbW_7zEwlnBES6oV9n6iw"
      },
    ));
    subscription.listen(
      (result) {
        print('recieved some kind of data');
        print(result);
      },
      onError: (error) {
        print("error");
        print(error);
      },
      onDone: () {
        print("done");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Subscription(
                options: SubscriptionOptions(
                  document: gql(supportMessageAdded),
                  variables: {
                    "authorization":
                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OTdkODJiOC04NTU1LTQ3NTctYjU4OS1hODM0ZDBhMWIxODgiLCJkZXZpY2VJZCI6IjQzODEzRjlBLTUwODktNEU0Ni1BRTBBLURCRTA1NjUxMTEwRSIsIm9TVHlwZSI6IjEiLCJjbGllbnRJZCI6IjQzNTM1MyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6WyJEZXZpY2UiLCJDbGllbnQiXSwiZXhwIjozMzI2NDUxOTc3MywiaXNzIjoiTG95YWx0eSIsImF1ZCI6IkN5YmVyaWFTb2Z0In0.q_yLPpzNyJ2Ky2YFcMX_8stbW_7zEwlnBES6oV9n6iw"
                  },
                ),
                builder: (result) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                  // ResultAccumulator is a provided helper widget for collating subscription results.
                  // careful though! It is stateful and will discard your results if the state is disposed
                  return ResultAccumulator.appendUniqueEntries(
                    latest: result.data,
                    builder: (context, {results}) => Text('123'),
                  );
                }),
            const Text(
              'Result is:',
            ),
            Text(
              '$_result',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _doWork,
        tooltip: 'Increment',
        child: const Icon(Icons.run_circle),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
