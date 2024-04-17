import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Page/camera_page.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/DropDownButton.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  const HalfScreenForm3({super.key});

  @override
  State<HalfScreenForm3> createState() => _HalfScreenForm3State();
}

class _HalfScreenForm3State extends State<HalfScreenForm3> {
  final MethodChannel _channel =
      const MethodChannel('com.example.hermeticidadapp');

  List<Map<String, dynamic>> stepsIcons = [
    {
      'paso': "Verifique la correcta conexion del medidor.",
      'icono': Icons.cable
    },
    {
      'paso': "Desconecte su celular de los datos moviles.",
      'icono': Icons.signal_cellular_off_sharp
    },
    {'paso': "Conectese a la red WIFI 'Medidor_PSI'.", 'icono': Icons.wifi},
    {
      'paso': "Oprima el boton 'Sincronizar'.",
      'icono': Icons.radio_button_checked
    }
  ];
  bool isSinc = false;
  late ChartSeriesController _chartSeriesController;

  Future<void> openDeviceSettings(String type) async {
    try {
      await _channel.invokeMethod('open${type}Settings');
    } on PlatformException catch (e) {
      print('Error al abrir la configuración de Wi-Fi: ${e.message}');
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
                  flex: 2,
                  child: SizedBox(
                    width: getScreenSize(context).width * 0.7,
                    child: Center(
                      child: Text(
                        "Calibración del kit medidor",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'MontSerrat',
                            fontSize: getScreenSize(context).width * 0.06,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
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
                      child: SfCartesianChart(
                        margin: const EdgeInsets.all(0),
                        legend: Legend(
                          iconBorderWidth: 2,
                          offset: const Offset(20, -80),
                          isVisible: true,
                          position: LegendPosition.bottom,
                          //alignment: ChartAlignment.center
                        ),
                        primaryXAxis: DateTimeAxis(
                            axisLine:
                                const AxisLine(width: 2, color: Colors.black45),
                            title: AxisTitle(text: "Segundos(s)"),
                            autoScrollingMode: AutoScrollingMode.end,
                            autoScrollingDelta: 30,
                            //edgeLabelPlacement: EdgeLabelPlacement.shift,
                            intervalType: DateTimeIntervalType.seconds,
                            interval: 5),
                        primaryYAxis: NumericAxis(
                            axisLine:
                                const AxisLine(width: 2, color: Colors.black45),
                            //title: AxisTitle(text: 'PSI'),
                            maximum: pressureCalib * 2,
                            minimum: 0,
                            //labelFormat: '{value}PSI',
                            plotBands: <PlotBand>[
                              PlotBand(
                                isVisible: true,
                                start:
                                    pressureCalib * (1 - 0.01 * timeAperture),
                                end: pressureCalib * (1 + 0.01 * timeAperture),
                                opacity: 0.5,
                                color: Colors.blueGrey.shade100,
                                borderWidth: 1,
                                dashArray: const <double>[5, 5],
                                text: '±$timeAperture%',
                                horizontalTextAlignment: TextAnchor.end,
                                verticalTextAlignment: TextAnchor.end,
                                textStyle: const TextStyle(color: Colors.black),
                              ),
                              PlotBand(
                                isVisible: true,
                                start: pressureCalib,
                                end: pressureCalib,
                                opacity: 0.5,
                                borderColor: Colors.cyan,
                                borderWidth: 1,
                                dashArray: const <double>[8, 8],
                              )
                            ]),
                        series: <ChartSeries>[
                          SplineSeries<ChartData, DateTime>(
                            onRendererCreated:
                                (ChartSeriesController controller) {
                              _chartSeriesController = controller;
                            },
                            legendItemText: "Presión[PSI]",
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.timeP,
                            yValueMapper: (ChartData data, _) => data.value,
                            color: Colors.greenAccent.shade400,
                            width: 2,
                            opacity: 1,
                            splineType: SplineType.monotonic,
                          ),
                        ],
                      ),
                    ),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomerTextFormField(
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
                          // if (int.parse(value) >= 100) return;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: CustomerElevateButton(
                          texto: "Sincronizar",
                          colorTexto: Colors.white,
                          colorButton: Colors.green,
                          onPressed: () {
                            isSinc = true;
                            setState(() {});
                          },
                          height: 0.08,
                          width: 0.7,
                        ),
                      )
                    ],
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
                      width: 0.7,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
