import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Page/camera_page.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/DropDownButton.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';

TextEditingController controlleNombreEstacion = TextEditingController();
TextEditingController controlleResponsableEstacion = TextEditingController();
TextEditingController controlleFechaAutorizacion = TextEditingController();

class HalfScreenForm1 extends StatefulWidget {
  final int idProgramacion;
  final int idTipoPrueba;
  const HalfScreenForm1(
      {super.key, required this.idProgramacion, required this.idTipoPrueba});

  @override
  State<HalfScreenForm1> createState() => _HalfScreenForm1State();
}

class _HalfScreenForm1State extends State<HalfScreenForm1> {
  DateTime selectedDate = DateTime.now();
  bool isAuthorized = false;
  static const double textFormWidth = 0.7;

  @override
  void initState() {
    controlleNombreEstacion.clear();
    controlleResponsableEstacion.clear();
    controlleFechaAutorizacion.clear();
    super.initState();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController selectedController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        final String month =
            picked.month < 10 ? "0${picked.month}" : "${picked.month}";
        final String day = picked.day < 10 ? "0${picked.day}" : "${picked.day}";
        selectedController.text = "${picked.year}-$month-$day";
      });
    }
  }

  void formAutorized() async {
    try {
      Map<String, dynamic> form = {
        "Token": tokenUsuarioGlobal,
        "IdProgramacion": widget.idProgramacion,
        "NombreEstacion": controlleNombreEstacion.text.trim(),
        "ResponsableEstacion": controlleResponsableEstacion.text.trim(),
        "IdTipoPrueba": widget.idTipoPrueba,
        "Autorizado": isAuthorized,
        "Fecha":
            "${controlleFechaAutorizacion.text.trim()} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}"
      };

      await sendFormAuthorized(jsonEncode(form)).then((Map value) {
        showMessageTOAST(context, value["Mensaje"], Colors.black54);

        if (value["Codigo"] == 200 && !value["Error"]) {
          for (var element in listaProgramacion) {
            if (element["IdProgramacion"] == widget.idProgramacion) {
              element["RegistroInicio"] = isAuthorized;
            }
          }
        } else {
          for (var element in listaProgramacion) {
            if (element["IdProgramacion"] == widget.idProgramacion) {
              element["RegistroInicio"] = false;
            }
          }
        }
        Navigator.pop(context);
      });
    } catch (e) {
      showMessageTOAST(context, e.toString(), Colors.black54);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: getScreenSize(context).width * 0.8,
          height: getScreenSize(context).height * 0.7,
          padding: EdgeInsets.all(getScreenSize(context).width * 0.01),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 6,
                    color: Colors.white70,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 2)
              ]),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: getScreenSize(context).width * textFormWidth,
                    child: Center(
                      child: Text(
                        "Formulario Autorización",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'MontSerrat',
                            fontSize: getScreenSize(context).width * 0.06,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomerTextFormField(
                        label: "Nombre Estación",
                        textinputtype: TextInputType.text,
                        obscure: false,
                        icondata: Icons.label,
                        texteditingcontroller: controlleNombreEstacion,
                        bsuffixIcon: false,
                        onTapSuffixIcon: () {},
                        suffixIcon: Icons.label,
                        width: textFormWidth,
                        labelColor: Colors.black54,
                        textColor: Colors.black87,
                        onChange: (value) {},
                      ),
                      CustomerTextFormField(
                        label: "Responsable Estación",
                        textinputtype: TextInputType.text,
                        obscure: false,
                        icondata: Icons.label,
                        texteditingcontroller: controlleResponsableEstacion,
                        bsuffixIcon: false,
                        onTapSuffixIcon: () {},
                        suffixIcon: Icons.label,
                        width: textFormWidth,
                        labelColor: Colors.black54,
                        textColor: Colors.black87,
                        onChange: (value) {},
                      ),
                      CustomerDropDownButton(
                        onChange: (String? value) {
                          if (value != null) {
                            switch (value) {
                              case "SI":
                                isAuthorized = true;
                                break;
                              case "NO":
                                isAuthorized = false;
                                break;
                              default:
                                isAuthorized = false;
                                break;
                            }
                          }
                        },
                      ),
                      CustomerTextFormField(
                        label: "Fecha Autorización",
                        textinputtype: TextInputType.text,
                        obscure: false,
                        icondata: Icons.label,
                        texteditingcontroller: controlleFechaAutorizacion,
                        bsuffixIcon: true,
                        onTapSuffixIcon: () =>
                            _selectDate(context, controlleFechaAutorizacion),
                        suffixIcon: Icons.calendar_month,
                        width: textFormWidth,
                        labelColor: Colors.black54,
                        textColor: Colors.black87,
                        onChange: (value) {},
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: CustomerElevateButton(
                      texto: "Confirmar",
                      colorTexto: Colors.white,
                      colorButton: Colors.blue,
                      onPressed: formAutorized,
                      height: 0.08,
                      width: textFormWidth,
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: CustomerElevateButton(
                      texto: "Cerrar",
                      colorTexto: Colors.white,
                      colorButton: Colors.red,
                      onPressed: () => Navigator.pop(context),
                      height: 0.08,
                      width: textFormWidth,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class HalfScreenForm2 extends StatefulWidget {
  const HalfScreenForm2({super.key});

  @override
  State<HalfScreenForm2> createState() => _HalfScreenForm2State();
}

class _HalfScreenForm2State extends State<HalfScreenForm2> {
  bool addPhoto = false;

  List<File> listaFotos = [];
  String fileName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: getScreenSize(context).width * 0.8,
          height: !addPhoto
              ? getScreenSize(context).height * 0.6
              : getScreenSize(context).height * 0.3,
          padding: EdgeInsets.all(getScreenSize(context).width * 0.02),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 6,
                    color: Colors.white70,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 2)
              ]),
          child: !addPhoto
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: Text(
                        "REGISTRO FOTOGRÁFICO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'MontSerrat',
                            fontWeight: FontWeight.w600,
                            fontSize: getScreenSize(context).width * 0.05),
                      ),
                    ),
                    Container(
                      width: getScreenSize(context).width * 0.9,
                      height: getScreenSize(context).height * 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        scrollDirection: Axis.horizontal,
                        itemCount: listaFotos.length,
                        itemBuilder: (context, index) {
                          return Card();
                        },
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () {
                          setState(() {
                            addPhoto = !addPhoto;
                          });
                        },
                        icon: Icon(Icons.add_a_photo,
                            color: Colors.indigo,
                            size: getScreenSize(context).width * 0.06),
                        label: Text(
                          "Agregar foto",
                          style: TextStyle(
                              fontFamily: 'MontSerrat',
                              fontWeight: FontWeight.w600,
                              fontSize: getScreenSize(context).width * 0.05),
                        )),
                    Container(
                      width: getScreenSize(context).width * 0.8,
                      height: getScreenSize(context).height * 0.08,
                      padding:
                          EdgeInsets.all(getScreenSize(context).width * 0.01),
                      child: CustomerElevateButton(
                          texto: "Guardar",
                          colorTexto: Colors.white,
                          colorButton: Colors.blue,
                          onPressed: () {},
                          height: getScreenSize(context).height * 0.1,
                          width: getScreenSize(context).width * 0.6),
                    ),
                    Container(
                      width: getScreenSize(context).width * 0.8,
                      height: getScreenSize(context).height * 0.08,
                      padding:
                          EdgeInsets.all(getScreenSize(context).width * 0.01),
                      child: CustomerElevateButton(
                          texto: "Cerrar",
                          colorTexto: Colors.white,
                          colorButton: Colors.red,
                          onPressed: () => Navigator.pop(context),
                          height: getScreenSize(context).height * 0.1,
                          width: getScreenSize(context).width * 0.6),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomerDropDownButtonTextPhoto(
                      onChange: (value) {
                        fileName = value ?? "";
                      },
                    ),
                    TextButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CameraPage(fileNameCamera: fileName),
                              )).then((value) {
                            //_loadImages();
                            if (value != null) {
                              print(value[fileName]);
                            }
                          });
                        },
                        icon: const Icon(Icons.camera),
                        label: Text(
                          "Abrir camara",
                          style: TextStyle(
                              fontFamily: 'MontSerrat',
                              fontWeight: FontWeight.w500,
                              fontSize: getScreenSize(context).width * 0.04),
                        )),
                    Container(
                      width: getScreenSize(context).width * 0.8,
                      height: getScreenSize(context).height * 0.08,
                      padding:
                          EdgeInsets.all(getScreenSize(context).width * 0.01),
                      child: CustomerElevateButton(
                          texto: "Cerrar",
                          colorTexto: Colors.white,
                          colorButton: Colors.red,
                          onPressed: () {
                            setState(() {
                              addPhoto = !addPhoto;
                            });
                          },
                          height: getScreenSize(context).height * 0.1,
                          width: getScreenSize(context).width * 0.6),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
