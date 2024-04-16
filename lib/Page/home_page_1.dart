import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Page/timeline_schedule.dart';
import 'package:hermeticidadapp/Tools/cache.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  int selectIndexBottomNavigator = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  void initConfig() async {
    listaProgramacion.clear();
    await readConfiguration().then((CacheData value) {
      ipGlobal = value.ipApi;
      portGlobal = value.portApi;
    });

    await getListSchedule().then((List<dynamic> valuelist) {
      listaProgramacion = valuelist;
    });

    isLoading = !isLoading;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: [
            Container(
              color: const Color.fromARGB(255, 66, 61, 103),
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: getScreenSize(context).width * 0.6,
                              height: getScreenSize(context).height * 0.3,
                              child: Card(
                                elevation: 10,
                                color: Colors.indigo,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      rolUsuarioGlobal,
                                      style: TextStyle(
                                          fontFamily: 'MontSerrat',
                                          color: Colors.brown.shade100,
                                          fontSize:
                                              getScreenSize(context).width *
                                                  0.05,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      nombreUsuarioGlobal,
                                      style: TextStyle(
                                          fontFamily: 'MontSerrat',
                                          color: Colors.brown.shade100,
                                          fontSize:
                                              getScreenSize(context).width *
                                                  0.04,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      fechaIngresoUsuario,
                                      style: TextStyle(
                                          fontFamily: 'MontSerrat',
                                          color: Colors.brown.shade100,
                                          fontSize:
                                              getScreenSize(context).width *
                                                  0.04,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: getScreenSize(context).width * 0.08,
                              backgroundColor:
                                  const Color.fromARGB(255, 37, 35, 68),
                              child: Image.asset("assets/iconlogin.gif",
                                  width: getScreenSize(context).width * 0.2),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Divider(
                            color: Colors.white,
                            height: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          SizedBox(
                            width: getScreenSize(context).width * 0.8,
                            child: Center(
                              child: Text(
                                "Solicitudes",
                                style: TextStyle(
                                    fontFamily: 'MontSerrat',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.brown.shade100,
                                    fontSize:
                                        getScreenSize(context).width * 0.05),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 6,
                    child: !isLoading
                        ? ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: listaProgramacion.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Card(
                                  elevation: 10,
                                  color: Colors.indigo.shade200,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        listaProgramacion[index]
                                                ["IdProgramacion"]
                                            .toString(),
                                        style: TextStyle(
                                            fontFamily: 'MontSerrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getScreenSize(context).width *
                                                    0.03),
                                      ),
                                    ),
                                    title: RichText(
                                      text: TextSpan(
                                        text: 'Estación: ',
                                        style: TextStyle(
                                            fontFamily: 'MontSerrat',
                                            color: Colors.black,
                                            fontSize:
                                                getScreenSize(context).width *
                                                    0.03,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "${listaProgramacion[index]["Estacion"]}",
                                              style: TextStyle(
                                                  fontFamily: 'MontSerrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      getScreenSize(context)
                                                              .width *
                                                          0.03)),
                                        ],
                                      ),
                                    ),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        text: 'Programación: ',
                                        style: TextStyle(
                                            fontFamily: 'MontSerrat',
                                            color: Colors.black,
                                            fontSize:
                                                getScreenSize(context).width *
                                                    0.03,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "${listaProgramacion[index]["FechaProgramacion"]}",
                                              style: TextStyle(
                                                  fontFamily: 'MontSerrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      getScreenSize(context)
                                                              .width *
                                                          0.03)),
                                        ],
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.indigo.shade800,
                                    ),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TimeLinePage1(
                                              mapSchedule:
                                                  listaProgramacion[index]),
                                        )),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              child: BottomNavigationBar(
                  currentIndex: selectIndexBottomNavigator,
                  elevation: 10,
                  backgroundColor: Colors.white,
                  onTap: (value) {
                    setState(() {
                      // selectIndexBottomNavigator = value;
                      isLoading = !isLoading;
                    });

                    switch (value) {
                      case 0:
                        setState(() {
                          isLoading = !isLoading;
                        });
                        break;
                      case 1:
                        initConfig();
                        break;
                      case 2:
                        Navigator.pop(context);
                    }
                  },
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        backgroundColor: Colors.white,
                        icon: Icon(
                          Icons.home,
                        ),
                        label: "Inicio"),
                    BottomNavigationBarItem(
                        backgroundColor: Colors.white,
                        icon: Icon(Icons.change_circle_sharp),
                        label: "Actualizar"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.logout_rounded), label: "Salir"),
                  ]),
            ),
          ],
        ),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }
}
