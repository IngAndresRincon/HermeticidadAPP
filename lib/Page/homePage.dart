import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';

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
            const ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            const ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              onTap: () async {
                String strTest =
                    "2,1,00:00:00,0.00;2,1,00:00:01,17.56;2,1,00:00:02,17.56;2,1,00:00:03,17.56;2,1,00:00:04,17.56;2,1,00:00:05,17.56;2,1,00:00:06,17.56;2,1,00:00:07,17.56;";
                await postFile(strTest);
              },
              leading: const Icon(Icons.tab),
              title: const Text('Test'),
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
        child: Column(
          children: [
            Container(
              height: getScreenSize(context).height * .2,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Navigator.pushNamed(context, 'test');
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
  var texto = "Hola";
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

    await getScheduleAPI(jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      print(value);
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
            height: getScreenSize(context).height * 0.6,
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
                    height: getScreenSize(context).height * 0.4,
                    child: dynamicList.isNotEmpty
                        ? ListView.builder(
                            itemCount: dynamicList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: colorList[index],
                                child: ListTile(
                                  leading: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          idProgramacion =
                                              dynamicList[index]['IdProgramacion'];
                                          idEstacion =
                                              dynamicList[index]['IdEstacion'];
                                          for (var i = 0;
                                              i < colorList.length;
                                              i++) {
                                            colorList[i] = Colors.white;
                                          }
                                          colorList[index] = Colors.green;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.label,
                                        color: Colors.indigoAccent,
                                      )),
                                  title:
                                      Text('${dynamicList[index]['Estacion']}'),
                                  subtitle: Text('${dynamicList[index]['OT']}'),
                                  trailing: const Icon(Icons.info),
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
