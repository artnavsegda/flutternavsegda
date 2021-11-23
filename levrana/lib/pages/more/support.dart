import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../gql.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);
  final _user = const types.User(id: 'user');
  final _consultant = const types.User(id: 'consultant');

  Future sendImage(XFile? _imageFile, String token) async {
    if (_imageFile != null) {
      var request = MultipartRequest(
        'POST',
        Uri.parse(
            'https://demo.cyberiasoft.com/LevranaService/api/support/addimage'),
      );
      request.headers['Authorization'] = 'Bearer ' + token;
      request.files.add(await MultipartFile.fromPath(
        'image',
        _imageFile.path,
        contentType: MediaType('image', 'jpg'),
      ));
      var streamedResponse = await request.send();
      await streamedResponse.stream.bytesToString();
      //print(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text("Поддержка", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Query(
          options: QueryOptions(
            document: gql(getSupport),
          ),
          builder: (QueryResult result, {refetch, FetchMore? fetchMore}) {
            //print(result);

            if (result.hasException) {
              return const Center(
                child: Text(
                    "Чат с поддержкой доступен для зарегестрированных пользователей"),
              );
            }

            if (result.isLoading && result.data == null) {
              return const Center(
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

            return Consumer<AppModel>(builder: (context, model, child) {
              return Mutation(
                  options: MutationOptions(
                    document: gql(addSupport),
                    onError: (error) {
                      //print(error);
                    },
                    onCompleted: (dynamic resultData) async {
                      //print(resultData);
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
                      l10n: const ChatL10nRu(inputPlaceholder: "В чем дело ?"),
                      onAttachmentPressed: () => showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                                actions: <CupertinoActionSheetAction>[
                                  CupertinoActionSheetAction(
                                    child: const Text('Камера'),
                                    onPressed: () async {
                                      final pickedFile =
                                          await _picker.pickImage(
                                              source: ImageSource.camera);
                                      await sendImage(pickedFile, model.token);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: const Text('Галерея'),
                                    onPressed: () async {
                                      final pickedFile =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      await sendImage(pickedFile, model.token);
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              )),
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
            });
          }),
    );
  }
}
