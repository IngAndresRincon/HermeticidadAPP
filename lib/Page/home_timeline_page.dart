import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Page/timeline_overlays.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HomeTimeLinePage extends StatefulWidget {
  const HomeTimeLinePage({super.key});

  @override
  State<HomeTimeLinePage> createState() => _HomeTimeLinePageState();
}

class _HomeTimeLinePageState extends State<HomeTimeLinePage> {
  List<bool> pastList = [];
  List<bool> nextList = [false, false, false, false, false, false];

  void savePastState() {
    pastList.clear();
    pastList.add(requestList[indexProgramacion].registroInicio);
    pastList.add(requestList[indexProgramacion].registroFoto);
    pastList.add(requestList[indexProgramacion].registroCalibracion);
    pastList.add(requestList[indexProgramacion].registroIncioPrueba);
    pastList.add(requestList[indexProgramacion].registroResultados);
    pastList.add(requestList[indexProgramacion].registroFinal);
  }

  void refreshNextState() {
    if (pastList[0] == false) {
      nextList[0] = true;
    }
    for (int i = 1; i < pastList.length; i++) {
      if (pastList[i] == false && pastList[i - 1] == true) {
        nextList[i] = true;
      } else {
        nextList[i] = false;
      }
    }
  }

  @override
  void initState() {
    savePastState();
    refreshNextState();
    super.initState();
  }

  Widget _defaultText(double height, String text, double fontSize, Color color,
      FontWeight fontWeight) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            letterSpacing: 4,
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight),
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

  Widget _selectOption(
    String text,
    StatefulWidget modalWindow,
    bool isFirst,
    bool isLast,
    bool isPast,
    bool isNext,
  ) {
    return GestureDetector(
        onTap: isNext
            ? () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return modalWindow;
                    }).then((value) {
                  setState(() {
                    savePastState();
                    refreshNextState();
                  });
                });
              }
            : () {},
        child: ItemLineTime(
            isFirts: isFirst,
            isLast: isLast,
            isPast: isPast,
            isNext: isNext,
            text: text));
  }

  Widget _photosMenu() {
    return SizedBox(
      width: getScreenSize(context).width,
      height: getScreenSize(context).height,
      child: Column(
        children: [
          SizedBox(height: getScreenSize(context).height * 0.05),
          _defaultText(0.1, "FOTOGRAFIAS TOMADAS COMO EVIDENCIAS", 25,
              Colors.black, FontWeight.bold)
        ],
      ),
    );
  }

  Widget _testMenu() {
    return SizedBox(
      width: getScreenSize(context).width,
      height: getScreenSize(context).height,
      child: Column(
        children: [
          SizedBox(height: getScreenSize(context).height * 0.05),
          _defaultText(
              0.1, "MENU DE PRUEBAS", 25, Colors.black, FontWeight.bold)
        ],
      ),
    );
  }

  Widget _sendMenu() {
    return SizedBox(
      width: getScreenSize(context).width,
      height: getScreenSize(context).height,
      child: Column(
        children: [
          SizedBox(height: getScreenSize(context).height * 0.05),
          _defaultText(
              0.1, "MENU DE ENVIADO", 25, Colors.black, FontWeight.bold)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: getScreenSize(context).width * 0.05),
        child: ListView(
          children: [
            SizedBox(height: getScreenSize(context).height * 0.02),
            _defaultText(0.08, "PRUEBA DE HERMETICIDAD", 25, Colors.black,
                FontWeight.bold),
            _defaultText(
                0.03,
                'Estacion: ${requestList[indexProgramacion].nombreEstacion}',
                16,
                Colors.black,
                FontWeight.bold),
            _defaultText(
                0.03,
                'Orden de Trabajo: ${requestList[indexProgramacion].ordenTrabajo}',
                16,
                Colors.black,
                FontWeight.bold),
            _selectOption(
                "Formulario de Inicio",
                const TimeLineOverlayFirstForm(),
                true,
                false,
                pastList[0],
                nextList[0]),
            _selectOption(
                "Evidencias Fotograficas",
                const TimeLineOverlayPhoto(),
                false,
                false,
                pastList[1],
                nextList[1]),
            _selectOption("Calibracion", const TimeLineOverlayFirstForm(),
                false, false, pastList[2], nextList[2]),
            _selectOption("Prueba", const TimeLineOverlayFirstForm(), false,
                false, pastList[3], nextList[3]),
            _selectOption("Resultados", const TimeLineOverlayFirstForm(), false,
                false, pastList[4], nextList[4]),
            _selectOption("Formulario Final", const TimeLineOverlayFirstForm(),
                false, true, pastList[5], nextList[5]),
          ],
        ),
      ),
    );
  }
}
