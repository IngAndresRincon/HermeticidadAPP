import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';

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
    enablePasswordConfig = false;
  }

  Widget _closeBar(double height, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(icon)),
      ),
    );
  }

  Widget _defaultText(double height, String text, double fontSize,
      double letterSpacing, FontWeight fontWeight) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Text(
        text,
        style: TextStyle(
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontSize: fontSize),
      ),
    );
  }

  Widget _textFieldConfig(
      double height,
      String text,
      IconData icon,
      TextInputType textInputType,
      TextEditingController textEditingController) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: CustomerTextFieldLogin(
          label: text,
          textinputtype: textInputType,
          obscure: false,
          icondata: icon,
          texteditingcontroller: textEditingController,
          bsuffixIcon: false,
          onTapSuffixIcon: () {},
          suffixIcon: Icons.person,
          width: .8,
          labelColor: Colors.black,
          textColor: Colors.black),
    );
  }

  Widget _configButton(double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: Colors.green.shade400,
          onPressed: () {
            showDialogLoad(context);
            writeCacheData(controllerIp.text, controllerPort.text)
                .then((value) {
              Navigator.popAndPushNamed(context, 'login');
            });
          },
          height: .05,
          width: .5),
    );
  }

  Widget _passWordButton(double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: Colors.green.shade400,
          onPressed: () {
            if (controllerPasswordConfig.text == passwordConfig) {
              setState(() {
                enablePasswordConfig = true;
                controllerPasswordConfig.text = '';
              });
            } else {
              showMessageTOAST(context, "Contraseña Incorrecta", Colors.red);
            }
          },
          height: .05,
          width: .5),
    );
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
                  height: getScreenSize(context).height * 0.4,
                  child: Column(
                    children: [
                      _closeBar(0.05, Icons.close),
                      _defaultText(
                          0.05, "CONFIGURACION", 18, 2, FontWeight.bold),
                      enablePasswordConfig ? _configPage() : _passwordPage()
                    ],
                  ))),
        ));
  }

  Widget _passwordPage() {
    return Column(children: [
      SizedBox(
        height: getScreenSize(context).height * 0.05,
      ),
      _textFieldConfig(0.1, "Contraseña", Icons.password, TextInputType.text,
          controllerPasswordConfig),
      _passWordButton(0.05, "Ingresar a Configuracion")
    ]);
  }

  Widget _configPage() {
    return Column(children: [
      _textFieldConfig(
          0.1, "Ip", Icons.chevron_right, TextInputType.number, controllerIp),
      _textFieldConfig(0.1, "Puerto", Icons.chevron_right, TextInputType.text,
          controllerPort),
      _configButton(0.05, "Guardar"),
    ]);
  }
}

class ScreenOverlayRegister extends StatefulWidget {
  const ScreenOverlayRegister({super.key});

  @override
  State<ScreenOverlayRegister> createState() => _ScreenOverlayRegisterState();
}

class _ScreenOverlayRegisterState extends State<ScreenOverlayRegister> {
  Widget _closeBar(double height, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(icon),
        ),
      ),
    );
  }

  Widget _defaultText(double height, String text, double fontSize,
      double letterSpacing, FontWeight fontWeight) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Text(text,
          style: TextStyle(
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontSize: fontSize)),
    );
  }

  Widget _textFieldRegister(
      double height,
      String text,
      IconData icon,
      TextInputType textInputType,
      TextEditingController textEditingController) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: CustomerTextFieldLogin(
          label: text,
          textinputtype: textInputType,
          obscure: false,
          icondata: icon,
          texteditingcontroller: textEditingController,
          bsuffixIcon: false,
          onTapSuffixIcon: () {},
          suffixIcon: Icons.person,
          width: .8,
          labelColor: Colors.black,
          textColor: Colors.black),
    );
  }

  Widget _registerButton(double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: Colors.green.shade400,
          onPressed: () {
            controllerNameRegister.text = "";
            controllerLastNameRegister.text = "";
            controllerEmailRegister.text = "";
            controllerPasswordRegister.text = "";
            Navigator.pushReplacementNamed(context, 'login');
          },
          height: .05,
          width: .5),
    );
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
            height: getScreenSize(context).height * 0.6,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(
                    0.05, "FORMATO DE REGISTRO", 18, 2, FontWeight.bold),
                _textFieldRegister(0.1, "Nombre", Icons.person,
                    TextInputType.name, controllerNameRegister),
                _textFieldRegister(0.1, "Apellido", Icons.person,
                    TextInputType.name, controllerLastNameRegister),
                _textFieldRegister(0.1, "Correo", Icons.email,
                    TextInputType.emailAddress, controllerEmailRegister),
                _textFieldRegister(0.1, "Contraseña", Icons.password,
                    TextInputType.visiblePassword, controllerPasswordRegister),
                _registerButton(0.05, "Registrarse")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenOverlayForgetPass extends StatefulWidget {
  const ScreenOverlayForgetPass({super.key});

  @override
  State<ScreenOverlayForgetPass> createState() =>
      _ScreenOverlayForgetPassState();
}

class _ScreenOverlayForgetPassState extends State<ScreenOverlayForgetPass> {
  Widget _closeBar(double height, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(icon),
        ),
      ),
    );
  }

  Widget _defaultText(double height, String text, double fontSize,
      double letterSpacing, FontWeight fontWeight) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Text(text,
          style: TextStyle(
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontSize: fontSize)),
    );
  }

  Widget _textFieldForget(
      double height,
      String text,
      IconData icon,
      TextInputType textInputType,
      TextEditingController textEditingController) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: CustomerTextFieldLogin(
          label: text,
          textinputtype: textInputType,
          obscure: false,
          icondata: icon,
          texteditingcontroller: textEditingController,
          bsuffixIcon: false,
          onTapSuffixIcon: () {},
          suffixIcon: Icons.person,
          width: .8,
          labelColor: Colors.black,
          textColor: Colors.black),
    );
  }

  Widget _forgetPasswordButton(double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: Colors.green.shade400,
          onPressed: () {
            controllerEmailForget.text = "";
            Navigator.pushReplacementNamed(context, 'login');
          },
          height: .05,
          width: .5),
    );
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
            height: getScreenSize(context).height * 0.3,
            child: Column(children: [
              _closeBar(0.05, Icons.close),
              _defaultText(
                  0.05, "OLDIVÉ MI CONTRASEÑA", 18, 2, FontWeight.bold),
              _textFieldForget(0.1, "Correo", Icons.email,
                  TextInputType.emailAddress, controllerEmailForget),
              _forgetPasswordButton(0.05, "Enviar")
            ]),
          ),
        ),
      ),
    );
  }
}
