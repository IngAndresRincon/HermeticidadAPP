import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

class TimeLineOverlayFirstForm extends StatefulWidget {
  const TimeLineOverlayFirstForm({super.key});

  @override
  State<TimeLineOverlayFirstForm> createState() =>
      _TimeLineOverlayFirstFormState();
}

class _TimeLineOverlayFirstFormState extends State<TimeLineOverlayFirstForm> {
  late List<dynamic> dynamicList = [];
  int selectedValue = 0;
  bool internetConection = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getListSchedule() async {
    Map<String, dynamic> mapGetSchedule = {
      'IdUsuario': idUsuarioGlobal,
      'GuidSesion': tokenUsuarioGlobal
    };
    String peticionesUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTobtenerProgramacionPrueba';
    await getScheduleAPI(peticionesUrl, jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      //print(value);
      setState(() {
        dynamicList = value;
        requestList =
            dynamicList.map((item) => Request.fromJson(item)).toList();
      });
    });
  }

  Future<void> sendFirstForm() async {
    Map<String, dynamic> mapFirstForm = {
      'Token': tokenUsuarioGlobal,
      'IdProgramacion': requestList[indexProgramacion].idProgramacion,
      'NombreEstacion': controllerNameStationForm.text,
      'ResponsableEstacion': controllerResponsableForm.text,
      'IdTipoPrueba': selectedValue,
      'Autorizado': true,
      'Fecha': DateTime.now().toString()
    };
    String sendFormUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTformularioAutorizacion';
    try {
      sendForm(sendFormUrl, jsonEncode(mapFirstForm));
    } catch (e) {
      showMessageTOAST(context, "Verifique la conexion a internet", Colors.red);
    }
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

  Widget _textFieldForm(
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

  Widget _rowRadioButtons(double height) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        _defaultText(0.03, "Tipo de prueba", 14, Colors.black, FontWeight.bold),
        RadioListTile(
          title: const Text('Linea'),
          value: 0,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
          },
        ),
        RadioListTile(
          title: const Text('Tanque'),
          value: 1,
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
          },
        ),
      ]),
    );
  }

  Widget _internetVerificartion(double height) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: ListTile(
        leading: IconButton(
          onPressed: () async {
            internetConection = await checkInternetConnection();
            setState(() {});
          },
          icon: const Icon(Icons.refresh),
        ),
        title: _defaultText(0.025, "Verificar Datos Moviles", 13, Colors.black,
            FontWeight.bold),
      ),
    );
  }

  Widget _sendButton(bool enable, double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: enable ? const Color(0xFF27AA69) : Colors.grey,
          onPressed: enable
              ? () {
                  showDialogLoad(context);
                  try {
                    sendFirstForm().then((value) {
                      sendCloseItemTimeLine(
                              requestList[indexProgramacion]
                                  .idProcesoProgramacion,
                              1)
                          .then((value) {
                        getListSchedule().then((value) {
                          Navigator.pop(context);
                        });
                      });
                    });
                    showMessageTOAST(
                        context, "Proceso Completado", Colors.green);
                    Navigator.pop(context);
                  } catch (e) {
                    showMessageTOAST(
                        context, "Complete todos los campos", Colors.red);
                    Navigator.pop(context);
                  }
                }
              : () {},
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
                    0.05, "DATOS INICIALES", 20, Colors.black, FontWeight.bold),
                SizedBox(
                  height: getScreenSize(context).height * 0.35,
                  child: ListView(
                    children: [
                      SizedBox(height: getScreenSize(context).height * 0.01),
                      _textFieldForm(
                          0.1,
                          "Nombre de la estación",
                          Icons.chevron_right,
                          TextInputType.text,
                          controllerNameStationForm),
                      _textFieldForm(
                          0.1,
                          "Responsable de la estación",
                          Icons.chevron_right,
                          TextInputType.text,
                          controllerResponsableForm),
                      _rowRadioButtons(0.17),
                    ],
                  ),
                ),
                _internetVerificartion(0.06),
                _sendButton(internetConection, 0.05, "Enviar Formulario")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeLineOverlayPhoto extends StatefulWidget {
  const TimeLineOverlayPhoto({super.key});

  @override
  State<TimeLineOverlayPhoto> createState() => _TimeLineOverlayPhotoState();
}

class _TimeLineOverlayPhotoState extends State<TimeLineOverlayPhoto> {
  List<File> _imageFiles = [];
  final List<File> _images = [];
  final List<String> keysImg = [];
  late List<dynamic> dynamicList = [];
  bool internetConection = false;

