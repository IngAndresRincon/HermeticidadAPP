import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Page/camera_page.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/esp32.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/DropDownButton.dart';
import 'package:hermeticidadapp/Widgets/cartesian_chart.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

TextEditingController controlleNombreEstacion = TextEditingController();
TextEditingController controlleResponsableEstacion = TextEditingController();
TextEditingController controlleFechaAutorizacion = TextEditingController();
TextEditingController controllerPresionCalibracion = TextEditingController();

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
  final int idProgramacion;
  const HalfScreenForm2({super.key, required this.idProgramacion});

  @override
  State<HalfScreenForm2> createState() => _HalfScreenForm2State();
}

class _HalfScreenForm2State extends State<HalfScreenForm2> {
  bool addPhoto = false;
  bool isLoading = false;
  int acumuladorResultado = 0;
  List<Map<String, dynamic>> listaFotos = [];
  String fileName = '';

  Future<void> guardarImagen() async {
    acumuladorResultado = 0;
    for (var e in listaFotos) {
      String imageDataString = await convertImageToBase64(e["archivo"]);
      imageDataString = 'data:image/png;base64,$imageDataString';

      await sendImages({
        'IdSolicitud': widget.idProgramacion,
        'Nombre': e["nombre"],
        'Imagen': imageDataString
      }).then((value) {
        if (value) acumuladorResultado++;
      });
    }
  }

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
            child: !addPhoto && !isLoading
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
                        height: getScreenSize(context).height * 0.3,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          itemCount: listaFotos.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                      width:
                                          getScreenSize(context).width * 0.28,
                                      height:
                                          getScreenSize(context).height * 0.2,
                                      image: FileImage(
                                          listaFotos[index]['archivo'])),
                                  Text(
                                    listaFotos[index]['nombre'],
                                    style: TextStyle(
                                        fontFamily: 'MontSerrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: getScreenSize(context).width *
                                            0.03),
                                  )
                                ],
                              ),
                            );
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
                                fontSize: getScreenSize(context).width * 0.04),
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
                            onPressed: () async {
                              if (listaFotos.length < 5) {
                                showMessageTOAST(
                                    context,
                                    "Debe agregar mínimo 5 imagenes",
                                    Colors.black54);
                                return;
                              }

                              setState(() {
                                isLoading = !isLoading;
                              });

                              await guardarImagen().then((value) {
                                if (acumuladorResultado == listaFotos.length) {
                                  showMessageTOAST(context,
                                      "Imagenes insertadas", Colors.black54);

                                  for (var element in listaProgramacion) {
                                    if (element["IdProgramacion"] ==
                                        widget.idProgramacion) {
                                      element["RegistroFoto"] = true;
                                    }
                                  }

                                  Navigator.pop(context, true);
                                } else {
                                  showMessageTOAST(
                                      context,
                                      "Error al subir imagenes",
                                      Colors.black54);
                                }
                              });
                            },
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
                : addPhoto && !isLoading
                    ? Column(
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
                                    listaFotos.add({
                                      'nombre': fileName,
                                      'archivo': value[fileName]
                                    });
                                  }
                                });
                              },
                              icon: const Icon(Icons.camera),
                              label: Text(
                                "Abrir camara",
                                style: TextStyle(
                                    fontFamily: 'MontSerrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        getScreenSize(context).width * 0.04),
                              )),
                          Container(
                            width: getScreenSize(context).width * 0.8,
                            height: getScreenSize(context).height * 0.08,
                            padding: EdgeInsets.all(
                                getScreenSize(context).width * 0.01),
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
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                        color: Colors.blue,
                      ))),
      ),
    );
  }
}

class HalfScreenForm3 extends StatefulWidget {
  final int idProgramacion;
  const HalfScreenForm3({super.key, required this.idProgramacion});

  @override
  State<HalfScreenForm3> createState() => _HalfScreenForm3State();
}

