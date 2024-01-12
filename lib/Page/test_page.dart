import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Widgets/elevate_button.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:hermeticidadapp/Tools/functions.dart';

import 'package:web_socket_channel/io.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:convert';
//import 'dart:io';
import 'dart:async';

class TestPage extends StatefulWidget {
  final StorageFile storage = StorageFile();
  TestPage({super.key});
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final serverUrl = 'ws://192.168.11.100/ws';
  final testUrl = 'http://192.168.11.100/verificar_conexion';
  final fileUrl = 'http://192.168.11.100:81/SD';
  late WebSocketChannel channel;
  String receivedText = 'Datos Recibidos...';
  String timeText = '';
  String macESP32 = 'Sin Conexion...';
  String state = 'Detenido';
  String conectMns = '';
  bool isInTestState = false;
  bool isInCalibState = false;
  bool isInCalibStateAux = false;
  bool isInSocket = false;
  bool flagButton = false;
  bool checkboxValue = false;
  bool isDisposeCalled = false;
  bool pong = false;
  bool readyForFile = false;
  bool isTest = false;
  bool isHorizontal = false;
  late Timer pingTimer;
  double contador = 0.0;
  late ChartSeriesController _chartSeriesController;
  List<File> _imageFiles = [];

  String paso0 = "Pasos para realizar la prueba:\n";
  String paso1 = "Verifique la correcta conexion del medidor.";
  String paso2 = "Desconecte su celular de los datos moviles.";
  String paso3 =
      "Conecte su dispositivo movil a la red wifi que genera el medidor llamada 'Medidor_PSI' y contraseña 'insepetAd'.";
  String paso4 =
      "Si se conectó a la red correcta el boton 'Sincronizar' se habilitará, oprimalo para conectarse con el medidor y comenzar la prueba.";
  @override
  void dispose() {
    if (mounted) {
      pingTimer.cancel();
    }
    super.dispose();
    if (flagButton) {
      channel.sink
          .close(); // Cierra el canal WebSocket cuando el widget se elimina
    }
    isDisposeCalled = true;
    enableCalib = false;
  }

  @override
  void initState() {
    super.initState();
    // Configura un temporizador para enviar pings periódicamente
    // widget.storage
    //     .writeFileData('Conexion con el medidor ${DateTime.now().toLocal()}\n');
    //enableCalib ? initCalib(true) : () {};
    _loadImages();
    ping2();
  }