  Future<void> getListSchedule() async {
    Map<String, dynamic> mapGetSchedule = {
      'IdUsuario': idUsuarioGlobal,
      'GuidSesion': tokenUsuarioGlobal
    };
    String peticionesUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTobtenerProgramacionPrueba';
    await getScheduleAPI(peticionesUrl, jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      //print(value);
      setState(() {
        dynamicList = value;
        requestList =
            dynamicList.map((item) => Request.fromJson(item)).toList();
      });
    });
  }

  @override
  void initState() {
    _loadImages();
    nameImages[4] = requestList[indexProgramacion].tipoPrueba;
    internetConection = false;
    super.initState();
  }

  Future<void> _loadImages() async {
    try {
      final directory = await getTemporaryDirectory();
      List<FileSystemEntity> files = directory.listSync();
      List<File> imageFiles = files
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.png'))
          .toList();
      developer.log(
          'Lista de imágenes cargada: ${imageFiles.map((file) => file.path).toList()}');
      setState(() {
        _imageFiles.clear();
        _imageFiles = imageFiles;
      });
    } catch (e) {
      developer.log('Error al cargar las imágenes: $e');
    }
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

  Widget _photoCard(String fName) {
    return Column(
      children: [
        _defaultText(0.03, fName, 14, Colors.black, FontWeight.bold),
        SizedBox(
          height: getScreenSize(context).height * 0.2,
          width: getScreenSize(context).width * 0.3,
          child: Card(
            color: Colors.transparent,
            child: Container(
              decoration: fileList[fName] != null
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: FileImage(fileList[fName]!),
                        fit: BoxFit
                            .cover, // Ajusta la imagen para cubrir toda la caja
                      ),
                    )
                  : null,
              child: Column(
                children: [
                  SizedBox(
                    height: getScreenSize(context).height * 0.19,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: IconButton(
                            color: const Color(0xFF27AA69),
                            onPressed: () {
                              fileName = fName;
                              Navigator.pushNamed(context, 'camera')
                                  .then((value) {
                                //_loadImages();
                                setState(() {});
                              });
                            },
                            icon: const Icon(Icons.camera))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sendButton(bool enable, double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: fileList.length == 5 && enable
              ? const Color(0xFF27AA69)
              : Colors.grey,
          onPressed: fileList.length == 5 && enable
              ? () {
                  _images.clear();
                  showDialogLoad(context);
                  for (int i = 0; i < 5; i++) {
                    _images.add(fileList[nameImages[i]]!);
                  }
                  sendImagesToApi(_images, nameImages).then((value) {
                    sendCloseItemTimeLine(
                            requestList[indexProgramacion]
                                .idProcesoProgramacion,
                            2)
                        .then((value) {
                      getListSchedule().then((value) {
                        Navigator.pop(context);
                      });
                    });
                  });
                  showMessageTOAST(context, "Proceso Completado", Colors.green);
                  Navigator.pop(context);
                }
              : () {},
          height: .05,
          width: .5),
    );
  }

  Widget _internetVerificartion(double height) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: ListTile(
        leading: IconButton(
          onPressed: () async {
            internetConection = await checkInternetConnection();
            setState(() {});
          },
          icon: const Icon(Icons.refresh),
        ),
        title: _defaultText(0.025, "Verificar Datos Moviles", 13, Colors.black,
            FontWeight.bold),
      ),
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
            height: getScreenSize(context).height * 0.54,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(0.1, "Evidencias Fotograficas", 20, Colors.black,
                    FontWeight.bold),
                SizedBox(
                  width: getScreenSize(context).width * 0.8,
                  height: getScreenSize(context).height * 0.25,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _photoCard(nameImages[0]),
                      _photoCard(nameImages[1]),
                      _photoCard(nameImages[2]),
                      _photoCard(nameImages[3]),
                      _photoCard(nameImages[4])
                    ],
                  ),
                ),
                _internetVerificartion(0.06),
                _sendButton(internetConection, 0.05, "Enviar")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeLineOverlayCalib extends StatefulWidget {
  const TimeLineOverlayCalib({super.key});

  @override
  State<TimeLineOverlayCalib> createState() => _TimeLineOverlayCalibState();
}

class _TimeLineOverlayCalibState extends State<TimeLineOverlayCalib> {
  late List<dynamic> dynamicList = [];
  bool internetConection = false;

  Future<void> getListSchedule() async {
    Map<String, dynamic> mapGetSchedule = {
      'IdUsuario': idUsuarioGlobal,
      'GuidSesion': tokenUsuarioGlobal
    };
    String peticionesUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTobtenerProgramacionPrueba';
    await getScheduleAPI(peticionesUrl, jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      //print(value);
      setState(() {
        dynamicList = value;
        requestList =
            dynamicList.map((item) => Request.fromJson(item)).toList();
      });
    });
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

  Widget _textFieldForm(
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

  Widget _sendButton(double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: const Color(0xFF27AA69),
          onPressed: () {
            try {
              pressureCalib = int.parse(controllerPressure.text);
              enableCalib = true;
              calibEvent = true;
              Navigator.pushNamed(context, 'test').then((value) {
                setState(() {});
              });
            } catch (e) {
              showMessageTOAST(
                  context, "El campo de presión está vacio", Colors.red);
            }
          },
          height: .05,
          width: .5),
    );
  }

  Widget _internetVerificartion(bool enable, double height) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: ListTile(
        leading: IconButton(
          onPressed: enable
              ? () async {
                  internetConection = await checkInternetConnection();
                  setState(() {});
                }
              : () {},
          icon: const Icon(Icons.refresh),
        ),
        title: _defaultText(0.025, "Verificar Datos Moviles", 13, Colors.black,
            FontWeight.bold),
      ),
    );
  }

  Widget _sendApiButton(bool enable, double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton:
              completeTest && enable ? const Color(0xFF27AA69) : Colors.grey,
          onPressed: completeTest && enable
              ? () {
                  int response = 0;
                  if (calibEvent) {
                    response = 3;
                  } else {
                    response = 4;
                  }
                  showDialogLoad(context);
                  sendCloseItemTimeLine(
                          requestList[indexProgramacion].idProcesoProgramacion,
                          response)
                      .then((value) {
                    calibEvent = false;
                    getListSchedule().then((value) {
                      showMessageTOAST(
                          context, "Proceso Completado", Colors.green);
                      Navigator.pop(context);
                    });
                  });
                  completeTest = false;
                  Navigator.pop(context);
                }
              : () {},
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
            height: getScreenSize(context).height * 0.45,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(
                    0.1, "Calibración", 20, Colors.black, FontWeight.bold),
                _textFieldForm(
                    0.1,
                    "Presión de Calibración (PSI)",
                    Icons.chevron_right,
                    TextInputType.number,
                    controllerPressure),
                _sendButton(0.05, "Ir a Calibracion"),
                _internetVerificartion(completeTest, 0.06),
                _sendApiButton(internetConection, 0.05, "Enviar Confirmación")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeLineOverlayTest extends StatefulWidget {
  const TimeLineOverlayTest({super.key});

  @override
  State<TimeLineOverlayTest> createState() => _TimeLineOverlayTestState();
}

class _TimeLineOverlayTestState extends State<TimeLineOverlayTest> {
  late List<dynamic> dynamicList = [];
  bool internetConection = false;

  Future<void> getListSchedule() async {
    Map<String, dynamic> mapGetSchedule = {
      'IdUsuario': idUsuarioGlobal,
      'GuidSesion': tokenUsuarioGlobal
    };
    String peticionesUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTobtenerProgramacionPrueba';
    await getScheduleAPI(peticionesUrl, jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      //print(value);
      setState(() {
        dynamicList = value;
        requestList =
            dynamicList.map((item) => Request.fromJson(item)).toList();
      });
    });
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

  Widget _sendButton(double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: const Color(0xFF27AA69),
          onPressed: () {
            calibEvent = false;
            Navigator.pushNamed(context, 'test').then((value) {
              setState(() {});
            });
          },
          height: .05,
          width: .5),
    );
  }

  Widget _internetVerificartion(bool enable, double height) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: ListTile(
        leading: IconButton(
          onPressed: enable
              ? () async {
                  internetConection = await checkInternetConnection();
                  setState(() {});
                }
              : () {},
          icon: const Icon(Icons.refresh),
        ),
        title: _defaultText(0.025, "Verificar Datos Moviles", 13, Colors.black,
            FontWeight.bold),
      ),
    );
  }

  Widget _sendApiButton(bool enable, double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton:
              completeTest && enable ? const Color(0xFF27AA69) : Colors.grey,
          onPressed: completeTest && enable
              ? () {
                  int response = 0;
                  if (calibEvent) {
                    response = 3;
                  } else {
                    response = 4;
                  }
                  showDialogLoad(context);
                  sendCloseItemTimeLine(
                          requestList[indexProgramacion].idProcesoProgramacion,
                          response)
                      .then((value) {
                    calibEvent = false;
                    getListSchedule().then((value) {
                      showMessageTOAST(
                          context, "Proceso Completado", Colors.green);
                      Navigator.pop(context);
                    });
                  });
                  completeTest = false;
                  Navigator.pop(context);
                }
              : () {},
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
            height: getScreenSize(context).height * 0.32,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(0.08, "Prueaba de Hermeticidad", 20, Colors.black,
                    FontWeight.bold),
                _sendButton(0.05, "Ir a la prueba"),
                _internetVerificartion(completeTest, 0.06),
                _sendApiButton(internetConection, 0.05, "Enviar Confirmación")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeLineOverlayResults extends StatefulWidget {
  const TimeLineOverlayResults({super.key});

  @override
  State<TimeLineOverlayResults> createState() => _TimeLineOverlayResultsState();
}

class _TimeLineOverlayResultsState extends State<TimeLineOverlayResults> {
  late List<dynamic> dynamicList = [];

  Future<void> getListSchedule() async {
    Map<String, dynamic> mapGetSchedule = {
      'IdUsuario': idUsuarioGlobal,
      'GuidSesion': tokenUsuarioGlobal
    };
    String peticionesUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTobtenerProgramacionPrueba';
    await getScheduleAPI(peticionesUrl, jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      //print(value);
      setState(() {
        dynamicList = value;
        requestList =
            dynamicList.map((item) => Request.fromJson(item)).toList();
      });
    });
  }

  Widget _closeBar(double heightContent, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * heightContent,
      child: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(icon))),
    );
  }

  Widget _defaultText(String text, double fontSize, Color color,
      double letterSpacing, FontWeight fontWeight) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          letterSpacing: letterSpacing,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight),
    );
  }

  Widget _scrollData(double heightContent, String fileData) {
    return SizedBox(
      height: getScreenSize(context).height * heightContent,
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
                      _defaultText(
                          fileData, 16, Colors.black, 4, FontWeight.w500)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sendButton(double heightContent, String text) {
    return SizedBox(
      height: getScreenSize(context).height * heightContent,
      child: CustomerElevateButton(
          onPressed: () {
            developer.log(fileData);
            Navigator.pushNamed(context, 'file').then((value) {
              showDialogLoad(context);
              getListSchedule().then((value) {
                Navigator.pop(context);
              });
              Navigator.pop(context);
            });
          },
          texto: text,
          colorTexto: Colors.white,
          colorButton: const Color(0xFF27AA69),
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
            height: getScreenSize(context).height * 0.63,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(
                    "Resultados", 20, Colors.black, 2, FontWeight.bold),
                _scrollData(0.4, fileData),
                SizedBox(height: getScreenSize(context).height * 0.04),
                _sendButton(0.05, "Ver Grafica"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeLineOverlayLastForm extends StatefulWidget {
  const TimeLineOverlayLastForm({super.key});

  @override
  State<TimeLineOverlayLastForm> createState() =>
      _TimeLineOverlayLastFormState();
}

class _TimeLineOverlayLastFormState extends State<TimeLineOverlayLastForm> {
  late List<dynamic> dynamicList = [];
  int selectedValue = 0;
  bool internetConection = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getListSchedule() async {
    Map<String, dynamic> mapGetSchedule = {
      'IdUsuario': idUsuarioGlobal,
      'GuidSesion': tokenUsuarioGlobal
    };
    String peticionesUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTobtenerProgramacionPrueba';
    await getScheduleAPI(peticionesUrl, jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      //print(value);
      setState(() {
        dynamicList = value;
        requestList =
            dynamicList.map((item) => Request.fromJson(item)).toList();
      });
    });
  }

  Future<void> sendLastForm() async {
    Map<String, dynamic> mapLastForm = {
      'Token': tokenUsuarioGlobal,
      'IdProgramacion': requestList[indexProgramacion].idProgramacion,
      'FechaFin': DateTime.now().toString()
    };
    String sendFormUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTformularioAutorizacion';
    sendForm(sendFormUrl, jsonEncode(mapLastForm));
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

  Widget _internetVerificartion(double height) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: ListTile(
        leading: IconButton(
          onPressed: () async {
            internetConection = await checkInternetConnection();
            setState(() {});
          },
          icon: const Icon(Icons.refresh),
        ),
        title: _defaultText(0.025, "Verificar Datos Moviles", 13, Colors.black,
            FontWeight.bold),
      ),
    );
  }

  Widget _sendButton(bool enable, double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: enable ? const Color(0xFF27AA69) : Colors.grey,
          onPressed: enable
              ? () {
                  showDialogLoad(context);
                  sendLastForm().then((value) {
                    sendCloseItemTimeLine(
                            requestList[indexProgramacion]
                                .idProcesoProgramacion,
                            6)
                        .then((value) {
                      getListSchedule().then((value) {
                        Navigator.pop(context);
                      });
                    });
                  });
                  showMessageTOAST(
                      context, "Proceso Completado", const Color(0xFF27AA69));
                  Navigator.pop(context);
                }
              : () {},
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
            height: getScreenSize(context).height * 0.35,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(
                    0.05, "DATOS FINALES", 20, Colors.black, FontWeight.bold),
                SizedBox(
                  height: getScreenSize(context).height * 0.1,
                  child: ListView(
                    children: [
                      SizedBox(height: getScreenSize(context).height * 0.01),
                    ],
                  ),
                ),
                _internetVerificartion(0.06),
                _sendButton(internetConection, 0.05, "Enviar")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
