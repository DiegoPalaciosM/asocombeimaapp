import 'package:asocombeima/components/dataController.dart';
import 'package:flutter/material.dart';
import 'package:asocombeima/contants.dart';
import 'package:asocombeima/components/sessionKey.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.name});
  final String name;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  // Lista de ubicacion de la pantalla de monitoreo
  final itemsUbi = [
    'Bocatoma Laserna Sarmiento',
    'Bocatoma Aceituno',
    'Canaleta Reposo',
    'Canaleta Partidos Ambafer',
    'Canaleta Escobal',
    'Canaleta Pradera',
    'Canaleta Pista Vieja',
    'Partidor Perales',
    'Canal Escobal',
    'Captación Agua Sucia'
  ];
  // El valor por defecto, debe ser el primero de la lista anterior
  String dropUbi = 'Bocatoma Laserna Sarmiento';
  // Lista de descripcion de la pantalla de monitoreo
  final itemsDes = ['Medición', 'Manteminiento', 'Estado de rio', 'Emergencia'];
  // El valor por defecto, debe ser el primero de la lista anterior
  String dropDes = 'Medición';
  late TextEditingController extraController;
  // Dependiendo de la pestaña seleccionada en la barra inferior el valor cambia
  // Si se agregan mas, en la funcion monitorScreen cambiar el if 
  int _selectedIndex = 0;
  bool checkDocument = false;
  bool checkNet = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      body: monitorScreen(size: size),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Cerrar Sesion',
          backgroundColor: kPrimaryColor,
          onPressed: () {
            sessionManager.remove('user');
          },
          child: const Icon(Icons.logout)),
      bottomNavigationBar: bottomBarBuilder(),
    );
  }

  BottomNavigationBar bottomBarBuilder() {
    Size size = MediaQuery.of(context).size;
    return BottomNavigationBar(
      backgroundColor: kPrimaryColor,
      selectedItemColor: Colors.black,
      iconSize: size.height * 0.04,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: 'Crear',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_to_drive_rounded),
          label: 'Subir',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: ((index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
    );
  }

  SingleChildScrollView monitorScreen({required Size size}) {
    if (_selectedIndex == 0) {
      checkDocument = checkNet = false;
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: size.height, minWidth: size.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.height * 0.2,
                width: size.width,
                child: Stack(
                  children: [
                    Container(
                      height: size.height * 0.15,
                      color: kPrimaryColor,
                    ),
                    ClipOval(
                      child: Container(
                        color: kPrimaryColor,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Identificado como',
                      style: TextStyle(
                        fontSize: size.height * 0.035,
                        fontFamily: 'Libre Franklin',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: size.height * 0.025,
                        fontFamily: 'Libre Franklin',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: size.width * 0.35,
                          child: Text(
                            'Ubicación',
                            style: TextStyle(
                              fontSize: size.height * 0.025,
                              fontFamily: 'Libre Franklin',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.45,
                          child: DropdownButton(
                            isExpanded: true,
                            value: dropUbi,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: itemsUbi.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropUbi = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: size.width * 0.35,
                          child: Text(
                            'Descripción',
                            style: TextStyle(
                              fontSize: size.height * 0.025,
                              fontFamily: 'Libre Franklin',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.45,
                          child: DropdownButton(
                            isExpanded: true,
                            value: dropDes,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: itemsDes.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDes = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informacion Extra',
                      style: TextStyle(
                        fontSize: size.height * 0.025,
                        fontFamily: 'Libre Franklin',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                      child: TextField(
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          saveData(size);
                        },
                        keyboardType: (dropDes == 'Medición')
                            ? TextInputType.number
                            : TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        controller: extraController,
                        maxLines: 10,
                        style: const TextStyle(fontFamily: 'Libre Franklin'),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: AnimationButton(
                    enable: true,
                    onPressed: () {
                      saveData(size);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: kPrimaryColor),
                      child: Text(
                        'Guardar',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Libre Franklin',
                          fontSize: size.height * 0.025,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: const Text(
                      'Nota: Esto guardara un archivo de forma local. Para subirlo al archivo compartido ir a la pestaña "Subir" y realizar el proceso.'),
                ),
              ),
              SizedBox(
                height: size.height * 0.35,
              ),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: size.height, minWidth: size.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.height * 0.2,
                width: size.width,
                child: Stack(
                  children: [
                    Container(
                      height: size.height * 0.15,
                      color: kPrimaryColor,
                    ),
                    ClipOval(
                      child: Container(
                        color: kPrimaryColor,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pasos a seguir:',
                      style: TextStyle(
                        fontSize: size.height * 0.035,
                        fontFamily: 'Libre Franklin',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '''1. Verificar conexion a internet\n2. Verificar conexion con el documento en linea\n3. Presionar el boton "Compartir"\n4. Esperar confirmacion en la parte inferior de la pantalla''',
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontFamily: 'Libre Franklin',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      checkNet ? Icons.check_box : Icons.warning,
                      color: checkNet ? Colors.green : Colors.red,
                    ),
                    AnimationButton(
                      enable: true,
                      onPressed: () async {
                        checkNet = await checkInternet();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width * 0.5,
                        height: size.height * 0.04,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: kPrimaryColor),
                        child: Text(
                          'Verificar conexion',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Libre Franklin',
                            fontSize: size.height * 0.025,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      checkDocument ? Icons.check_box : Icons.warning,
                      color: checkDocument ? Colors.green : Colors.red,
                    ),
                    AnimationButton(
                      enable: checkNet,
                      onPressed: () async {
                        checkDocument = await checkExcelOnline();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width * 0.5,
                        height: size.height * 0.04,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: checkNet
                                ? kPrimaryColor
                                : const Color.fromARGB(255, 68, 68, 68)),
                        child: Text(
                          'Verificar documento',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Libre Franklin',
                            fontSize: size.height * 0.025,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: AnimationButton(
                  enable: checkDocument & checkNet,
                  onPressed: () async {
                    notificationSave(await uploadData(), true, size);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width * 0.6,
                    height: size.height * 0.04,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: checkNet & checkDocument
                            ? kPrimaryColor
                            : const Color.fromARGB(255, 68, 68, 68)),
                    child: Text(
                      'Compartir',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Libre Franklin',
                        fontSize: size.height * 0.025,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: const Text(
                      'Nota: Los pasos 1, 2 y 3 corresponden a los botones disponibles.\n\nNota2: Esto guardara un archivo en un documento compartido. Una vez sea guardado la información sera eliminada del dispositivo.'),
                ),
              ),
              SizedBox(
                height: size.height * 0.25,
              ),
            ],
          ),
        ),
      );
    }
  }

  // Guarda la informacion en el excel local y devuelve a los valores por defecto

  void saveData(Size size) async {
    await addData([widget.name, dropUbi, dropDes, extraController.text]);
    setState(() {
      dropUbi = 'Bocatoma Laserna Sarmiento';
      dropDes = 'Medición';
      extraController.text = '';
    });
    notificationSave('Datos guardados localmente', true, size);
  }

  // Un popup para dar informacion

  void notificationSave(String text, bool color, Size size) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        //behavior: SnackBarBehavior.floating,
        content: Text(text),
        backgroundColor: color ? Colors.green : Colors.red,
      ));
  }

  @override
  void initState() {
    super.initState();
    extraController = TextEditingController();
    checkDocument = checkNet = false;
    _selectedIndex = 0;
  }
}