  void ping2() {
    pingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!isDisposeCalled) {
        ping();
      }
    });
  }

  Future<void> sincronizeFile() async {
    widget.storage.writeFileData("Inicio de llenado\n");
    final response = await http.get(Uri.parse(fileUrl));
    widget.storage.writeFileData(response.body);
  }

  Future<void> showDataFile() async {
    fileContentData = await widget.storage.readFileData();
    final fileDataArray = fileContentData
        .replaceAll("Registro de mediciones\n", "")
        .replaceAll("------Calibracion-----\n", "")
        .replaceAll("--------Testeo--------\n", "")
        .replaceAll("[", "")
        .replaceAll("]\n", ";")
        .replaceAll("]", ";")
        .split(";");
    chartDataStatic.clear();
    for (int i = 2; i < fileDataArray.length - 1; i += 4) {
      chartDataStatic.add(ChartData(dateTimeConvert(fileDataArray[i]),
          double.parse(fileDataArray[i + 1])));
    }
    developer.log(fileDataArray.toString());
    setState(() {});
  }

  Future<void> saveFileData() async {
    showDialogLoad(context);
    await sincronizeFile();
    await showDataFile().then((value) {
      Navigator.pop(context);
    });
  }

  DateTime dateTimeConvert(String time) {
    DateTime timeConvert;
    final timeArray = time
        .replaceAll("]", "")
        .replaceAll("[", "")
        .replaceAll(" ", "")
        .split(":");
    if (timeArray.length == 3) {
      timeConvert = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(timeArray[0]),
          int.parse(timeArray[1]),
          int.parse(timeArray[2]));
    } else if (timeArray.length == 4) {
      timeConvert = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(timeArray[0]),
          int.parse(timeArray[1]),
          int.parse(timeArray[2]),
          int.parse(timeArray[3]));
    } else {
      timeConvert = DateTime(2023);
    }
    return timeConvert;
  }

  Future<void> onDataReceived(dynamic data) async {
    setState(() {
      Map<String, dynamic> userMap = jsonDecode(data);
      var user = UserSocket.fromJson(userMap);
      macESP32 = 'Conectado: ${user.mac}';
      receivedText = 'Presion(PSI): ${user.presion}';
      //timeText = user.nDatos;
      state = user.state;
      try {
        final double parsedData;
        if (user.presion != "Proceso Detenido") {
          parsedData = double.parse(user.presion);
          final String timeP = user.nDatos;
          DateTime dateTimeP = dateTimeConvert(timeP);
          timeText = dateTimeP.toString();
          chartData.add(ChartData(dateTimeP, parsedData));
          _chartSeriesController.updateDataSource(
              addedDataIndex: chartData.length - 1);
          String datosArchivo =
              '${user.nDatos}[${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}][$parsedData]';
          widget.storage.appendTextToFile(datosArchivo);
        }
      } catch (e) {
        developer.log('Error al analizar los datos: $e');
      }
    });
  }

  Future<bool> isWebSocketAvailable(String serverUrl) async {
    try {
      final response = await http.get(Uri.parse(serverUrl));
      if (response.statusCode == 200) {
        return true; // El servidor WebSocket está disponible.
      } else {
        return false; // El servidor WebSocket no está disponible.
      }
    } catch (e) {
      return false; // Error al intentar conectar, el servidor no está disponible.
    }
  }

  Future<void> ping() async {
    if (await isWebSocketAvailable(testUrl)) {
      pong = true;
    } else {
      pong = false;
    }
    if (mounted) {
      setState(() {
        if (pong) {
          //conectMns = macESP32;
          //showMessageTOAST(context, "Conexion Exitosa con medidor", Colors.green);
          checkboxValue = true;
          if (state == "En prueba") {
            isInTestState = true;
          } else if (state == "En calibracion") {
            isInCalibState = true;
          } else if (state == "Detenido") {
            isInTestState = false;
            isInCalibState = false;
          }
          if (isInCalibStateAux == true && isInCalibState == false) {
            saveFileData();
            showMessageTOAST(
                context, "Calibracion Terminada", Colors.red.shade700);
          }
          isInCalibStateAux = isInCalibState;
        } else {
          isInSocket = false;
          checkboxValue = false;
          macESP32 = "Sin Conexion...";
          //showMessageTOAST(context, "Conexion fallida con el medidor", Colors.redAccent);
        }
      });
    }
  }

  Future<void> reconectSocket(bool a) async {
    try {
      if (await isWebSocketAvailable(testUrl)) {
        channel = IOWebSocketChannel.connect(serverUrl);
        channel.stream.listen((data) {
          onDataReceived(data);
        });
        isInSocket = true;
      } else {
        isInSocket = false;
      }
    } catch (e) {
      //print('Error al conectar con el socket: $e');
      developer.log('Error al conectar con el socket: $e');
    }
    setState(() {
      chartData.clear();
      flagButton = true;
      try {
        if (isInSocket) {
          sendInfo();
          showMessageTOAST(
              context, "Conexion Exitosa con medidor", Colors.green);
        } else {
          showMessageTOAST(context, "No se pudo conectar con el medidor",
              Colors.red.shade700);
        }
      } catch (e) {
        //print('Error al conectar con el socket: $e');
        developer.log('Error al conectar con el socket: $e');
      }
    });
  }

  void sendInfo() {
    setState(() {
      SendSocket sendData = SendSocket(
          'info', idEstacion, idProgramacion, pressureCalib, timeAperture);
      String dataJson = jsonEncode(sendData);
      channel.sink.add(dataJson);
    });
  }

  void initCalib(bool action) {
    sendInfo();
    setState(() {
      isInCalibState = action;
      SendSocket dataSend;
      String dataJson;
      if (action) {
        dataSend = SendSocket('calibini', 0, 0, 0, 0);
        dataJson = jsonEncode(dataSend);
        channel.sink.add(dataJson); // Mensaje enviado al servidor
        chartData.clear();
        lineToleranceDown.clear();
        lineToleranceUp.clear();
        readyForFile = false;
        widget.storage.appendTextToFile(
            'Registro de calibracion ${DateTime.now().toLocal()}\n');
        showMessageTOAST(context, "Calibracion Iniciada", Colors.green);
      } else {
        dataSend = SendSocket('calibfin', 0, 0, 0, 0);
        dataJson = jsonEncode(dataSend);
        channel.sink.add(dataJson); // Mensaje enviado al servidor
        saveFileData();
        showMessageTOAST(context, "Calibracion Terminada", Colors.red.shade700);
        //sincronizeFile();
      }
    });
  }

  void initTest(bool action) {
    setState(() {
      isInTestState = action;
      SendSocket sendData;
      String dataJson;
      if (action) {
        sendData = SendSocket("toggleini", 0, 0, 0, 0);
        dataJson = jsonEncode(sendData);
        channel.sink.add(dataJson);
        readyForFile = false;
        chartData.clear();
        lineToleranceDown.clear();
        lineToleranceUp.clear();
        showMessageTOAST(context, "Prueba Iniciada", Colors.green);
        widget.storage.appendTextToFile(
            'Registro de mediciones ${DateTime.now().toLocal()}\n');
      } else {
        sendData = SendSocket("togglefin", 0, 0, 0, 0);
        dataJson = jsonEncode(sendData);
        channel.sink.add(dataJson); // Mensaje enviado al servidor
        saveFileData();
        showMessageTOAST(context, "Prueba Terminada", Colors.red.shade700);
        //sincronizeFile();
      }
    });
  }

  Future<void> _loadImages() async {
    try {
      // Obtener el directorio donde se almacenan las imágenes
      final directory = await getTemporaryDirectory();
      // Listar todos los archivos en el directorio
      List<FileSystemEntity> files = directory.listSync();
      // Filtrar solo los archivos de tipo imagen (puedes ajustar esto según los tipos de imágenes que estás almacenando)
      List<File> imageFiles = files
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.png'))
          .toList();

      print(
          'Lista de imágenes cargada: ${imageFiles.map((file) => file.path).toList()}');

      setState(() {
        _imageFiles.clear(); // Limpiar la lista antes de cargar nuevas imágenes
        _imageFiles = imageFiles;
      });
    } catch (e) {
      print('Error al cargar las imágenes: $e');
    }
  }

  PreferredSizeWidget _appbar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            if (mounted) {
              pingTimer.cancel();
            }
            if (flagButton) {
              channel.sink.close();
            }
            Navigator.pushNamed(context, 'home');
          },
          icon: const Icon(Icons.arrow_back_ios)),
      elevation: 10,
      title: _defaultText(0.03, 'Test N° ${idProgramacion.toString()}', 18,
          Colors.black45, FontWeight.bold),
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black54,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        )
      ],
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

  Widget _cardStep(double height, IconData icon, int stepN, String step) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: Icon(icon),
          title: Text('Paso $stepN:'),
          subtitle: Text(step),
        ),
      ),
    );
  }

  Widget _dataGraph(double height, List<ChartData> data) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: SfCartesianChart(
        legend: Legend(
          iconBorderWidth: 2,
          offset: const Offset(20, -80),
          isVisible: true,
          position: LegendPosition.bottom,
          //alignment: ChartAlignment.center
        ),
        primaryXAxis: DateTimeAxis(
            axisLine: const AxisLine(width: 2, color: Colors.black45),
            title: AxisTitle(text: "Segundos(s)"),
            autoScrollingMode: AutoScrollingMode.end,
            autoScrollingDelta: 30,
            //edgeLabelPlacement: EdgeLabelPlacement.shift,
            intervalType: DateTimeIntervalType.seconds,
            interval: 5),
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 2, color: Colors.black45),
            maximum: pressureCalib * 2,
            minimum: 0,
            labelFormat: '{value}PSI',
            plotBands: <PlotBand>[
              PlotBand(
                isVisible: true,
                start: pressureCalib * (1 - 0.01 * timeAperture),
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
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            legendItemText: "Presión[PSI]",
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.timeP,
            yValueMapper: (ChartData data, _) => data.value,
            color: Colors.greenAccent.shade400,
            width: 2,
            opacity: 1,
            splineType: SplineType.monotonic,
          ),
        ],
      ),
    );
  }

  Widget _actionButton(bool enable, bool state, void Function(bool) function,
      Color colorButton, String text) {
    return CustomerElevateButton(
        texto: text,
        colorTexto: Colors.white,
        colorButton: !state
            ? Colors.red
            : enable
                ? colorButton
                : Colors.grey,
        onPressed: !state
            ? () => function(false)
            : enable
                ? () => function(true)
                : () {},
        height: .05,
        width: .45);
  }

  Widget _rowButtons(
    double height,
    String textButton1,
    String textButton2,
    void Function(bool) functionButton1,
    void Function(bool) functionButton2,
  ) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _actionButton(!isInCalibState && !isInTestState, !isInCalibState,
              functionButton1, Colors.green.shade300, textButton1),
          _actionButton(!isInCalibState && !isInTestState, !isInTestState,
              functionButton2, Colors.green.shade300, textButton2),
        ],
      ),
    );
  }

  Widget _rowInfo(double height, String text) {
    return SizedBox(
        height: getScreenSize(context).height * height,
        width: getScreenSize(context).width * 0.95,
        child: Card(
          elevation: 10,
          child: ListTile(
            leading: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ConfigTestOverlay();
                  },
                );
              },
              icon: const Icon(Icons.settings),
            ),
            title: _defaultText(0.025, text, 15, Colors.black, FontWeight.bold),
          ),
        ));
  }

  Widget _resultButton(String text, Color color) {
    return _actionButton(!isInTestState && !isInCalibState, true, (bool a) {
      showDialog(
        context: context,
        builder: (context) {
          return const ShowFileOverlay();
        },
      );
    }, color, text);
  }

  Widget _cameraButton(String text, Color color) {
    return _actionButton(true, true, (bool a) {
      Navigator.pushNamed(context, 'camera');
    }, color, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appbar(),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_white.jpg'),
                fit: BoxFit.fill)),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: getScreenSize(context).height * 0.02),
                _defaultText(0.08, "PRUEBA DE HERMETICIDAD", 25, Colors.black,
                    FontWeight.bold),
                SizedBox(height: getScreenSize(context).height * 0.01),
                _defaultText(0.02, macESP32, 16, Colors.black, FontWeight.w500),
                isInSocket ? _buildStartTest() : _buildSteps(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSteps() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: getScreenSize(context).height * 0.015),
        _actionButton(!(isInSocket || !checkboxValue), true, reconectSocket,
            Colors.green.shade300, "Sincronizar"),
        SizedBox(height: getScreenSize(context).height * 0.015),
        _defaultText(0.03, paso0, 16, Colors.black, FontWeight.w500),
        SizedBox(height: getScreenSize(context).height * 0.015),
        _cardStep(0.1, Icons.cable, 1, paso1),
        SizedBox(height: getScreenSize(context).height * 0.015),
        _cardStep(0.1, Icons.signal_cellular_off, 2, paso2),
        SizedBox(height: getScreenSize(context).height * 0.015),
        _cardStep(0.13, Icons.wifi, 3, paso3),
        SizedBox(height: getScreenSize(context).height * 0.015),
        _cardStep(0.15, Icons.radio_button_checked, 4, paso4),
        SizedBox(height: getScreenSize(context).height * 0.015),
        _imageFiles.isNotEmpty
            ? SizedBox(
                width: getScreenSize(context).width * 0.9,
                height: getScreenSize(context).height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageFiles.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Image.file(
                        _imageFiles[index],
                        width: getScreenSize(context).width * 0.2,
                      ),
                    );
                  },
                ),
              )
            : Container(),
        _cameraButton("Evidencias", Colors.green.shade300),
      ],
    );
  }

  Widget _buildStartTest() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: getScreenSize(context).height * 0.01),
        _defaultText(0.025, receivedText, 16, Colors.black, FontWeight.bold),
        SizedBox(height: getScreenSize(context).height * 0.01),
        _defaultText(0.02, timeText, 16, Colors.black, FontWeight.bold),
        _dataGraph(0.5, chartData),
        _rowInfo(0.07, 'Calibracion: $pressureCalib(PSI)±$timeAperture% '),
        SizedBox(height: getScreenSize(context).height * 0.01),
        _rowButtons(0.05, "Calibrar", "Testear", initCalib, initTest),
        SizedBox(height: getScreenSize(context).height * 0.01),
        _resultButton("Resultados", Colors.blueAccent)
      ],
    );
  }
}

