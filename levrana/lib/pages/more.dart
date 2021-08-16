import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

const String getSupport = r'''
query getSupport {
  getSupport {
    iD
    date
    text
    managerID
  }
}
''';

const String addSupport = r'''
mutation addSupport($message: String)
{
  addSupport(message: $message)
  {
    result
    errorMessage
    iD
  }
}
''';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);
  final _user = const types.User(id: 'user');
  final _consultant = const types.User(id: 'consultant');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Поддержка", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Query(
          options: QueryOptions(
            document: gql(getSupport),
          ),
          builder: (QueryResult result, {refetch, FetchMore? fetchMore}) {
            print(result);

            if (result.hasException) {
              return Center(
                child: Text(
                    "Чат с поддержкой доступен для зарегестрированных пользователей"),
              );
              return Text(result.exception.toString());
            }

            if (result.isLoading && result.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<types.Message> _messages2 = result.data!['getSupport']
                .map((message) => types.TextMessage(
                      author:
                          message['managerID'] == null ? _user : _consultant,
                      createdAt: message['date'],
                      id: message['iD'].toString(),
                      text: message['text'],
                    ))
                .toList()
                .cast<types.Message>();

            return Mutation(
                options: MutationOptions(
                  document: gql(addSupport),
                  onError: (error) {
                    print(error);
                  },
                  onCompleted: (dynamic resultData) async {
                    print(resultData);
                    refetch!();
                  },
                ),
                builder: (
                  RunMutation runMutation,
                  QueryResult? mutationResult,
                ) {
                  return Chat(
                    theme: const DefaultChatTheme(
                      //sdsainputBackgroundColor: Colors.green,
                      primaryColor: Colors.green,
                    ),
                    messages: _messages2,
                    l10n: ChatL10nRu(inputPlaceholder: "В чем дело ?"),
                    //onAttachmentPressed: _handleAtachmentPressed,
                    //onMessageTap: _handleMessageTap,
                    //onPreviewDataFetched: _handlePreviewDataFetched,
                    onSendPressed: (types.PartialText message) {
/*                       final textMessage = types.TextMessage(
                        author: _user,
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                        id: const Uuid().v4(),
                        text: message.text,
                      ); */

                      //_addMessage(textMessage);
                      runMutation({
                        'message': message.text,
                      });
                    },
                    user: _user,
                  );
                });
          }),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SupportPage()));
          },
          title: Text("Служба поддержки"),
          leading: Image(image: AssetImage('assets/ic-24/icon-24-support.png')),
        ),
        ListTile(
          title: Text("Справка"),
          leading: Image(image: AssetImage('assets/ic-24/icon-24-info.png')),
        ),
        ListTile(
          title: Text("Уведомления"),
          leading: Image(image: AssetImage('assets/ic-24/icon-24-support.png')),
        ),
        ListTile(
          title: Text("Оценить приложение"),
          leading:
              Image(image: AssetImage('assets/ic-24/icon-24-feedback.png')),
        ),
      ],
    );
  }
}
