import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import '../Tools/complements.dart';
import '../Tools/functions.dart';
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

  void funtionButtonLogin(BuildContext context, Map<String, dynamic> map) {
    showDialogLoad(context);
    postLogin(jsonEncode(map)).then((value) {
      Navigator.pop(context);
      if (value != "500") {
        List<dynamic> dynamicData = jsonDecode(value);
        List<UserModel> dataUser =
            dynamicData.map((item) => UserModel.fromJson(item)).toList();
        if (dataUser.isNotEmpty) {
          if (dataUser[0].activo) {
            nombreUsuarioGlobal = dataUser[0].nombre;
            rolUsuarioGlobal = dataUser[0].rol;
            tokenUsuarioGlobal = dataUser[0].guid;
            idUsuarioGlobal = dataUser[0].id;
            fechaIngresoUsuario = dataUser[0].fecha;
            Navigator.pushReplacementNamed(context, 'home');
          } else {
            showMessageTOAST(context, "Usuario no activo", Colors.red.shade700);
          }
        } else {
          showMessageTOAST(
              context, "No se encuentra ningún usuario", Colors.red.shade700);
        }
      } else {
        showMessageTOAST(
            context, "No se pudo procesar la solicitud", Colors.red.shade700);
      }
    });
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
                      width: .8,
                      bsuffixIcon: false,
                      icondata: Icons.person,
                      label: "CORREO",
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
                      width: .8,
                      bsuffixIcon: true,
                      icondata: Icons.password_rounded,
                      label: "CONTRASEÑA",
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
                    SizedBox(
                      width: getScreenSize(context).width * .8,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Olvidé mi contraseña",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // decoration: TextDecoration.underline,
                                  // decorationColor: Colors.green.shade400,
                                  fontSize: 14,
                                  letterSpacing: 1),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomerElevateButton(
                        onPressed: () async {
                          if (controllerEmail.text.isEmpty ||
                              controllerPassword.text.isEmpty) {
                            showMessageTOAST(context, "Campos no validos",
                                Colors.red.shade700);
                            return;
                          }

                          Map<String, dynamic> mapDataUser = {
                            'Usuario': controllerEmail.text,
                            'Contrasena': controllerPassword.text
                          };
                          funtionButtonLogin(context, mapDataUser);
                        },
                        width: .8,
                        height: .08,
                        texto: "Ingresar",
                        colorTexto: Colors.white,
                        colorButton: Colors.green.shade300),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Resgistrarme",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 2),
                        )),
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