class ConfigTestOverlay extends StatefulWidget {
  const ConfigTestOverlay({super.key});

  @override
  State<ConfigTestOverlay> createState() => _ConfigTestOverlayState();
}

class _ConfigTestOverlayState extends State<ConfigTestOverlay> {
  Widget _popBar(double heightContent, IconData icon) {
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
            try {
              pressureCalib = int.parse(controllerPressure.text);
              timeAperture = int.parse(controllerTimeAperture.text);
              enableCalib = true;
              Navigator.pop(context);
            } catch (e) {
              showMessageTOAST(context, "Ingrese un valor", Colors.red);
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
            child: Column(children: [
              _popBar(0.05, Icons.close),
              _defaultText("CONFIGURACION CALIBRACION", 18, Colors.black54, 2,
                  FontWeight.bold),
              SizedBox(height: getScreenSize(context).height * 0.02),
              _textFieldConfig(0.1, "Presion (PSI)", Icons.chevron_right,
                  TextInputType.number, controllerPressure),
              _textFieldConfig(0.1, "Tolerancia (%)", Icons.chevron_right,
                  TextInputType.number, controllerTimeAperture),
              _configButton(0.05, "CONFIGURAR")
            ]),
          ),
        ),
      ),
    );
  }
}

class ShowFileOverlay extends StatefulWidget {
  const ShowFileOverlay({super.key});

