// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:asocombeima/contants.dart';
import 'package:flutter/material.dart';
import 'package:asocombeima/screens/login/login_screen.dart';
import 'package:asocombeima/screens/monitor/monitor_screen.dart';
import 'package:asocombeima/components/sessionKey.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Asocombeima',
      home: mainWidget(),
    );
  }
}

class mainWidget extends StatefulWidget {
  const mainWidget({super.key});

  @override
  State<mainWidget> createState() => _mainWidgetState();
}

class _mainWidgetState extends State<mainWidget> {
  bool userExist = false; // Para ver cual pantalla mostrar
  String name = ''; // El nombre que se vera en la pantalla de monitor
  late Timer
      userTimer; // Un timer para revisar si la sesion existe (iniciar sesion o cerrar sesion)
  bool loadingPage = true; // Pantalla de carga cuando busca la sesion

  @override
  Widget build(context) {
    return mainScreen();
  }

  // Busca la sesion guardada en el telefono
  Future<void> checkUser() async {
    userExist = await sessionManager.containsKey('user');
    if (userExist) {
      var user = User.fromJson(await sessionManager.get('user'));
      name = user.name_lastname;
    }
    setState(() {
      loadingPage = false;
    });
  }

  // Dependiendo de si existe la sesion muestra una pantalla o la otra

  Widget mainScreen() {
    if (loadingPage) {
      return (Container(
        color: kBackgroundColor,
        child: const Center(child: CircularProgressIndicator()),
      ));
    } else {
      if (userExist) {
        return MonitorScreen(name: name);
      } else {
        return const LoginScreen();
      }
    }
  }

  @override
  void initState() {
    // Cada segundo busca la sesion, si se cerro cambiar a la pantalla de login otra vez
    userTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkUser();
    });
    super.initState();
  }

  @override
  void dispose() {
    userTimer.cancel();
    super.dispose();
  }
}
