import 'package:flutter/material.dart';

import '../Tools/complements.dart';
import '../Widgets/elevatebutton.dart';
import '../Widgets/textField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;
  IconData iconSuffix = Icons.key_off;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/fondo-gris1.jpg'), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: getScreenSize(context).height * 0.1,
              ),
              SizedBox(
                height: getScreenSize(context).height * 0.3,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "HERMETICIDAD INSEPET",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 4,
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "BIENVENIDO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 4,
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                height: getScreenSize(context).height * 0.6,
                width: getScreenSize(context).width,
                decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.elliptical(60, 40))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomerTextFieldLogin(
                      bsuffixIcon: false,
                      icondata: Icons.person,
                      label: "EMAIL",
                      obscure: false,
                      onTapSuffixIcon: () {},
                      suffixIcon: iconSuffix,
                      texteditingcontroller: controllerEmail,
                      textinputtype: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomerTextFieldLogin(
                      bsuffixIcon: true,
                      icondata: Icons.password_rounded,
                      label: "PASSWORD",
                      obscure: obscurePassword,
                      onTapSuffixIcon: () {
                        setState(() {
                          if (obscurePassword) {
                            obscurePassword = false;
                            iconSuffix = Icons.key;
                          } else {
                            obscurePassword = true;
                            iconSuffix = Icons.key_off;
                          }
                        });
                      },
                      suffixIcon: iconSuffix,
                      texteditingcontroller: controllerPassword,
                      textinputtype: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomerElevateButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'home');
                        },
                        width: .8,
                        height: .1,
                        texto: "Ingresar",
                        colorTexto: Colors.white,
                        colorButton: Colors.green.shade300),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
