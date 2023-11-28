import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Page/overlays_options_home.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';

import '../Tools/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 10,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.black54, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black54,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        width: getScreenSize(context).width * .6,
        elevation: 10,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 2, 87, 109),
                ),
                child: Center(
                  child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/logo.png')),
                )),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const ScreenOverlayMessages();
                    });
              },
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const ScreenOverlayProfile();
                    });
              },
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const ScreenOverlaySettingsHome();
                    });
              },
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text('LogOut'),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_white.jpg'),
                fit: BoxFit.fill)),
        child: ListView(
          children: [
            Container(
              height: getScreenSize(context).height * .1,
            ),
            SizedBox(
              height: getScreenSize(context).height * .3,
              child: Center(
                child: Card(
                  elevation: 20,
                  color: const Color.fromARGB(255, 43, 76, 104),
                  child: Container(
                    width: getScreenSize(context).width * .9,
                    height: getScreenSize(context).height * .3,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 5),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 60,
                                  child: Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 43, 76, 104),
                                    size: 70,
                                  ),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 4,
                            child: Center(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        nombreUsuarioGlobal,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 2),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        rolUsuarioGlobal,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            letterSpacing: 2),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        fechaIngresoUsuario,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            letterSpacing: 2),
                                      ),
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Sistemas Insepet",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            letterSpacing: 2),
                                      ),
                                    ),
                                  ]),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: getScreenSize(context).height * .25,
              width: getScreenSize(context).width * .9,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const ScreenOverlaySchedules();
                        },
                      );
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 3, 143, 143),
                      elevation: 20,
                      child: Container(
                        width: getScreenSize(context).width * .5,
                        color: Colors.transparent,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                'assets/document.png',
                                color: Colors.white,
                                scale: 10,
                              ),
                              const Text(
                                "PROGRAMACIONES",
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controllerPressure.text != '') {
                        Navigator.pushNamed(context, 'file');
                      }
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 3, 143, 143),
                      elevation: 20,
                      child: Container(
                        width: getScreenSize(context).width * .3,
                        color: Colors.transparent,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                'assets/test.png',
                                color: Colors.white,
                                scale: 9,
                              ),
                              const Text("PRUEBA",
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ScreenOverlaySchedules extends StatefulWidget {
  const ScreenOverlaySchedules({super.key});

  @override
  State<ScreenOverlaySchedules> createState() => _ScreenOverlaySchedulesState();
}

class _ScreenOverlaySchedulesState extends State<ScreenOverlaySchedules> {
  late List<dynamic> dynamicList = [];
  late List<dynamic> colorList = [];
  @override
  void initState() {
    super.initState();
    getListSchedule();
  }

  Future<void> getListSchedule() async {
    Map<String, dynamic> mapGetSchedule = {
      'IdUsuario': idUsuarioGlobal,
      'GuidSesion': tokenUsuarioGlobal
    };
    String peticionesUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTobtenerProgramacionPrueba';
    await getScheduleAPI(peticionesUrl, jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      //print(value);
      setState(() {
        dynamicList = value;
        for (var i = 0; i < dynamicList.length; i++) {
          colorList.add(Colors.white);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Card(
          color: const Color.fromARGB(242, 247, 247, 247),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: getScreenSize(context).width * 0.9,
            height: getScreenSize(context).height * 0.5,
            child: Column(
              children: [
                SizedBox(
                  height: getScreenSize(context).height * 0.05,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))),
                ),
                SizedBox(
                  height: getScreenSize(context).height * 0.08,
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "PROGRAMACIÓN",
                        style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                ),
                SizedBox(
                    height: getScreenSize(context).height * 0.3,
                    child: dynamicList.isNotEmpty
                        ? ListView.builder(
                            itemCount: dynamicList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    idProgramacion =
                                        dynamicList[index]['IdProgramacion'];
                                    idEstacion =
                                        dynamicList[index]['IdEstacion'];
                                    for (var i = 0; i < colorList.length; i++) {
                                      colorList[i] = Colors.white;
                                    }
                                    colorList[index] = Colors.green.shade300;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const ConfigTestOverlay();
                                    },
                                  );
                                  //Navigator.pushNamed(context, 'test');
                                },
                                child: Card(
                                  color: colorList[index],
                                  child: ListTile(
                                    leading: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.label,
                                          color: Colors.indigoAccent,
                                        )),
                                    title: Text(
                                        '${dynamicList[index]['Estacion']}'),
                                    subtitle:
                                        Text('${dynamicList[index]['OT']}'),
                                    trailing: const Icon(Icons.info),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfigTestOverlay extends StatefulWidget {
  const ConfigTestOverlay({super.key});

  @override
  State<ConfigTestOverlay> createState() => _ConfigTestOverlayState();
}

class _ConfigTestOverlayState extends State<ConfigTestOverlay> {
  Widget _popBar(double heightContent, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * heightContent,
      child: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(icon))),
    );
  }

  Widget _defaultText(String text, double fontSize, Color color,
      double letterSpacing, FontWeight fontWeight) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          letterSpacing: letterSpacing,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight),
    );
  }

  Widget _textFieldConfig(
      double height,
      String text,
      IconData icon,
      TextInputType textInputType,
      TextEditingController textEditingController) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: CustomerTextFieldLogin(
          label: text,
          textinputtype: textInputType,
          obscure: false,
          icondata: icon,
          texteditingcontroller: textEditingController,
          bsuffixIcon: false,
          onTapSuffixIcon: () {},
          suffixIcon: Icons.person,
          width: .8,
          labelColor: Colors.black,
          textColor: Colors.black),
    );
  }

  Widget _configButton(double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: Colors.green.shade400,
          onPressed: () {
            pressureCalib = int.parse(controllerPassword.text);
            timeAperture = int.parse(controllerTimeAperture.text);
            Navigator.pushNamed(context, 'test');
          },
          height: .05,
          width: .5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Card(
          color: const Color.fromARGB(242, 247, 247, 247),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: getScreenSize(context).width * 0.9,
            height: getScreenSize(context).height * 0.5,
            child: Column(children: [
              _popBar(0.05, Icons.close),
              _defaultText("CONFIGURACION CALIBRACION", 18, Colors.black54, 2,
                  FontWeight.bold),
              _textFieldConfig(
                  0.1,
                  "Presion de Calibracion (PSI)",
                  Icons.chevron_right,
                  TextInputType.number,
                  controllerPressure),
              _textFieldConfig(0.1, "Tolerancia (%)", Icons.chevron_right,
                  TextInputType.number, controllerTimeAperture),
              _configButton(0.05, "CONFIGURAR")
            ]),
          ),
        ),
      ),
    );
  }
}
