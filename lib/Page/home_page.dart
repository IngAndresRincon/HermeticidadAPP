import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Page/overlays_options_home.dart';
import 'package:hermeticidadapp/Tools/complements.dart';

import '../Tools/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PreferredSizeWidget _appBar() {
    return AppBar(
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
    );
  }

  Widget _drawerheader() {
    return DrawerHeader(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 2, 87, 109),
        ),
        child: Center(
          child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Image.asset('assets/logo.png')),
        ));
  }

  Widget _optionList(String text, IconData icon, Widget screen) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return screen;
            });
      },
      leading: Icon(icon),
      title: Text(text),
    );
  }

  Widget _logOutList(String text, IconData icon) {
    return ListTile(
      onTap: () {
        Navigator.pushReplacementNamed(context, 'login');
      },
      leading: Icon(icon),
      title: Text(text),
    );
  }

  Widget _infoText(
      String text, Color color, double fontSize, double letterSpacing) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            color: color, fontSize: fontSize, letterSpacing: letterSpacing),
      ),
    );
  }

  Widget _userCard() {
    return SizedBox(
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
                            vertical: 20, horizontal: 20),
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
                    flex: 3,
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _infoText(nombreUsuarioGlobal, Colors.white, 18, 2),
                            _infoText(rolUsuarioGlobal, Colors.white, 14, 2),
                            _infoText(fechaIngresoUsuario, Colors.white, 14, 2),
                            _infoText("Sistemas Insepet", Colors.white, 12, 2),
                          ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonCards(
      String text, String image, double width, void Function() function) {
    return GestureDetector(
      onTap: function,
      child: Card(
        color: const Color.fromARGB(255, 3, 143, 143),
        elevation: 20,
        child: Container(
          width: getScreenSize(context).width * width,
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  image,
                  color: Colors.white,
                  scale: 10,
                ),
                Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowCards() {
    return SizedBox(
      height: getScreenSize(context).height * .25,
      width: getScreenSize(context).width * .9,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buttonCards("PROGRAMACIONES", 'assets/document.png', 0.5, () {
            showDialog(
              context: context,
              builder: (context) {
                return const ScreenOverlaySchedules();
              },
            );
          }),
          _buttonCards("PRUEBA", 'assets/test.png', 0.3, () {
            Navigator.pushNamed(context, 'file');
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      drawer: Drawer(
        width: getScreenSize(context).width * .6,
        elevation: 10,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _drawerheader(),
            _optionList(
                'Messages', Icons.message, const ScreenOverlayMessages()),
            _optionList(
                'Profile', Icons.account_circle, const ScreenOverlayProfile()),
            _optionList(
                'Setings', Icons.settings, const ScreenOverlaySettingsHome()),
            _logOutList('LogOut', Icons.logout_outlined)
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
            SizedBox(height: getScreenSize(context).height * .1),
            _userCard(),
            SizedBox(height: getScreenSize(context).height * .05),
            _rowCards()
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
        value.isNotEmpty ? dynamicList = value : dynamicList = requestList;
        requestList = dynamicList;
        for (var i = 0; i < dynamicList.length; i++) {
          colorList.add(Colors.white);
        }
      });
    });
  }

  Widget _closeBar(double height, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(icon))),
    );
  }

  Widget _defaultText(double height, double fontSize, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: fontSize),
          )),
    );
  }

  Widget _requestList(double height) {
    return SizedBox(
        height: getScreenSize(context).height * height,
        child: dynamicList.isNotEmpty
            ? ListView.builder(
                itemCount: dynamicList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: colorList[index],
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          idProgramacion = dynamicList[index]['IdProgramacion'];
                          idEstacion = dynamicList[index]['IdEstacion'];
                          for (var i = 0; i < colorList.length; i++) {
                            colorList[i] = Colors.white;
                          }
                          colorList[index] = Colors.green.shade300;
                        });
                        Navigator.pushNamed(context, 'test');
                        //Navigator.pushNamed(context, 'test');
                      },
                      leading: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.label,
                            color: Colors.indigoAccent,
                          )),
                      title: Text('${dynamicList[index]['Estacion']}'),
                      subtitle: Text('${dynamicList[index]['OT']}'),
                      trailing: const Icon(Icons.info),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
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
                _closeBar(0.05, Icons.close),
                _defaultText(0.08, 18, "PROGRAMACION"),
                _requestList(0.3)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
