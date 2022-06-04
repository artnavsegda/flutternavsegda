import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:nord/login_state.dart';
import 'package:nord/gql.dart';
import 'package:nord/utils.dart';
import 'package:nord/components/gradient_button.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);
  final _user = const types.User(id: 'user');
  final _consultant = const types.User(id: 'consultant');

  Future sendImage(XFile? _imageFile, String token) async {
    if (_imageFile != null) {
      var request = MultipartRequest(
        'POST',
        Uri.parse(
            'https://demo.cyberiasoft.com/severmetropolservice/api/support/addimage'),
      );
      request.headers['Authorization'] = 'Bearer ' + token;
      request.files.add(await MultipartFile.fromPath(
        'image',
        _imageFile.path,
        contentType: MediaType('image', 'jpg'),
      ));
      var streamedResponse = await request.send();
      await streamedResponse.stream.bytesToString();
    }
  }

  _buildLoginToEnter(BuildContext context) {
    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset('assets/Illustration-No-Chat.png'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text('Добро пожаловать в чат службы поддержки',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
              'Здесь вы можете задать вопросы о товарах, работе магазинов, оформлении заказов, доставке и прочем. Для работы нужно войти в аккаунт или зарегистрироваться.'),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GradientButton(
              onPressed: () {
                context.push('/login');
              },
              child: const Text('Войти или зарегистрироваться')),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
        title: const Text('Чат'),
      ),
      body: context.watch<LoginState>().loggedIn
          ? Query(
              options: QueryOptions(
                document: gql(getSupport),
              ),
              builder: (QueryResult result, {refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return _buildLoginToEnter(context);
                }

                if (result.isLoading && result.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<GraphSupport> messages = List<GraphSupport>.from(result
                    .data!['getSupport']
                    .map((model) => GraphSupport.fromJson(model)));

                List<types.Message> _messages2 = messages
                    .map(
                      (message) {
                        if (message.isPhoto) {
                          return types.ImageMessage(
                            size: 10000000,
                            name: "image",
                            uri:
                                "https://demo.cyberiasoft.com/severmetropolservice/api/tools/picture/${message.iD}?type=support",
                            author:
                                message.managerID == null ? _user : _consultant,
                            createdAt: message.date.millisecondsSinceEpoch,
                            id: message.iD.toString(),
                          );
                        } else {
                          return types.TextMessage(
                            author:
                                message.managerID == null ? _user : _consultant,
                            createdAt: message.date.millisecondsSinceEpoch,
                            id: message.iD.toString(),
                            text: message.text ?? "photo",
                          );
                        }
                      },
                    )
                    .toList()
                    .cast<types.Message>();

                return Mutation(
                    options: MutationOptions(
                      document: gql(addSupport),
                      onError: (error) {
                        showErrorAlert(context, '$error');
                      },
                      onCompleted: (dynamic resultData) async {
                        refetch!();
                      },
                    ),
                    builder: (
                      RunMutation runMutation,
                      QueryResult? mutationResult,
                    ) {
                      return Chat(
                        theme: DefaultChatTheme(
                          inputBorderRadius: BorderRadius.zero,
                          inputBackgroundColor: Colors.white,
                          inputTextColor: Colors.black,
                          messageBorderRadius: 0,
                          primaryColor: Colors.black12,
                          sentMessageBodyTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                          //primaryColor: Theme.of(context).colorScheme.primary,
                          sendButtonIcon: Icon(
                            SeverMetropol.Icon_North,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          attachmentButtonIcon: Icon(
                            SeverMetropol.Icon_Attach_File,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          inputTextDecoration: InputDecoration(
                            labelText: "Сообщение",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ),
                        messages: _messages2,
                        l10n:
                            const ChatL10nRu(inputPlaceholder: "В чем дело ?"),
                        onAttachmentPressed: () {
                          ImagePicker _picker = ImagePicker();
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Center(
                                        child: Text(
                                      'Прикрепить фото',
                                    )),
                                    trailing: Icon(
                                      SeverMetropol.Icon_Close,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap: () => Navigator.pop(context),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      SeverMetropol.Icon_Photo_Camers,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    title: const Text('Запустить камеру'),
                                    onTap: () async {
                                      final pickedFile =
                                          await _picker.pickImage(
                                              source: ImageSource.camera);
                                      await sendImage(pickedFile,
                                          context.read<LoginState>().token);
                                      Navigator.pop(context);
                                      refetch!();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      SeverMetropol.Icon_List,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    title: const Text('Выбрать из галереи'),
                                    onTap: () async {
                                      final pickedFile =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      await sendImage(pickedFile,
                                          context.read<LoginState>().token);
                                      Navigator.pop(context);
                                      refetch!();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
              })
          : _buildLoginToEnter(context),
    );
  }
}
