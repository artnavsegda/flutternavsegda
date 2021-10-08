import 'dart:io';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phone_number/phone_number.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../gql.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final birthDateController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  static const genders = {
    'UNDETERMINED': '',
    'MALE': 'Мужской',
    'FEMALE': 'Женский',
  };

  String? name;
  String? eMail;
  String? phone;
  String? dateOfBirth;
  String? gender;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    birthDateController.dispose();
    super.dispose();
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

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

                initializeDateFormatting();
                print(result);

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
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            inputDecorationTheme: InputDecorationTheme()),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                  initialValue: result.data!['getClientInfo']
                                      ['name'],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Введите имя';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(labelText: 'Имя')),
                              TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      eMail = value;
                                    });
                                  },
                                  initialValue: result.data!['getClientInfo']
                                      ['eMail'],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Введите E-Mail';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(labelText: 'E-mail')),
                              TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      phone = value;
                                    });
                                  },
                                  initialValue: maskFormatter.maskText(result
                                      .data!['getClientInfo']['phone']
                                      .toString()),
                                  inputFormatters: [maskFormatter],
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(labelText: 'Телефон')),
                              TextFormField(
                                  key: Key(dateOfBirth ?? "dateOfBirth"),
                                  readOnly: true,
                                  initialValue: DateFormat.yMMMd('ru_RU')
                                      .format(DateTime.parse(dateOfBirth ??
                                          result.data!['getClientInfo']
                                              ['dateOfBirth'])),
                                  //controller: birthDateController,
                                  onTap: () {
                                    //print("AAAA");
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
                                                    initialDateTime: DateTime
                                                        .parse(dateOfBirth ??
                                                            result.data![
                                                                    'getClientInfo']
                                                                [
                                                                'dateOfBirth']),
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                    onDateTimeChanged: (value) {
                                                      setState(() {
                                                        dateOfBirth = value
                                                            .toIso8601String();
                                                      });
                                                    },
                                                  ),
                                                ),
                                                CupertinoButton(
                                                  child: Text('OK'),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Дата рождения')),
                              TextFormField(
                                  key: Key(gender ?? "gender"),
                                  readOnly: true,
                                  initialValue: genders[gender ??
                                      result.data!['getClientInfo']['gender']],
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoActionSheet(
                                              actions: <
                                                  CupertinoActionSheetAction>[
                                                CupertinoActionSheetAction(
                                                  child: const Text('Мужской'),
                                                  onPressed: () async {
                                                    setState(() {
                                                      gender = 'MALE';
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: const Text('Женский'),
                                                  onPressed: () async {
                                                    setState(() {
                                                      gender = 'FEMALE';
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            ));
                                  },
                                  decoration:
                                      InputDecoration(labelText: 'Пол')),
                              SizedBox(
                                height: 32,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Mutation(
                                  options: MutationOptions(
                                    document: gql(editClient),
                                    onError: (error) {
                                      print(error);
                                    },
                                    onCompleted: (resultData) {
                                      print(resultData);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  builder: (runMutation, mutationResult) {
                                    return ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (_imageFile != null) {
                                              var request = MultipartRequest(
                                                'POST',
                                                Uri.parse(
                                                    'https://demo.cyberiasoft.com/LevranaService/api/client/setavatar'),
                                              );
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              //print("Upload token: " +
                                              //    (prefs.getString('token') ??
                                              //        ""));
                                              request.headers['Authorization'] =
                                                  'Bearer ' +
                                                      (prefs.getString(
                                                              'token') ??
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
                                              //print(res);
                                            }
                                            print(phone != null
                                                ? int.parse(maskFormatter
                                                    .unmaskText(phone!))
                                                : result.data!['getClientInfo']
                                                    ['phone']);
                                            runMutation({
                                              'clientGUID': clientGUID,
                                              'name': name ??
                                                  result.data!['getClientInfo']
                                                      ['name'],
                                              'eMail': eMail ??
                                                  result.data!['getClientInfo']
                                                      ['eMail'],
                                              'phone': phone != null
                                                  ? int.parse(maskFormatter
                                                      .unmaskText(phone!))
                                                  : result.data![
                                                      'getClientInfo']['phone'],
                                              'dateOfBirth': dateOfBirth ??
                                                  result.data!['getClientInfo']
                                                      ['dateOfBirth'],
                                              'gender': gender ??
                                                  result.data!['getClientInfo']
                                                      ['gender'],
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
