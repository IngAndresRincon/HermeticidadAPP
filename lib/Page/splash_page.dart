import 'dart:async';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, 'login');
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(199, 4, 32, 80),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 80,
              child: Image(
                  fit: BoxFit.contain,
                  width: size.width * 0.4,
                  image: const AssetImage("assets/logo.png")),
            ),
            Container(
                width: size.width < 1000 ? size.width * 1 : size.width * 0.8,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.04),
                child: Text(
                  "SISTEMAS INSEPET",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * .035,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