class _HalfScreenForm3State extends State<HalfScreenForm3> {
  final MethodChannel _channel =
      const MethodChannel('com.example.hermeticidadapp');

  bool isSinc = false;
  late Timer pingTimer = Timer(const Duration(seconds: 1), () {});
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    super.initState();
  }

  void timer() {
    pingTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      Map<String, dynamic> mapResponse = await getEsp32();
      try {
        estado = mapResponse["estado"];
        //mac = mapResponse["mac"];
        presion = mapResponse["presion"];
        tiempo = mapResponse["tiempo"];
        chartData
            .add(ChartData(dateTimeConvert(tiempo), double.parse(presion)));
        _chartSeriesController.updateDataSource(
            addedDataIndex: chartData.length - 1);
      } catch (e) {
        isSinc = false;
        pingTimer.cancel();
        developer.log("Error en Timer: $e");
      }
      setState(() {});
    });
  }

  Future<void> openDeviceSettings(String type) async {
    try {
      await _channel.invokeMethod('open${type}Settings');
    } on PlatformException catch (e) {
      developer.log('Error al abrir la configuración de Wi-Fi: ${e.message}');
    }
  }

  void commandCalibration(String command) async {
    Map<String, dynamic> mapData = {
      'command': command,
      'data': {
        'calibValue': calibValue,
      }
    };
    showDialogLoad(context);
    await postEsp32(jsonEncode(mapData)).then((value) {
      Navigator.pop(context);
      if (command == 'initCalib' && value) {
        timer();
        developer.log('Timer Activado');
        isSinc = true;
      } else if (command == 'finCalib' && value) {
        if (mounted) {
          pingTimer.cancel();
        }
        developer.log('Timer Desactivado');
        isSinc = false;
      } else {
        showMessageTOAST(context, "Sin Conexion a Tarjeta", Colors.red);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: getScreenSize(context).width * 0.9,
          height: getScreenSize(context).height * 0.9,
          padding: EdgeInsets.symmetric(
              vertical: getScreenSize(context).height * 0.01),
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
                  flex: 3,
                  child: Column(
                    children: [
                      SizedBox(
                        width: getScreenSize(context).width * 0.7,
                        child: Center(
                          child: Text(
                            "Calibración de presión de prueba",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'MontSerrat',
                                fontSize: getScreenSize(context).width * 0.06,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getScreenSize(context).width * 0.7,
                        child: Center(
                          child: Text(
                            'Estado: $estado',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'MontSerrat',
                                fontSize: getScreenSize(context).width * 0.04,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getScreenSize(context).width * 0.7,
                        child: Center(
                          child: Text(
                            'Presión: $presion PSI \n Tiempo: $tiempo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'MontSerrat',
                                fontSize: getScreenSize(context).width * 0.04,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  )),
              !isSinc
                  ? Expanded(
                      flex: 5,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: stepsIcons.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Card(
                                elevation: 10,
                                color: Colors.indigo.shade200,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      stepsIcons[index]['icono'],
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: Text(
                                    stepsIcons[index]['paso'],
                                    style: TextStyle(
                                        fontFamily: 'MontSerrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: getScreenSize(context).width *
                                            0.03),
                                  ),
                                ),
                              ),
                            );
                          }))
                  : Expanded(
                      flex: 5,
                      child: CustomerCartesianChart(
                        chartData: chartData,
                        mediumValue: calibValue,
                        onRendered: (ChartSeriesController controller) {
                          _chartSeriesController = controller;
                        },
                        tolerance: 5,
                      ),
                    ),
              Expanded(
                flex: 1,
                child: CustomerTextFormField(
                  label: "Presion de calibración (PSI)",
                  textinputtype: TextInputType.number,
                  obscure: false,
                  icondata: Icons.label,
                  texteditingcontroller: controllerPresionCalibracion,
                  bsuffixIcon: false,
                  onTapSuffixIcon: () {},
                  suffixIcon: Icons.label,
                  width: 0.7,
                  labelColor: Colors.black54,
                  textColor: Colors.black87,
                  onChange: (value) {
                    try {
                      calibValue =
                          double.parse(controllerPresionCalibracion.text);
                      setState(() {});
                    } catch (e) {
                      developer.log("valor de Calibración incorrecto");
                    }
                  },
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: CustomerElevateButton(
                          texto: !isSinc ? "Sincronizar" : "Terminar",
                          colorTexto: Colors.white,
                          colorButton: !isSinc ? Colors.green : Colors.red,
                          onPressed: !isSinc
                              ? () => commandCalibration('initCalib')
                              : () => commandCalibration('finCalib'),
                          height: 0.07,
                          width: 0.7,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: CustomerElevateButton(
                          texto: "Cerrar",
                          colorTexto: Colors.white,
                          colorButton: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                            if (mounted) {
                              pingTimer.cancel();
                            }
                          },
                          height: 0.07,
                          width: 0.7,
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class HalfScreenForm4 extends StatefulWidget {
  final int idProgramacion;
  final int idEstacion;
  const HalfScreenForm4(
      {super.key, required this.idEstacion, required this.idProgramacion});

  @override
  State<HalfScreenForm4> createState() => _HalfScreenForm4State();
}

class _HalfScreenForm4State extends State<HalfScreenForm4> {
  bool isSinc = false;
  late Timer pingTimer = Timer(const Duration(seconds: 1), () {});
  late ChartSeriesController _chartSeriesController;

  void timer() {
    pingTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      Map<String, dynamic> mapResponse = await getEsp32();
      try {
        estado = mapResponse["estado"];
        //mac = mapResponse["mac"];
        presion = mapResponse["presion"];
        tiempo = mapResponse["tiempo"];
        chartData
            .add(ChartData(dateTimeConvert(tiempo), double.parse(presion)));
        _chartSeriesController.updateDataSource(
            addedDataIndex: chartData.length - 1);
      } catch (e) {
        isSinc = false;
        pingTimer.cancel();
        developer.log("Error en Timer: $e");
      }
      setState(() {});
    });
  }

  void commandTesting(String command) async {
    Map<String, dynamic> mapData = {
      'command': command,
      'data': {
        'idEstacion': widget.idEstacion,
        'idProgramacion': widget.idProgramacion
      }
    };
    showDialogLoad(context);
    await postEsp32(jsonEncode(mapData)).then((value) {
      Navigator.pop(context);
      if (command == 'initTest' && value) {
        timer();
        developer.log('Timer Activado');
        isSinc = true;
      } else if (command == 'finTest') {
        if (mounted) {
          pingTimer.cancel();
        }
        developer.log('Timer Desactivado');
        isSinc = false;
      } else {
        showMessageTOAST(context, "Sin Conexion a Tarjeta", Colors.red);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: getScreenSize(context).width * 0.9,
            height: getScreenSize(context).height * 0.8,
            padding: EdgeInsets.symmetric(
                vertical: getScreenSize(context).height * 0.01),
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
                    flex: 3,
                    child: Column(
                      children: [
                        SizedBox(
                          width: getScreenSize(context).width * 0.7,
                          child: Center(
                            child: Text(
                              "Prueba de Hermeticidad",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'MontSerrat',
                                  fontSize: getScreenSize(context).width * 0.06,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getScreenSize(context).width * 0.7,
                          child: Center(
                            child: Text(
                              'Estado: $estado',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'MontSerrat',
                                  fontSize: getScreenSize(context).width * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getScreenSize(context).width * 0.7,
                          child: Center(
                            child: Text(
                              'Presión: $presion PSI \n Tiempo: $tiempo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'MontSerrat',
                                  fontSize: getScreenSize(context).width * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    )),
                !isSinc
                    ? Expanded(
                        flex: 5,
                        child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: stepsIcons.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Card(
                                  elevation: 10,
                                  color: Colors.indigo.shade200,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        stepsIcons[index]['icono'],
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    title: Text(
                                      stepsIcons[index]['paso'],
                                      style: TextStyle(
                                          fontFamily: 'MontSerrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getScreenSize(context).width *
                                                  0.03),
                                    ),
                                  ),
                                ),
                              );
                            }))
                    : Expanded(
                        flex: 5,
                        child: CustomerCartesianChart(
                          chartData: chartData,
                          mediumValue: calibValue,
                          onRendered: (ChartSeriesController controller) {
                            _chartSeriesController = controller;
                          },
                          tolerance: 5,
                        ),
                      ),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: CustomerElevateButton(
                            texto: !isSinc ? "Sincronizar" : "Terminar",
                            colorTexto: Colors.white,
                            colorButton: !isSinc ? Colors.green : Colors.red,
                            onPressed: !isSinc
                                ? () => commandTesting('initTest')
                                : () => commandTesting('finTest'),
                            height: 0.07,
                            width: 0.7,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: CustomerElevateButton(
                            texto: "Cerrar",
                            colorTexto: Colors.white,
                            colorButton: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                              if (mounted) {
                                pingTimer.cancel();
                              }
                            },
                            height: 0.07,
                            width: 0.7,
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}

class HalfScreenForm5 extends StatefulWidget {
  final int idProgramacion;

  const HalfScreenForm5({super.key, required this.idProgramacion});

  @override
  State<HalfScreenForm5> createState() => _HalfScreenForm5State();
}

class _HalfScreenForm5State extends State<HalfScreenForm5> {
  bool isSinc = false;
  String sdData = '';

  Future<void> sendFileApi() async {
    showDialogLoad(context);
    String fileContFormat = sdData
        .replaceAll("Registro de mediciones\n", "")
        .replaceAll("------Calibracion-----\n", "")
        .replaceAll("--------Testeo--------\n", "")
        .replaceAll(" ", "")
        .replaceAll("][", ",")
        .replaceAll("]\n", ";")
        .replaceAll("[", "");
    developer.log("[sendFileApi] $fileContFormat");
    String fileUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTsubirArchivo';
    postFile(fileUrl, fileContFormat).then((value) {
      if (value) {
        showMessageTOAST(context, "Archivo enviado", Colors.green);
      } else {
        showMessageTOAST(context,
            "Error, Conectese a la red movil e intente de nuevo", Colors.red);
      }
      Navigator.pop(context);
    });
  }

  void commandResults(String command) async {
    if (command == 'readSD') {
      showDialogLoad(context);
      await getSDesp32().then((value) {
        Navigator.pop(context);
        sdData = value;
      });
      isSinc = true;
      setState(() {});
    } else if (command == 'sendData') {
      sendFileApi();
      developer.log('Datos Enviados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: getScreenSize(context).width * 0.9,
          height: getScreenSize(context).height * 0.8,
          padding: EdgeInsets.symmetric(
              vertical: getScreenSize(context).height * 0.01),
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
                  flex: 1,
                  child: Column(
                    children: [
                      SizedBox(
                        width: getScreenSize(context).width * 0.7,
                        child: Center(
                          child: Text(
                            "Resultados",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'MontSerrat',
                                fontSize: getScreenSize(context).width * 0.06,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                flex: 5,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  sdData,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'MontSerrat',
                                      fontSize:
                                          getScreenSize(context).width * 0.06,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: CustomerElevateButton(
                          texto: !isSinc ? "Sincronizar" : "Guardar",
                          colorTexto: Colors.white,
                          colorButton: !isSinc ? Colors.green : Colors.blue,
                          onPressed: !isSinc
                              ? () => commandResults('readSD')
                              : () => commandResults('sendData'),
                          height: 0.07,
                          width: 0.7,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: CustomerElevateButton(
                          texto: "Cerrar",
                          colorTexto: Colors.white,
                          colorButton: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          height: 0.07,
                          width: 0.7,
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
