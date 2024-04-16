import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/screen_overlay.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  String dateTimeNow = "";
  bool obscurePassword = true;
  IconData iconSuffix = Icons.key_off;

  @override
  void initState() {
    super.initState();

    DateTime dateNow = DateTime.now();
    setState(() {
      dateTimeNow = "${dateNow.day}-${dateNow.month}-${dateNow.year}";
    });
  }

  void callScreenOverlay() {
    showDialog(
      context: context,
      builder: (context) => const ScreenOverlayConfiguration(),
    );
  }

  void validateUserLogin() async {
    try {
      Map<String, dynamic> mapLogin = {
        'Usuario': controllerEmail.text.trim(),
        'Contrasena': encriptador.encrypter(controllerPassword.text.trim())
      };
      await validateUser(jsonEncode(mapLogin)).then((value) {
        showMessageTOAST(context, value["Mensaje"], Colors.black54);
        if (!value["Error"]) {
          tokenUsuarioGlobal = value["Token"];
          idUsuarioGlobal = value["Data"]["Id"];
          rolUsuarioGlobal = value["Data"]["Rol"];
          nombreUsuarioGlobal = value["Data"]["Nombre"];
          fechaIngresoUsuario = value["Data"]["Fecha"];
          // Navigator.pushReplacementNamed(context, 'home');
          Navigator.pushNamed(context, 'homepage');
        }
      });
    } catch (e) {
      showMessageTOAST(context, e.toString(), Colors.black54);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: getScreenSize(context).width,
              height: getScreenSize(context).height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/fondo-gris1.jpg'),
                      fit: BoxFit.fill)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: getScreenSize(context).height * 0.5,
                      width: getScreenSize(context).width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/backgroundlogin.gif'),
                              fit: BoxFit.fill)),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              width: getScreenSize(context).width * 0.3,
                            ),
                            SizedBox(
                              width: getScreenSize(context).width * 0.8,
                              child: Text(
                                "HERMETICIDAD INSEPET",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'MontSerrat',
                                    fontSize:
                                        getScreenSize(context).width * 0.07,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: getScreenSize(context).width * 0.8,
                              child: Text(
                                "BIENVENIDO",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'MontSerrat',
                                    color: Colors.white,
                                    fontSize:
                                        getScreenSize(context).width * 0.05,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: getScreenSize(context).height * 0.5,
                      width: getScreenSize(context).width,
                      decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(60, 40))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CustomerTextFieldLogin(
                              label: "Correo",
                              textinputtype: TextInputType.emailAddress,
                              obscure: false,
                              icondata: Icons.mark_email_read_rounded,
                              texteditingcontroller: controllerEmail,
                              bsuffixIcon: false,
                              onTapSuffixIcon: () => {},
                              suffixIcon: Icons.mark_email_read,
                              width: 0.8,
                              labelColor: Colors.white,
                              textColor: Colors.white),
                          CustomerTextFieldLogin(
                              label: "Contraseña",
                              textinputtype: TextInputType.text,
                              obscure: obscurePassword,
                              icondata: Icons.password_rounded,
                              texteditingcontroller: controllerPassword,
                              bsuffixIcon: true,
                              onTapSuffixIcon: () => {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                      iconSuffix = iconSuffix == Icons.key_off
                                          ? Icons.key
                                          : Icons.key_off;
                                    })
                                  },
                              suffixIcon: iconSuffix,
                              width: 0.8,
                              labelColor: Colors.white,
                              textColor: Colors.white),
                          CustomerElevateButton(
                              texto: "Ingresar",
                              colorTexto: Colors.white,
                              colorButton: Colors.blue.shade400,
                              onPressed: validateUserLogin,
                              height: 0.06,
                              width: 0.8),
                          CustomerElevateButton(
                              texto: "Registrarme",
                              colorTexto: Colors.blue.shade400,
                              colorButton: Colors.white,
                              onPressed: () {},
                              height: 0.06,
                              width: 0.8)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                alignment: Alignment.topRight,
                child: IconButton(
                    highlightColor: Colors.black45,
                    onPressed: callScreenOverlay,
                    icon: Icon(
                      Icons.settings,
                      color: Colors.blue.shade400,
                      size: getScreenSize(context).width * 0.1,
                    ))),
          ],
        ),
      ),
    );
  }
}