  @override
  State<ShowFileOverlay> createState() => _ShowFileOverlayState();
}

class _ShowFileOverlayState extends State<ShowFileOverlay> {
  void sendFileApi() {
    showDialogLoad(context);
    String fileContFormat = fileContentData
        .replaceAll("Registro de mediciones\n", "")
        .replaceAll("------Calibracion-----\n", "")
        .replaceAll("--------Testeo--------\n", "")
        .replaceAll(" ", "")
        .replaceAll("][", ",")
        .replaceAll("]\n", ";")
        .replaceAll("[", "");
    developer.log(fileContFormat);
    String fileUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTsubirArchivo';
    postFile(fileUrl, fileContFormat).then((value) {
      Navigator.pop(context);
      if (value) {
        showMessageTOAST(context, "Archivo enviado", Colors.green);
      } else {
        showMessageTOAST(context,
            "Error, Conectese a la red movil e intente de nuevo", Colors.green);
      }
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
          onPressed: sendFileApi,
          texto: text,
          colorTexto: Colors.white,
          colorButton: Colors.green.shade300,
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
                _scrollData(0.4, fileContentData),
                SizedBox(height: getScreenSize(context).height * 0.02),
                _defaultText("*Conecte su dispositivo a la red movil", 14,
                    Colors.red, 2, FontWeight.bold),
                SizedBox(height: getScreenSize(context).height * 0.02),
                _sendButton(0.05, "Enviar Datos"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
