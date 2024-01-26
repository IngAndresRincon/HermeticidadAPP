import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Page/timeline_overlays.dart';
import 'package:hermeticidadapp/Tools/complements.dart';

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

  Widget _selectOption(String text, StatefulWidget modalWindow, bool isFirst,
      bool isLast, bool isPast, bool isNext) {
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
          text: text,
          pastColor: const Color(0xFF27AA69),
          nextColor: const Color(0xFF2B619C),
          noPastColor: const Color(0xFFDADADA),
        ));
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
            _selectOption("Calibracion", const TimeLineOverlayCalib(), false,
                false, pastList[2], nextList[2]),
            _selectOption("Prueba", const TimeLineOverlayTest(), false, false,
                pastList[3], nextList[3]),
            _selectOption("Resultados", const TimeLineOverlayResults(), false,
                false, pastList[4], nextList[4]),
            _selectOption("Formulario Final", const TimeLineOverlayLastForm(),
                false, true, pastList[5], nextList[5]),
          ],
        ),
      ),
    );
  }
}
