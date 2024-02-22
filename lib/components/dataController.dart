// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'package:asocombeima/contants.dart';
import 'sessionKey.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_excel/excel.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;

// Abre el archivo local, si no existe lo crea

Future<Excel> getExcel() async {
  var file = (await _localFile);
  if (!file.existsSync()) {
    var excel = Excel.createExcel();
    excel = createTitles(excel);
    return excel;
  }
  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  return excel;
}

Excel createTitles(var excel) {
  CellStyle cellStyle = CellStyle(
    fontSize: 18,
    bold: true,
    fontColorHex: '#a83232',
    verticalAlign: VerticalAlign.Center,
    horizontalAlign: HorizontalAlign.Center,
  );
  Sheet sheet = excel[excel.getDefaultSheet()];
  var titles = [
    'Usuario',
    'Ubicación',
    'Descripción',
    'Información Extra',
    'Creación',
  ];
  excel.appendRow(sheet.sheetName, titles);
  for (var i = 0; i < titles.length; i++) {
    var cell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: i,
      rowIndex: 0,
    ));
    cell.cellStyle = cellStyle;
  }

  return excel;
}

// Agrega la informacion al archivo local

Future<void> addData(List<dynamic> data) async {
  Excel excel = await getExcel();
  final now = DateTime.now();
  data.add(
      '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}');
  excel.appendRow(excel.getDefaultSheet() as String, data);
  var bytes = excel.save();
  writeData(bytes!);
}

// Busca la ruta de aplicacion para guardar o abrir el archivo. "Android/data/com.asocombeima.asocombeima"

Future<String?> get _localPath async {
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  return directory?.path;
}

// La ruta absoluta del archivo

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.xlsx');
}

// Guarda el excel local

Future<File> writeData(List<int> bytes) async {
  final file = await _localFile;
  return file.writeAsBytes(bytes, flush: true);
}

// Se conecta con el documento en linea, retorna true o false para verificar la conexion

Future<List<dynamic>> getExcelOnline(sheetName) async {
  final GSheets gsheets = GSheets(credentials);
  try {
    final Spreadsheet ss = await gsheets.spreadsheet(spreadsheetId);
    var sheet = ss.worksheetByTitle(sheetName);
    return [true, sheet];
  } catch (_) {
    return [false, ''];
  }
}

Future<bool> checkExcelOnline() async {
  var valor = await getExcelOnline('Datos').timeout(const Duration(seconds: 10),
      onTimeout: () {
    return [false, ''];
  });
  return valor[0];
}

Future<bool> checkInternet() async {
  try {
    await http
        .get(Uri.parse('https://www.google.com/'))
        .timeout(const Duration(seconds: 10));
    return true;
  } catch (_) {
    return false;
  }
}

// En la segunda hoja del documento se encuentran los usuarios.
// Para iniciar sesion de esta forma en el archivo "screens/login/components/body.dart" la constante db debe estar en false

Future<User> getUser(username, password) async {
  Worksheet sheet = (await getExcelOnline('Cuentas'))[1];
  var rows = await sheet.values.map.allRows();
  for (var row in rows!) {
    if (row['usuario'] == username && row['contraseña'] == password) {
      return User(
          username: row['usuario']!,
          password: row['contraseña']!,
          name_lastname: row['nombre']!,
          session_key: '');
    }
  }
  return User(username: '', password: '', name_lastname: '', session_key: '');
}

// Sube la informacion al documento en linea y eliminar la informacion local

Future<String> uploadData() async {
  var sheet = (await getExcelOnline('Datos'))[1];
  var excel = await getExcel();
  var sheetLocal = excel[excel.getDefaultSheet() as String];
  var rows = excel.tables[sheetLocal.sheetName]!.rows;
  rows.removeAt(0);
  for (var row in rows) {
    if (await sheet.values.map.appendRow({
      'Nombre': row[0]?.value,
      'Ubicación': row[1]?.value,
      'Descripción': row[2]?.value,
      'Información Extra': row[3]?.value,
      'Creación': row[4]?.value
    })) {
      sheetLocal.removeRow(1);
    }
  }
  var bytes = excel.save();
  writeData(bytes!);
  return 'Datos guardados en linea';
}
