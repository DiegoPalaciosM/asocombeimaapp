// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFD2D700);
const kTextColor = Color(0xFF00A0E3);
const kBackgroundColor = Color(0xFFF2FDF7);

// Opcion 1: Conectarse a una base de datos. Problema: Hay que crear otra aplicaciones para presentar los datos
// Para crear la tabla de las cuentas
/*  create table account (
    user_id serial unique,
    username varchar(50) unique not null default '',
    password varchar(50) not null default '',
    name varchar(50) not null default '',
    serial_key varchar(15) not null default ''
    )
*/

const db_host = '';
const db_port = 0;
const db_user = '';
const db_pass = '';
const db_name = '';

// Opcion 2: Conectarse a una hoja de calculo de google. Problema: Requiere mayor uso de datos para conectarse pero es mas facil si manejo a la hora de crear cuentas

const credentials = r'''
{
  "type": "service_account",
  "project_id": "flutter-366404",
  "private_key_id": "e766be46d4a5a48ba5623a37525d06988113f10c",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC7xAvi33NaINBf\ntwBwWxyLnm4iP+QfcRDr7MaKOQSd4ql75E2Rs/vh8mwkc2b8MLSeEUzBKW2FxUhQ\nKJ1g0M37qXh0pVuL8apXwew8c3RI8zy8Gk1qthVjbexBjZ8YcEYvnQ+hccoUJ876\njny4QMYWV6qDnU4ncb0B+hIxN7cd46d75KAse8t1VzHIbWuF9DHDbEQGLEDDImRt\npOB/hO551N+DJaRJjfBJLSrhW07wrB32NDRS1kIpvR9vKBLvTcnY/04WDTEYGZDC\nzbLDenNnIJVn5tODVodMV32uUkBXikkPgoOgQidsCjp+RdS0/Aujrjq6+SgA8/AD\nmwQg1skjAgMBAAECggEAK55k5nzjRq41ye5wzykTTgntas5t17ID7NKx4p1RSb5E\ngg/sxyrJGlmfLq6SX4aPBuNc8ciGdVt5q4lr2fhXyZ06atqZFD79Q+q8TuTBQEsl\nMktn7aDEAjegeTAFo/89BsWVQnt1Js6CoikkpwcBHWKbLX0HEVm2PzXRMRbQ1sPM\nGbRpirzWDzYoH6LfHu4qUYWfhukz7qBZnybEv5A/ruIbH+n18W5ONBeHqgh1vHf6\nNjLiHtBj3whfl2kB1KdxfyWNlrJ0KHkTpNEqc5sDGQqPuMIeEvnRrz8MllacWCfo\nrpoB2oPJYGEASijn1jDonJpP3DGpPy8rYFEn/BmJJQKBgQDyu3Rb2t0YKx9Rk3lo\n9+uOcWzpianBi09M+yTB+Qi9QxbhAbTHRKICmr4aT37Zphgl9K395kSUwFq71cYD\nmWt0jwR9L+BvplUyoxXzlO4V1mimUu4prRaMQ9NESUxtPkYSyoPTVU9ibC5ozCZd\ndghGRCcmioXvw3v/MrxXt5lkHQKBgQDGB3K1lQiHazSmbPJ74N43yyrYOncIIPFp\nzHiSLF+i32RLXd4HXHkfK27B+9o5xHU8f7ghhzQu0BPtnKbjWEAbntPRbLGyjlLJ\n7Tm7DJdM29QT6xAKAj1hRpoactDuEMMgPd7bzRxjc+0gmPS7BGPN48dnwFXv9qMA\nvWw3k37ePwKBgQDmDAMbizI/1Z65EavfcBgvyBAQxge9BusBaoRL0loWBZ+JYLSU\nptdk4IOLLAxs+p2oW10LZVFaKXPU0aX5g030CheXDekH5/yXITmMwXlj+PD1sWNG\n3GSiSyXPciic4IhJBuYpRJEYFq9lYxZ5PYRaE/2G6YJG2l6KXuthtwAJgQKBgQCC\nxTxc6PPe6U61cFCYuaBFW+cJL2KXfZmuchZVAPSOy9KhanVKiyh5CudzNmufpjp9\nHyJrEavGFiZyzPXwP8Dl/HaIX6zg6teE/SEYgnIPkUN1e871rRD3gfYV7ShHbc5N\nJk5a/BH5Iv6+fgNu1LFLr1VpEDwv4ME3pd8mvEIVZQKBgETA7qGOTI7rt5tEef5H\npRxncbLuLXMZ/40riCXIvgFvjUCTKzaCjNgAjAw61ZIcp87N47AK4MQZ6Vzs3klA\n+/7qDWx/exY7i8hDUMeZquwzSJ3faZ7EZxKlBNgo7QOej4OIgseEvLAXBIRgEsPx\nGXDXiATGnMPOriQxPucCubPs\n-----END PRIVATE KEY-----\n",
  "client_email": "api-236@flutter-366404.iam.gserviceaccount.com",
  "client_id": "116301650190511402878",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/api-236%40flutter-366404.iam.gserviceaccount.com"
}
''';

const spreadsheetId = '1OV0pTeK8GGPJJmu8Qf8RQojryGMkN79PQv6o8IBqiOM';

// Para dar un mayor feedback cuando se presiona un boton
/* Para usarlo 

  AnimationButton(
                    enable: true,
                    onPressed: (){},  // Puede ser una funcion declarada o una en linea
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * 0.3,  // Cambia el ancho del boton, el alto se define automaticamente al tamano de la letra
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: kPrimaryColor),
                      child: Text(
                        'Texto del boton',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Libre Franklin',
                          fontSize: size.height * 0.025, // Cambiar tamaño de la letra dependiendo del tamaño de la pantalla
                        ),
                      ),
                    ),
                  ),
                )

*/

class AnimationButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final bool enable;

  const AnimationButton(
      {super.key,
      required this.child,
      required this.onPressed,
      required this.enable});

  @override
  State<AnimationButton> createState() => _AnimationButtonState();
}

class _AnimationButtonState extends State<AnimationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - controller.value;
    return Center(
        child: GestureDetector(
      onTap: widget.enable ? tap : () {},
      child: Transform.scale(
        scale: scale,
        child: widget.child,
      ),
    ));
  }

  void tap() {
    controller.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      controller.reverse();
      widget.onPressed();
    });
  }
}
