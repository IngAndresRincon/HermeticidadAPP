import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/calendarTextFormField.dart';
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
  late DateTime _selectedDate;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _selectedDate = DateTime.now();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            '${pickedDate.year.toString()}-${pickedDate.month.toString()}-${pickedDate.day.toString()}'; // Puedes formatear la fecha según tus necesidades
      });
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

  Widget _sendButton(double height, String text) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      width: getScreenSize(context).width * 0.9,
      child: CustomerElevateButton(
          texto: text,
          colorTexto: Colors.white,
          colorButton: Colors.green.shade400,
          onPressed: () {
            showDialogLoad(context);
            sendCloseItemTimeLine(
                    requestList[indexProgramacion].idProcesoProgramacion, 1)
                .then((value) {
              Navigator.pop(context);
            });
            showDialogLoad(context);
            getListSchedule().then((value) {
              Navigator.pop(context);
            });
            Navigator.pop(context);
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
            height: getScreenSize(context).height * 0.54,
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
                          controllerPressure),
                      _textFieldForm(
                          0.1,
                          "Responsable de la estación",
                          Icons.chevron_right,
                          TextInputType.text,
                          controllerPressure),
                      _textFieldForm(
                          0.09,
                          "Tipo de prueba",
                          Icons.chevron_right,
                          TextInputType.text,
                          controllerPressure),
                      SizedBox(
                        height: getScreenSize(context).height * 0.12,
                        child: CustomerCalendarTextFormField(
                            width: 0.8,
                            icon: Icons.label,
                            label: "Fecha de realizacion",
                            keyboardType: TextInputType.datetime,
                            obscureText: false,
                            controller: _dateController,
                            isInputFormat: false,
                            isEmail: false,
                            selecDate: () => _selectDate(context)),
                      ),
                      _textFieldForm(0.1, "Hora de inicio", Icons.chevron_right,
                          TextInputType.text, controllerPressure),
                    ],
                  ),
                ),
                SizedBox(height: getScreenSize(context).height * 0.015),
                _sendButton(0.05, "Enviar")
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

  @override
  void initState() {
    _loadImages();
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

  Widget _photoCard(int imageIndex) {
    return SizedBox(
      height: getScreenSize(context).height * 0.2,
      width: getScreenSize(context).width * 0.3,
      child: Card(
        color: Colors.transparent,
        child: Container(
          decoration: imageIndex < _imageFiles.length
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: FileImage(_imageFiles[imageIndex]),
                    fit: BoxFit
                        .cover, // Ajusta la imagen para cubrir toda la caja
                  ),
                )
              : null,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pushNamed(context, 'camera');
                      },
                      icon: const Icon(Icons.camera))),
            ],
          ),
        ),
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
                  height: getScreenSize(context).height * 0.2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _photoCard(0),
                      _photoCard(1),
                      _photoCard(2),
                      _photoCard(3),
                      _photoCard(4)
                    ],
                  ),
                )
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
                _defaultText(
                    0.1, "Calibracion", 20, Colors.black, FontWeight.bold)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
