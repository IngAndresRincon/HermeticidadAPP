import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';

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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Center(
                                child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                color: Colors.black54,
                                size: 60,
                              ),
                            ))),
                        Expanded(
                            flex: 4,
                            child: Center(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Nombre",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Rol",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Sistemas Insepet",
                                      style: TextStyle(color: Colors.white),
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
                  Card(
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
                  Card(
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
