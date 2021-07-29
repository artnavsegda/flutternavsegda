import 'dart:io';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'user.dart';

const String editClient = r'''
mutation editClient($clientGUID: String!, $name: String, $eMail: String) {
  editClient(clientInfo: { clientGUID: $clientGUID, name: $name, eMail: $eMail }) {
    result
  }
}
''';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Редактирование профиля",
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image(
              image: AssetImage('assets/EditUser.png'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Query(
              options: QueryOptions(document: gql(getClientInfo)),
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading && result.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                nameController.text =
                    result.data!['getClientInfo']['name'] ?? "";

                emailController.text =
                    result.data!['getClientInfo']['eMail'] ?? "";

                var clientGUID = result.data!['getClientInfo']['clientGUID'];
                return Column(
                  children: [
                    SizedBox(height: 100.0),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 86,
                          backgroundImage: _imageFile == null
                              ? NetworkImage(
                                  result.data!['getClientInfo']['picture'])
                              : FileImage(File(_imageFile?.path ?? ""))
                                  as ImageProvider,
                          //backgroundImage:
                          //AssetImage('assets/ic-24/icon-24-gift.png'),
                        ),
                        ElevatedButton(
                          onPressed: () => showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                    actions: <CupertinoActionSheetAction>[
                                      CupertinoActionSheetAction(
                                        child: const Text('Камера'),
                                        onPressed: () async {
                                          final pickedFile =
                                              await _picker.pickImage(
                                                  source: ImageSource.camera);
                                          setState(() {
                                            _imageFile = pickedFile;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: const Text('Галерея'),
                                        onPressed: () async {
                                          final pickedFile =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);
                                          setState(() {
                                            _imageFile = pickedFile;
                                          });
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  )),
                          child: Icon(
                            Icons.photo_camera_outlined,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(48, 48),
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Введите имя';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: 'Имя')),
                            TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Введите E-Mail';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: 'E-mail')),
                            TextFormField(
                                controller: phoneNumberController,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: '+7 (###) ###-##-##',
                                      filter: {"#": RegExp(r'[0-9]')})
                                ],
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Телефон')),
                            TextFormField(
                                onTap: () {
                                  print("AAAA");
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 300,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 240,
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  onDateTimeChanged: (value) {},
                                                ),
                                              ),
                                              CupertinoButton(
                                                child: Text('OK'),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                decoration: InputDecoration(
                                    labelText: 'Дата рождения')),
                            TextFormField(
                                decoration: InputDecoration(labelText: 'Пол')),
                            SizedBox(
                              height: 32,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Mutation(
                                options: MutationOptions(
                                  document: gql(editClient),
                                  onCompleted: (resultData) {
                                    print(resultData);
                                    Navigator.pop(context);
                                  },
                                ),
                                builder: (runMutation, result) {
                                  return ElevatedButton(
                                      onPressed: () async {
                                        print("Magic !");

                                        if (_formKey.currentState!.validate()) {
                                          if (_imageFile != null) {
                                            var request = MultipartRequest(
                                              'POST',
                                              Uri.parse(
                                                  'https://demo.cyberiasoft.com/LevranaService/api/client/setavatar'),
                                            );
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            request.headers['Authorization'] =
                                                'Bearer ' +
                                                    (prefs.getString('token') ??
                                                        "");
                                            request.files.add(
                                                await MultipartFile.fromPath(
                                              'image',
                                              _imageFile!.path,
                                              contentType:
                                                  MediaType('image', 'jpg'),
                                            ));
                                            var streamedResponse =
                                                await request.send();
                                            var res = await streamedResponse
                                                .stream
                                                .bytesToString();
                                            print(res);
                                          }
                                          print(nameController.text);
                                          runMutation({
                                            'clientGUID': clientGUID,
                                            'name': nameController.text,
                                            'eMail': emailController.text,
                                          });
                                          //Navigator.pop(context);
                                        }
                                      },
                                      child: Text("СОХРАНИТЬ",
                                          style: TextStyle(fontSize: 16.0)));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
