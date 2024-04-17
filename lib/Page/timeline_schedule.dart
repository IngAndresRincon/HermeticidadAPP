import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/forms.dart';
import 'package:hermeticidadapp/Widgets/timeline.dart';

class TimeLinePage1 extends StatefulWidget {
  final Map mapSchedule;
  const TimeLinePage1({super.key, required this.mapSchedule});

  @override
  State<TimeLinePage1> createState() => _TimeLinePage1State();
}

class _TimeLinePage1State extends State<TimeLinePage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Prueba De ${widget.mapSchedule["TipoPrueba"]}",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'MontSerrat',
              fontWeight: FontWeight.w600,
              fontSize: getScreenSize(context).width * 0.05),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: WillPopScope(
        child: SafeArea(
            child: Center(
          child: ListView(
            children: [
              CustomerTimeLine(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => HalfScreenForm1(
                        idProgramacion: widget.mapSchedule["IdProgramacion"],
                        idTipoPrueba: widget.mapSchedule["IdTipoPrueba"],
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  formulario: "Autorización Inicial",
                  isPast: widget.mapSchedule["RegistroInicio"],
                  isLast: false,
                  isFirts: true),
              CustomerTimeLine(
                  onTap: widget.mapSchedule["RegistroInicio"]
                      ? () async {
                          await showDialog(
                            context: context,
                            builder: (context) => HalfScreenForm2(
                              idProgramacion:
                                  widget.mapSchedule["IdProgramacion"],
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        }
                      : () {
                          showMessageTOAST(context, "Formulario no disponible",
                              Colors.black54);
                        },
                  formulario: "Registro Fotográfico",
                  isPast: widget.mapSchedule["RegistroFoto"],
                  isLast: false,
                  isFirts: false),
              CustomerTimeLine(
                  onTap: widget.mapSchedule["RegistroFoto"]
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => HalfScreenForm1(
                                idProgramacion:
                                    widget.mapSchedule["IdProgramacion"],
                                idTipoPrueba:
                                    widget.mapSchedule["IdTipoPrueba"]),
                          );
                        }
                      : () {
                          showMessageTOAST(context, "Formulario no disponible",
                              Colors.black54);
                        },
                  formulario: "Registro Calibración",
                  isPast: widget.mapSchedule["RegistroCalibracion"],
                  isLast: false,
                  isFirts: false),
              CustomerTimeLine(
                  onTap: widget.mapSchedule["RegistroCalibracion"]
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => HalfScreenForm1(
                                idProgramacion:
                                    widget.mapSchedule["IdProgramacion"],
                                idTipoPrueba:
                                    widget.mapSchedule["IdTipoPrueba"]),
                          );
                        }
                      : () {
                          showMessageTOAST(context, "Formulario no disponible",
                              Colors.black54);
                        },
                  formulario: "Prueba de Sistema",
                  isPast: widget.mapSchedule["RegistroInicioPrueba"],
                  isLast: false,
                  isFirts: false),
              CustomerTimeLine(
                  onTap: widget.mapSchedule["RegistroInicioPrueba"]
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => HalfScreenForm1(
                                idProgramacion:
                                    widget.mapSchedule["IdProgramacion"],
                                idTipoPrueba:
                                    widget.mapSchedule["IdTipoPrueba"]),
                          );
                        }
                      : () {
                          showMessageTOAST(context, "Formulario no disponible",
                              Colors.black54);
                        },
                  formulario: "Resultados",
                  isPast: widget.mapSchedule["RegistroResultados"],
                  isLast: false,
                  isFirts: false),
              CustomerTimeLine(
                  onTap: widget.mapSchedule["RegistroResultados"]
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => HalfScreenForm1(
                                idProgramacion:
                                    widget.mapSchedule["IdProgramacion"],
                                idTipoPrueba:
                                    widget.mapSchedule["IdTipoPrueba"]),
                          );
                        }
                      : () {
                          showMessageTOAST(context, "Formulario no disponible",
                              Colors.black54);
                        },
                  formulario: "Formulario de Cierre",
                  isPast: widget.mapSchedule["RegistroFinal"],
                  isLast: true,
                  isFirts: false),
              CustomerElevateButton(
                  texto: "Finalizar Prueba",
                  colorTexto: Colors.white,
                  colorButton: Colors.blue,
                  onPressed: () {},
                  height: 0.1,
                  width: 0.8)
            ],
          ),
        )),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }
}
