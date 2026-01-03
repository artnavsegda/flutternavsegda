import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

Future<void> setupInteractedMessage() async {
  void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestSoundPermission: false,
        requestAlertPermission: false,
      );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background task: $task");
    if (task.isEmpty) return Future.value(true);

    DartPluginRegistrant.ensureInitialized();
    await setupInteractedMessage();

    var position = await Geolocator.getCurrentPosition();
    print('${position.latitude} ${position.longitude} coord');

    // Your background work here
    /*     final FlutterLocalNotificationsPlugin localNotifications =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotifications.initialize(
      const InitializationSettings(android: androidSettings),
    ); */

    FlutterLocalNotificationsPlugin().show(
      0,
      "$task ${position.latitude} ${position.longitude}",
      "$task ${position.latitude} ${position.longitude}",
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
        ),
      ),
    );
    print("notification shown");
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ElevatedButton(
              onPressed: () {
                Workmanager().registerOneOffTask("task-id", "simpleTask");
              },
              child: Text('One off'),
            ),
            ElevatedButton(
              onPressed: () {
                Workmanager().registerPeriodicTask(
                  "repeat-id",
                  "repeatingTask",
                  frequency: Duration(minutes: 15),
                );
              },
              child: Text('Regular'),
            ),
            ElevatedButton(
              onPressed: () async {
                LocationPermission permission;
                permission = await Geolocator.requestPermission();
                print(permission);
              },
              child: Text('Request location permission'),
            ),
            ElevatedButton(
              onPressed: () async {
                FlutterLocalNotificationsPlugin
                flutterLocalNotificationsPlugin =
                    FlutterLocalNotificationsPlugin();
                flutterLocalNotificationsPlugin
                    .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin
                    >()
                    ?.requestNotificationsPermission();
              },
              child: Text('Request notification permission'),
            ),
            ElevatedButton(
              onPressed: () {
                FlutterLocalNotificationsPlugin().show(
                  0,
                  "Test",
                  null,
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      'high_importance_channel', // id
                      'High Importance Notifications', // title
                    ),
                  ),
                );
              },
              child: Text('Show notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                var position = await Geolocator.getCurrentPosition();
                var snackBar = SnackBar(
                  content: Text(
                    '${position.latitude} ${position.longitude} Yay! A SnackBar!',
                  ),
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Show location'),
            ),
          ],
        ),
      ),
    );
  }
}
