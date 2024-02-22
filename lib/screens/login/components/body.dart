import 'package:asocombeima/components/dataController.dart';
import 'package:flutter/material.dart';
import 'package:asocombeima/contants.dart';
import 'package:postgres/postgres.dart';
import 'package:asocombeima/components/sessionKey.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late TextEditingController userController;
  late TextEditingController passController;
  late FocusNode userFocus;
  late FocusNode passFocus;
  final formKey = GlobalKey<FormState>();
  late PostgreSQLConnection connection;
  late Size size;

  // True: Conectarse mediante una base de datos de PostgreSQL
  // False: Conectarse mediante la hoja de calculo de google
  final bool db = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: size.height, minWidth: size.width),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: size.height * 0.1),
                SizedBox(
                    width: size.width,
                    height: size.height * 0.2,
                    child: Image.asset('assets/images/asocombeima_Logo.png')),
                SizedBox(height: size.height * 0.01),
                SizedBox(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: kTextColor,
                        fontSize: size.height * 0.05,
                        fontFamily: 'Libre Franklin',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.6,
                        child: TextFormField(
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(passFocus);
                          },
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(
                            fontFamily: 'Libre Franklin',
                          ),
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                fontFamily: 'Libre Franklin',
                              ),
                              labelText: 'Usuario',
                              hintText: 'usuario@asocombeima.com'),
                          controller: userController,
                          validator: (value) {
                            if (value == '') {
                              return "Campo necesario";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.6,
                        child: TextFormField(
                          onEditingComplete: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            login();
                          },
                          focusNode: passFocus,
                          style: const TextStyle(
                            fontFamily: 'Libre Franklin',
                          ),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              fontFamily: 'Libre Franklin',
                            ),
                            labelText: 'Contraseña',
                            hintText: '********',
                          ),
                          obscureText: true,
                          controller: passController,
                          validator: (value) {
                            if (value == '') {
                              return "Campo necesario";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.25,
                  height: size.height * 0.035,
                  child: AnimationButton(
                    enable: true,
                    onPressed: login,
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: kPrimaryColor),
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Libre Franklin',
                          fontSize: size.height * 0.025,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Image.asset('assets/images/bg.png')
              ]),
        ),
      ),
    );
  }

  void notificationLogin(result, color) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        margin: EdgeInsets.only(
            bottom: size.height * 0.1,
            right: size.width * 0.1,
            left: size.width * 0.1),
        behavior: SnackBarBehavior.floating,
        content: Text(result),
        backgroundColor: color,
      ));
  }

  void login() {
    if (db) {
      loginDB();
    } else {
      loginSheet();
    }
  }

  Future<void> loginDB() async {
    if (await checkSQL()) {
      if (formKey.currentState!.validate()) {
        List<List<dynamic>> results = await connection.query(
            "select * from accounts where username = '${userController.text}' and password = '${passController.text}'");
        if (results.isNotEmpty) {
          for (final row in results) {
            var key = generateKey();
            await connection.query(
                "update accounts set session_key = '$key' where user_id = '${row[0]}'");
            sessionManager.set(
                'user',
                User(
                    username: userController.text,
                    password: passController.text,
                    name_lastname: row[3],
                    session_key: key));
          }
        } else {
          notificationLogin('Usuario o Contraseña incorrecto', Colors.red);
        }
      }
    }
  }

  Future<void> loginSheet() async {
    if (formKey.currentState!.validate()) {
      print(await checkExcelOnline());
      if (await checkExcelOnline()) {
        print('login');
        User user = await getUser(userController.text, passController.text);
        if (user.username.isNotEmpty) {
          sessionManager.set(
              'user',
              User(
                  username: userController.text,
                  password: passController.text,
                  name_lastname: user.name_lastname,
                  session_key: generateKey()));
        } else {
          notificationLogin('Usuario o Contraseña incorrecto', Colors.red);
        }
      }
    }
  }

  Future<bool> checkSQL() async {
    while (await openConnection()) {
      //checkSQL();
    }
    return true;
  }

  Future<bool> openConnection() async {
    connection = PostgreSQLConnection(db_host, db_port, db_name,
        username: db_user, password: db_pass);
    await connection.open();
    return connection.isClosed;
  }

  @override
  void initState() {
    super.initState();
    userController = TextEditingController();
    passController = TextEditingController();
    passFocus = FocusNode();
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    passFocus.dispose();
    super.dispose();
  }
}
