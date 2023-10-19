import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Page/showFilePage.dart';
import 'package:hermeticidadapp/Page/testPage.dart';

import 'Page/homePage.dart';
import 'Page/loginPage.dart';
import 'Page/splashPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APP HERMETICIDAD INSEPET',
      routes: {
        'splash': (context) => const SplashPage(),
        'login': (context) => const LoginPage(),
        'home': (context) => const HomePage(),
        'test': (context) => TestPage(),
        'file': (context) => FilePage(),
      },
      initialRoute: 'splash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
    );
  }
}
