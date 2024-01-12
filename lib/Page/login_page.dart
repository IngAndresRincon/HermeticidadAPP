import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Page/overlays_login.dart';
import '../Tools/complements.dart';
import '../Tools/functions.dart';
import '../Widgets/elevate_button.dart';
import '../Widgets/text_field.dart';

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
    readCacheData();
  }

  void funtionButtonLogin(BuildContext context, Map<String, dynamic> map) {
    showDialogLoad(context);
    String postUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTvalidarIngreso';
    postLogin(postUrl, jsonEncode(map)).then((value) {
      Navigator.pop(context);
      try {
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
              showMessageTOAST(
                  context, "Usuario no activo", Colors.red.shade700);
            }
          } else {
            showMessageTOAST(
                context, "No se encuentra ningún usuario", Colors.red.shade700);
          }
        } else {
          showMessageTOAST(
              context, "No se pudo procesar la solicitud", Colors.red.shade700);
        }
      } catch (e) {
        showMessageTOAST(
            context, "Verifique la conexion a internet", Colors.red.shade700);
      }
    });
  }

  Widget _configButton(double height, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return const ScreenOverlaySetings();
              });
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.greenAccent,
              child: Icon(icon)),
        ),
      ),
    );
  }

  Widget _titleTexts(double height, String title, String subTitle) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                letterSpacing: 4,
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
                letterSpacing: 4,
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _textFieldLogin(double height, String text, IconData icon, bool hide,
      TextEditingController controller, TextInputType inputType) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: CustomerTextFieldLogin(
        width: .8,
        bsuffixIcon: hide,
        icondata: icon,
        label: text,
        obscure: hide ? obscurePassword : false,
        onTapSuffixIcon: hide
            ? () {
                setState(() {
                  if (obscurePassword) {
                    obscurePassword = false;
                    iconSuffix = Icons.key;
                  } else {
                    obscurePassword = true;
                    iconSuffix = Icons.key_off;
                  }
                });
              }
            : () {},
        suffixIcon: iconSuffix,
        texteditingcontroller: controller,
        textinputtype: inputType,
        textColor: Colors.white,
        labelColor: Colors.white,
      ),
    );
  }

  Widget _textButton(double height, String text, AlignmentGeometry alignment,
      double fontSize, Widget overlay) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * .8,
      child: Align(
        alignment: alignment,
        child: TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return overlay;
                  });
            },
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // decoration: TextDecoration.underline,
                  // decorationColor: Colors.green.shade400,
                  fontSize: fontSize,
                  letterSpacing: 1),
            )),
      ),
    );
  }

  Widget _loginButton(double height, String text) {
    return CustomerElevateButton(
        onPressed: () async {
          if (controllerEmail.text.isEmpty || controllerPassword.text.isEmpty) {
            showMessageTOAST(context, "Campos no validos", Colors.red.shade700);
            return;
          }

          Map<String, dynamic> mapDataUser = {
            'Usuario': controllerEmail.text,
            'Contrasena': encriptador.encrypter(controllerPassword.text)
          };
          funtionButtonLogin(context, mapDataUser);
        },
        width: .8,
        height: height,
        texto: text,
        colorTexto: Colors.white,
        colorButton: Colors.green.shade400);
  }

  Widget _loginForm(double height) {
    return Container(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width,
      decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(topLeft: Radius.elliptical(60, 40))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _textFieldLogin(0.1, "CORREO", Icons.person, false, controllerEmail,
              TextInputType.emailAddress),
          _textFieldLogin(0.07, "CONTRASEÑA", Icons.password_rounded, true,
              controllerPassword, TextInputType.text),
          _textButton(0.05, "Olvidé mi contraseña", Alignment.centerRight, 14,
              const ScreenOverlayForgetPass()),
          SizedBox(height: getScreenSize(context).height * 0.02),
          _loginButton(0.08, "Ingresar"),
          _textButton(0.06, "Registrarme", Alignment.center, 16,
              const ScreenOverlayRegister()),
        ],
      ),
    );
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
              SizedBox(height: getScreenSize(context).height * 0.05),
              _configButton(0.05, Icons.settings),
              _titleTexts(0.3, "HERMETICIDAD INSEPET", "BIENVENIDO"),
              _loginForm(0.6)
            ],
          ),
        ),
      ),
    );
  }
}
