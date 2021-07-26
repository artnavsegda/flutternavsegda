import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'dialog.dart';
import 'login.dart';

const String getClientInfo = r'''
query getClientInfo {
  getClientInfo {
    clientGUID,
    name,
    phone,
    dateOfBirth,
    gender,
    eMail,
    confirmedPhone,
    confirmedEMail
    isPassword,
    points,
    picture,
    codeInviteFriend
  }
}
''';

const String editClient = r'''
mutation editClient($clientGUID: String!, $name: String, $eMail: String) {
  editClient(clientInfo: { clientGUID: $clientGUID, name: $name, eMail: $eMail }) {
    result
  }
}
''';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getClientInfo)),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Center(
                child: ElevatedButton(
              child: Text("Войти в профиль"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ));
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Image(
                      image:
                          AssetImage('assets/ic-24/icon-24-edit-profile.png')),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditUserPage()),
                    );
                    refetch!();
                  },
                ),
              ],
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text("Профиль", style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Stack(
              children: [
                Image(
                  image: AssetImage('assets/UserPage.png'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              result.data!['getClientInfo']['picture']),
                        ),
                        Text(result.data!['getClientInfo']['name'] ?? "",
                            style: GoogleFonts.montserrat(fontSize: 28))
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.0525),
                            blurRadius: 3.13,
                            offset: Offset(0.0, 2.19),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.0775),
                            blurRadius: 10.5,
                            offset: Offset(0.0, 7.37),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.13),
                            blurRadius: 47,
                            offset: Offset(0.0, 33),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text("Доступно бонусов"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  result.data!['getClientInfo']['points']
                                      .toString(),
                                  style: GoogleFonts.montserrat(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700)),
                              Image(
                                  image: AssetImage(
                                      'assets/ic-24/icon-24-bonus.png'))
                            ],
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      Size(223.0, 36.0)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.green)))),
                              onPressed: () {},
                              child: Text("ПРИГЛАСИТЬ ДРУГА",
                                  style: GoogleFonts.montserrat(fontSize: 16))),
                          ElevatedButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      Size(223.0, 36.0)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return TransferBonusPage(
                                        maxAmount: result.data!['getClientInfo']
                                            ['points']);
                                  },
                                );
                              },
                              child: Text("ПОДАРИТЬ БОНУСЫ",
                                  style: GoogleFonts.montserrat(fontSize: 16))),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text("Подарки"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-gift.png')),
                    ),
                    ListTile(
                      title: Text("Активировать промокод"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-promo.png')),
                    ),
                    ListTile(
                      title: Text("История заказов"),
                      leading: Image(
                          image:
                              AssetImage('assets/ic-24/icon-24-history.png')),
                    ),
                    ListTile(
                      title: Text("Адреса доставки"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-adress.png')),
                    ),
                    ListTile(
                      title: Text("Смена пароля"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-pass.png')),
                    ),
                    GraphQLConsumer(builder: (GraphQLClient client) {
                      return ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.remove('token');
                          client.cache.store.reset(); // empty the hash map
                          //await client.cache.save();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Welcome()),
                          );
                        },
                        title: Text("Выйти"),
                        leading: Image(
                            image: AssetImage('assets/ic-24/icon-24-exit.png')),
                      );
                    }),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class TransferBonusPage extends StatefulWidget {
  const TransferBonusPage({Key? key, required this.maxAmount})
      : super(key: key);

  final int maxAmount;

  @override
  _TransferBonusPageState createState() => _TransferBonusPageState();
}

enum SearchMode { phone, qr }

class _TransferBonusPageState extends State<TransferBonusPage> {
  double _amount = 0;
  SearchMode? _currentMode = SearchMode.phone;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scanned = false;
  late Barcode result;
  late QRViewController controller;

  Future<void> _openContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        final Contact? contact =
            await ContactsService.openDeviceContactPicker();
      } catch (e) {
        print(e.toString());
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Подарить бонусы"),
          Text("Укажите количество бонусов"),
          Row(
            children: [
              Expanded(
                child: Slider(
                    label: "hello",
                    max: widget.maxAmount.toDouble(),
                    value: _amount,
                    onChanged: (newValue) {
                      setState(() {
                        _amount = newValue;
                      });
                    }),
              ),
              Text(_amount.toStringAsFixed(0))
            ],
          ),
          RadioListTile(
            value: SearchMode.phone,
            groupValue: _currentMode,
            title: Text("По номеру телефона"),
            onChanged: (SearchMode? value) {
              setState(() {
                _currentMode = value;
              });
            },
          ),
          RadioListTile(
            value: SearchMode.qr,
            groupValue: _currentMode,
            title: Text("По QR коду"),
            onChanged: (SearchMode? value) {
              setState(() {
                _currentMode = value;
              });
            },
          ),
          if (_currentMode == SearchMode.phone)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Введите телефон",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.ac_unit),
                  onPressed: () {
                    _openContacts();
                  },
                )
              ],
            )
          else
            SizedBox(
              width: 100,
              height: 100,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ElevatedButton(onPressed: () {}, child: Text("ВВЕДИТЕ ПОЛУЧАТЕЛЯ"))
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanned = true;
        result = scanData;
      });
    });
  }
}

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
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
                                decoration:
                                    InputDecoration(labelText: 'Телефон')),
                            TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Дата рождения')),
                            TextFormField(
                                decoration: InputDecoration(labelText: 'Пол')),
                            TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Размер одежды')),
                            TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Размер обуви')),
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
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16)));
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
