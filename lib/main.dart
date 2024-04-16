import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Page/home_page_1.dart';
import 'package:hermeticidadapp/Page/home_timeline_page.dart';
import 'package:hermeticidadapp/Page/login_page_1.dart';
import 'package:hermeticidadapp/Page/show_file_page.dart';
import 'package:hermeticidadapp/Page/test_page.dart';

import 'Page/home_page.dart';
import 'Page/login_page.dart';
import 'Page/splash_page.dart';
import 'Page/camera_page.dart';

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
        'login1': (context) => const Login_Page(),
        'home': (context) => const HomePage(),
        'homepage': (context) => const HomePage1(),
        'home1': (context) => const HomeTimeLinePage(),
        'test': (context) => TestPage(),
        'file': (context) => FilePage(),
        'camera': (context) => const CameraPage(),
      },
      initialRoute: 'splash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade300),
        useMaterial3: true,
      ),
    );
  }
}
