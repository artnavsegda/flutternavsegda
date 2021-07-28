import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    name: "Fayeed",
    uid: "123456789",
    avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  );

  final ChatUser otherUser = ChatUser(
    name: "Mrfatty",
    uid: "25649654",
  );

  List<ChatMessage> messages = <ChatMessage>[
    ChatMessage(
      text: "sfasf",
      user: ChatUser(
        name: "Fayeed",
        uid: "123456789",
      ),
      createdAt: DateTime.now(),
    ),
    ChatMessage(
      text: "fddsgdg",
      user: ChatUser(
        name: "Fayeed",
        uid: "123456789",
      ),
      createdAt: DateTime.now(),
    ),
    ChatMessage(
      text: "dgsdg",
      user: ChatUser(
        name: "Fayeed",
        uid: "123456789",
      ),
      createdAt: DateTime.now(),
    ),
  ];
  var m = <ChatMessage>[];

  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState!.scrollController
          ..animateTo(
            _chatViewKey
                .currentState!.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) {
    print(message.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Поддержка"),
        ),
        body: DashChat(
          key: _chatViewKey,
          inverted: false,
          onSend: onSend,
          sendOnEnter: true,
          textInputAction: TextInputAction.send,
          user: user,
          inputDecoration:
              InputDecoration.collapsed(hintText: "Add message here..."),
          dateFormat: DateFormat('yyyy-MMM-dd'),
          timeFormat: DateFormat('HH:mm'),
          messages: messages,
          showUserAvatar: false,
          showAvatarForEveryMessage: false,
          scrollToBottom: false,
          onPressAvatar: (ChatUser user) {
            print("OnPressAvatar: ${user.name}");
          },
          onLongPressAvatar: (ChatUser user) {
            print("OnLongPressAvatar: ${user.name}");
          },
          inputMaxLines: 5,
          messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
          alwaysShowSend: true,
          inputTextStyle: TextStyle(fontSize: 16.0),
          inputContainerStyle: BoxDecoration(
            border: Border.all(width: 0.0),
            color: Colors.white,
          ),
          onQuickReply: (Reply reply) {
            setState(() {
              messages.add(ChatMessage(
                  text: reply.value, createdAt: DateTime.now(), user: user));

              messages = [...messages];
            });

            Timer(Duration(milliseconds: 300), () {
              _chatViewKey.currentState!.scrollController
                ..animateTo(
                  _chatViewKey
                      .currentState!.scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );

              if (i == 0) {
                systemMessage();
                Timer(Duration(milliseconds: 600), () {
                  systemMessage();
                });
              } else {
                systemMessage();
              }
            });
          },
          onLoadEarlier: () {
            print("laoding...");
          },
          shouldShowLoadEarlier: false,
          showTraillingBeforeSend: true,
          trailing: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () async {},
            )
          ],
        ));
  }
}
