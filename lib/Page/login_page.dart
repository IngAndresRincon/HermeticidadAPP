import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import '../Tools/complements.dart';
import '../Tools/functions.dart';
import '../Widgets/elevate_button.dart';
import '../Widgets/text_field.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

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
    String postUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTvalidarIngreso';
    postLogin(postUrl, jsonEncode(map)).then((value) {
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
              SizedBox(
                height: getScreenSize(context).height * 0.05,
              ),
              SizedBox(
                height: getScreenSize(context).height * 0.05,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const ScreenOverlaySetings();
                        });
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.greenAccent,
                        child: Icon(Icons.settings)),
                  ),
                ),
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
                      textColor: Colors.white,
                      labelColor: Colors.white,
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
                      textColor: Colors.white,
                      labelColor: Colors.white,
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

class ScreenOverlaySetings extends StatefulWidget {
  const ScreenOverlaySetings({super.key});

  @override
  State<ScreenOverlaySetings> createState() => _ScreenOverlaySetingsState();
}

class _ScreenOverlaySetingsState extends State<ScreenOverlaySetings> {
  @override
  void initState() {
    super.initState();
    readCacheData();
  }

  Future<void> writeCacheData(String ipApi, String portApi) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      CacheData cacheData = CacheData(ipApi, portApi);
      String cacheJson = jsonEncode(cacheData);
      developer.log('Cache escrita: $cacheJson');
      await prefs.setString('cacheJson', cacheJson);
    } catch (e) {
      developer.log("Error al escribir cache");
    }
  }

  Future<void> readCacheData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String cacheJson = prefs.getString('cacheJson') ?? "";
      if (cacheJson.isNotEmpty) {
        Map<String, dynamic> cacheMap = jsonDecode(cacheJson);
        developer.log('Cache leida: $cacheMap');
        CacheData cacheData = CacheData.fromJson(cacheMap);
        controllerIp.text = cacheData.ipApi;
        controllerPort.text = cacheData.portApi;
      }
    } catch (e) {
      developer.log("Error al leer cache");
    }
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
                      SizedBox(
                        height: getScreenSize(context).height * 0.05,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close)),
                        ),
                      ),
                      SizedBox(
                        height: getScreenSize(context).height * 0.05,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "CONFIGURACIÓN",
                            style: TextStyle(
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getScreenSize(context).height * 0.3,
                        width: getScreenSize(context).width * 0.9,
                        //color: Colors.black,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CustomerTextFieldLogin(
                                width: .8,
                                bsuffixIcon: false,
                                icondata: Icons.chevron_right,
                                label: "Ip",
                                obscure: false,
                                onTapSuffixIcon: () {},
                                suffixIcon: Icons.person,
                                texteditingcontroller: controllerIp,
                                textinputtype: TextInputType.url,
                                textColor: Colors.black,
                                labelColor: Colors.black,
                              ),
                              SizedBox(
                                height: getScreenSize(context).height * 0.03,
                              ),
                              CustomerTextFieldLogin(
                                  label: "Port",
                                  textinputtype: TextInputType.number,
                                  obscure: false,
                                  icondata: Icons.chevron_right,
                                  texteditingcontroller: controllerPort,
                                  bsuffixIcon: false,
                                  onTapSuffixIcon: () {},
                                  suffixIcon: Icons.person,
                                  width: .8,
                                  labelColor: Colors.black,
                                  textColor: Colors.black),
                            ]),
                      ),
                      SizedBox(
                        height: getScreenSize(context).height * 0.05,
                        width: getScreenSize(context).width * 0.9,
                        child: CustomerElevateButton(
                            texto: "GUARDAR",
                            colorTexto: Colors.white,
                            colorButton: Colors.green.shade400,
                            onPressed: () {
                              showDialogLoad(context);
                              writeCacheData(
                                      controllerIp.text, controllerPort.text)
                                  .then((value) {
                                Navigator.popAndPushNamed(context, 'login');
                              });
                            },
                            height: .05,
                            width: .5),
                      ),
                    ],
                  ))),
        ));
  }
}
