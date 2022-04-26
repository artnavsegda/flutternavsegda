import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/login_state.dart';

import '../../components/gradient_button.dart';
import '../../gql.dart';
import '../../utils.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class EditUser extends StatefulWidget {
  const EditUser(this.userInfo, {Key? key}) : super(key: key);

  final GraphClientFullInfo userInfo;

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;
  late GraphClientInfo clientInfo;
  var maskFormatter = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  final GlobalKey _menuKey = GlobalKey();
  late TextEditingController userNameController;
  late TextEditingController phoneController;
  late TextEditingController eMailController;

  @override
  void initState() {
    super.initState();
    clientInfo = GraphClientInfo(
      clientGUID: widget.userInfo.clientGUID,
      phone: widget.userInfo.phone,
      name: widget.userInfo.name,
      dateOfBirth: widget.userInfo.dateOfBirth,
      gender: widget.userInfo.gender,
      eMail: widget.userInfo.eMail,
      greenMode: widget.userInfo.greenMode,
    );
    userNameController = TextEditingController(text: widget.userInfo.name);
    phoneController = TextEditingController(
        text: maskFormatter.maskText(clientInfo.phone.toString()));
    eMailController = TextEditingController(text: widget.userInfo.eMail);
  }

  void _showCameraModal(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
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
                'Изменение фотографии',
              )),
              trailing: Icon(
                SeverMetropol.Icon_Close,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                SeverMetropol.Icon_Photo_Camers,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Запустить камеру'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  _imageFile = pickedFile;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                SeverMetropol.Icon_List,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Выбрать из галереи'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _imageFile = pickedFile;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _sendFormButton(BuildContext context, GraphClientFullInfo userInfo) {
    return Mutation(
        options: MutationOptions(
          document: gql(editClient),
          onCompleted: (resultData) {
            if (resultData != null) {
              GraphClientResult nordClientResult =
                  GraphClientResult.fromJson(resultData['editClient']);
              if (nordClientResult.result == 0) {
                Navigator.pop(context);
              } else {
                showErrorAlert(context, nordClientResult.errorMessage ?? '');
              }
            }
          },
        ),
        builder: (runMutation, mutationResult) {
          return GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_imageFile != null) {
                    var request = MultipartRequest(
                      'POST',
                      Uri.parse(
                          'https://demo.cyberiasoft.com/severmetropolservice/api/client/setavatar'),
                    );
                    request.headers['Authorization'] =
                        'Bearer ' + context.read<LoginState>().token;
                    request.files.add(await MultipartFile.fromPath(
                      'image',
                      _imageFile!.path,
                      contentType: MediaType('image', 'jpg'),
                    ));
                    var streamedResponse = await request.send();
                    String res = await streamedResponse.stream.bytesToString();
                    print(res);
                  }
                  runMutation(clientInfo.toJson());
                }
              },
              child: const Text("Сохранить"));
        });
  }

  void _showDatePicker(BuildContext context) async {
    if (Platform.isAndroid) {
      var newDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2016, 8),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (newDate != null) {
        setState(() {
          clientInfo.dateOfBirth = newDate.toIso8601String();
        });
      }
    } else if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              height: 300,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 240,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime(2016, 8),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (value) {
                        setState(() {
                          clientInfo.dateOfBirth = value.toIso8601String();
                        });
                      },
                    ),
                  ),
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            );
          });
    }
  }

  void _showEmailConfirmModal(BuildContext context) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Выслать повторно код подтверждения?'),
          actions: [
            TextButton(
              onPressed: () => {},
              child: const Text('Нет'),
            ),
            Mutation(
                options: MutationOptions(
                  document: gql(eMailConfirmRepeat),
                  onCompleted: (resultData) {
                    Navigator.pop(context);
                  },
                ),
                builder: (runMutation, result) {
                  return TextButton(
                    onPressed: () {
                      runMutation({});
                    },
                    child: const Text('Да'),
                  );
                })
          ],
        ),
      );
    } else if (Platform.isIOS) {
      showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: const Text('Выслать повторно код подтверждения?'),
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
                  document: gql(eMailConfirmRepeat),
                  onCompleted: (resultData) {
                    Navigator.pop(context);
                  },
                ),
                builder: (runMutation, result) {
                  return CupertinoDialogAction(
                    child: const Text('Да'),
                    onPressed: () {
                      runMutation({});
                    },
                  );
                })
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => _showCameraModal(context),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              foregroundImage: _imageFile != null
                                  ? FileImage(File(_imageFile?.path ?? ""))
                                  : widget.userInfo.picture != ""
                                      ? NetworkImage(
                                          widget.userInfo.picture ?? "")
                                      : AssetImage('assets/treska.jpg')
                                          as ImageProvider,
                            ),
                            Image.asset(
                              'assets/Icon-Photo-Camers.png',
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Личная информация",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: userNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите имя';
                        }
                        return null;
                      },
                      onChanged: (newName) {
                        clientInfo.name = newName;
                      },
                      //controller: userNameController,
                      decoration: InputDecoration(
                        labelText: "Имя",
                        suffixIcon: IconButton(
                          onPressed: () {
                            userNameController.clear();
                          },
                          icon: Icon(
                            SeverMetropol.Icon_Clear,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskFormatter],
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "Номер телефона",
                        hintText: '+7 (___) ___-__-__',
                        suffixIcon: IconButton(
                          onPressed: () {
                            phoneController.clear();
                          },
                          icon: Icon(
                            SeverMetropol.Icon_Clear,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: eMailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите e-Mail';
                        }
                        return null;
                      },
                      onChanged: (newMail) {
                        clientInfo.eMail = newMail;
                      },
                      decoration: InputDecoration(
                          labelText: "Email",
                          suffixIcon: IconButton(
                            onPressed: () {
                              eMailController.clear();
                            },
                            icon: Icon(
                              SeverMetropol.Icon_Clear,
                              size: 24.0,
                            ),
                          )),
                    ),
                    if (widget.userInfo.confirmedEMail == false)
                      RichText(
                        text: TextSpan(
                            text: 'Неподтвержденный адрес Email.',
                            style: TextStyle(
                                fontFamily: 'Noto Sans',
                                color: Color(0xFF1D242C)),
                            children: [
                              TextSpan(
                                  text: ' Подтвердить',
                                  style: TextStyle(color: Color(0xFFCD0643)),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        () => _showEmailConfirmModal(context)),
                              TextSpan(
                                text: ' ',
                              )
                            ]),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onTap: () => _showDatePicker(context),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Дата рождения",
                        suffixIcon: Icon(
                          SeverMetropol.Icon_Calendar_Today,
                          size: 24.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onTap: (() {
                        dynamic state = _menuKey.currentState;
                        state.showButtonMenu();
                      }),
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Пол",
                          suffixIcon: PopupMenuButton<WhyFarther>(
                            key: _menuKey,
                            icon: Icon(
                              SeverMetropol.Icon_Expand_More,
                              size: 24.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onSelected: (WhyFarther result) {},
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<WhyFarther>>[
                              const PopupMenuItem<WhyFarther>(
                                value: WhyFarther.harder,
                                child: Text('Мужской'),
                              ),
                              const PopupMenuItem<WhyFarther>(
                                value: WhyFarther.smarter,
                                child: Text('Женский'),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Другие настройки",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Отказаться от бумажных чеков'),
              value: false,
              onChanged: (newVal) {},
            ),
            SwitchListTile(
              title: const Text('Получать push-уведомления'),
              value: false,
              onChanged: (newVal) {},
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _sendFormButton(context, widget.userInfo),
            )
          ],
        ),
      ),
    );
  }
}
