// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:math';

// Cuando se iniciar sesion se crear un objeto con este formato

class User {
  final String username;
  final String password;
  final String name_lastname;
  final String session_key;

  User(
      {required this.username,
      required this.password,
      required this.name_lastname,
      required this.session_key});

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        name_lastname = json['name_lastname'],
        session_key = json['session_key'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["username"] = username;
    user["password"] = password;
    user["name_lastname"] = name_lastname;
    user["session_key"] = session_key;
    return user;
  }
}

SessionManager sessionManager = SessionManager();

String generateKey() {
  return (getRandomString(15));
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
