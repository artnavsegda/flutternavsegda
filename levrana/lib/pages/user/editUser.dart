import 'dart:io';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../main.dart';
import '../../gql.dart';
import '../../components/sms.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

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

  var maskFormatter = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  void _confirmSMS(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(16.0)),
      ),
      builder: (context) {
        return ConfirmSMSPage();
      },
    );
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

                GraphClientFullInfo userInfo =
                    GraphClientFullInfo.fromJson(result.data!['getClientInfo']);

                initializeDateFormatting();

                bool birthdayIsSet =
                    (dateOfBirth ?? userInfo.dateOfBirth) != null;

                DateTime? birthDateTime = birthdayIsSet
                    ? DateTime.parse(dateOfBirth ?? userInfo.dateOfBirth ?? "")
                    : null;

                String clientGUID = userInfo.clientGUID;
                return Column(
                  children: [
                    SizedBox(height: 100.0),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 86,
                          backgroundImage: _imageFile != null
                              ? FileImage(File(_imageFile?.path ?? ""))
                              : userInfo.picture != ""
                                  ? NetworkImage(userInfo.picture ?? "")
                                  : MemoryImage(kTransparentImage)
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
                                  initialValue: userInfo.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Введите имя';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(labelText: 'Имя')),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          eMail = value;
                                        });
                                      },
                                      initialValue: userInfo.eMail,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Введите E-Mail';
                                        }
                                        return null;
                                      },
                                      decoration:
                                          InputDecoration(labelText: 'E-mail')),
                                  if (userInfo.confirmedEMail == false)
                                    OutlinedButton(
                                        style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all(
                                                    Size(36.0, 36.0)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ))),
                                        onPressed: () {
                                          showCupertinoDialog<void>(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoAlertDialog(
                                              content: Text(
                                                  'Выслать повторно код подтверждения?'),
                                              actions: [
                                                CupertinoDialogAction(
                                                  isDefaultAction: true,
                                                  child: const Text('Нет'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                Mutation(
                                                    options: MutationOptions(
                                                      document: gql(
                                                          eMailConfirmRepeat),
                                                      onCompleted:
                                                          (resultData) {
                                                        print(resultData);
                                                      },
                                                    ),
                                                    builder:
                                                        (runMutation, result) {
                                                      return CupertinoDialogAction(
                                                        child: const Text('Да'),
                                                        onPressed: () {
                                                          runMutation({});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    })
                                              ],
                                            ),
                                          );

                                          return;

                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: Text(
                                                  'Выслать повторно код подтверждения?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => {},
                                                  child: const Text('Да'),
                                                ),
                                                TextButton(
                                                  onPressed: () => {},
                                                  child: const Text('Да'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Text("Подтвердить")),
                                ],
                              ),
                              TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      phone = value;
                                    });
                                  },
                                  initialValue: maskFormatter
                                      .maskText(userInfo.phone.toString()),
                                  inputFormatters: [maskFormatter],
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(labelText: 'Телефон')),
                              TextFormField(
                                  key: Key(dateOfBirth ?? "dateOfBirth"),
                                  readOnly: true,
                                  initialValue: birthdayIsSet
                                      ? DateFormat.yMMMMd('ru_RU')
                                          .format(birthDateTime!)
                                      : "",
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
                                                    initialDateTime:
                                                        birthDateTime,
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
                                  initialValue:
                                      genders[gender ?? userInfo.gender],
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
                                child: Consumer<AppModel>(
                                    builder: (context, model, child) {
                                  return Mutation(
                                    options: MutationOptions(
                                      document: gql(editClient),
                                      onError: (error) {
                                        print(error);
                                      },
                                      onCompleted: (resultData) {
                                        print(resultData);
                                        if (resultData['editClient']
                                                ['result'] ==
                                            0) {
                                          if (phone != null) {
                                            _confirmSMS(context);
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text('Ошибка'),
                                              content: Text(
                                                  resultData['editClient']
                                                      ['errorMessage']),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
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
                                                request.headers[
                                                        'Authorization'] =
                                                    'Bearer ' + model.token;
                                                request.files.add(
                                                    await MultipartFile
                                                        .fromPath(
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
                                                  : userInfo.phone);
                                              runMutation({
                                                'clientGUID': clientGUID,
                                                'name': name ?? userInfo.name,
                                                'eMail':
                                                    eMail ?? userInfo.eMail,
                                                'phone': phone != null
                                                    ? int.parse(maskFormatter
                                                        .unmaskText(phone!))
                                                    : userInfo.phone,
                                                'dateOfBirth': dateOfBirth ??
                                                    userInfo.dateOfBirth,
                                                'gender':
                                                    gender ?? userInfo.gender,
                                              });
                                              //Navigator.pop(context);
                                            }
                                          },
                                          child: Text("СОХРАНИТЬ",
                                              style:
                                                  TextStyle(fontSize: 16.0)));
                                    },
                                  );
                                }),
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
