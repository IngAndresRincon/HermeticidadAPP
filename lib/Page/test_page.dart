import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Models/models.dart';
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
  late Timer pingTimer;
  double contador = 0.0;
  late ChartSeriesController _chartSeriesController;

  String paso0 = "Pasos para realizar la prueba:\n";
  String paso1 = "1.Verifique la correcta conexion del medidor.";
  String paso2 = "2.Desconecte su celular de los datos moviles.\n";
  String paso3 =
      "3.Conecte su dispositivo movil a la red wifi que genera el medidor llamada 'Medidor_PSI' y contraseña 'insepetAd'.\n";
  String paso4 =
      "4.Si se conectó a la red correcta el boton 'Sincronizar' se habilitará, oprimalo para conectarse con el medidor y comenzar la prueba.\n";
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
  }

  @override
  void initState() {
    super.initState();
    // Configura un temporizador para enviar pings periódicamente
    // widget.storage
    //     .writeFileData('Conexion con el medidor ${DateTime.now().toLocal()}\n');
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

  Future<void> reconectSocket() async {
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

  void initCalib(bool action) {
    setState(() {
      isInCalibState = action;
      SendSocket dataSend;
      String dataJson;
      if (action) {
        dataSend = SendSocket('calibini', 0, 0,0);
        dataJson = jsonEncode(dataSend);
        channel.sink.add(dataJson); // Mensaje enviado al servidor
        chartData.clear();
        readyForFile = false;
        widget.storage.appendTextToFile(
            'Registro de calibracion ${DateTime.now().toLocal()}\n');
        showMessageTOAST(context, "Calibracion Iniciada", Colors.green);
      } else {
        dataSend = SendSocket('calibfin', 0, 0,0);
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
        sendData = SendSocket("toggleini", 0, 0,0);
        dataJson = jsonEncode(sendData);
        channel.sink.add(dataJson);
        readyForFile = false;
        chartData.clear();
        showMessageTOAST(context, "Prueba Iniciada", Colors.green);
        widget.storage.appendTextToFile(
            'Registro de mediciones ${DateTime.now().toLocal()}\n');
      } else {
        sendData = SendSocket("togglefin", 0, 0,0);
        dataJson = jsonEncode(sendData);
        channel.sink.add(dataJson); // Mensaje enviado al servidor
        saveFileData();
        showMessageTOAST(context, "Prueba Terminada", Colors.red.shade700);
        //sincronizeFile();
      }
    });
  }

  void sendInfo() {
    setState(() {
      SendSocket sendData = SendSocket('info', idEstacion, idProgramacion,3);
      String dataJson = jsonEncode(sendData);
      channel.sink.add(dataJson);
    });
  }

  Widget _defaultText(
      String text, double fontSize, Color color, FontWeight fontWeight) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          letterSpacing: 4,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight),
    );
  }

  Widget _cardStep(IconData icon, String step) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(step),
      ),
    );
  }

  Widget _dataGraph(List<ChartData> data) {
    return SfCartesianChart(
      legend: Legend(
        iconBorderWidth: 2,
        offset: const Offset(120, -80),
        isVisible: true,
        position: LegendPosition.bottom,
        //alignment: ChartAlignment.center
      ),
      primaryXAxis: DateTimeAxis(
          axisLine: const AxisLine(width: 2, color: Colors.black45),
          title: AxisTitle(text: "Segundos(s)"),
          autoScrollingMode: AutoScrollingMode.end,
          autoScrollingDelta: 30,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.seconds),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 2, color: Colors.black45),
        maximum: 30,
        minimum: 0,
        labelFormat: '{value}PSI',
        //numberFormat: NumberFormat.compact()
      ),
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
    );
  }

  Widget _actionButton(
      bool enable, void Function() function, Color colorButton, String text) {
    return CustomerElevateButton(
        texto: text,
        colorTexto: Colors.white,
        colorButton: enable ? colorButton : Colors.grey,
        onPressed: enable ? function : () {},
        height: .05,
        width: .45);
  }

  Widget _rowButtons(
      String textButton1,
      String textButton2,
      void Function() functionButton1,
      void Function() functionButton2,
      bool enableFin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _actionButton(!isInCalibState && !isInTestState, functionButton1,
            Colors.green.shade300, textButton1),
        _actionButton(
            enableFin, functionButton2, Colors.redAccent, textButton2),
      ],
    );
  }

  Widget _resultButton(String text, Color color) {
    return _actionButton(!isInTestState && !isInCalibState, () {
      showDialog(
        context: context,
        builder: (context) {
          return const ShowFileOverlay();
        },
      );
    }, color, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (mounted) {
                pingTimer.cancel();
              }
              if (flagButton) {
                channel.sink.close();
              }
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        elevation: 10,
        title: _defaultText('Test N° ${idProgramacion.toString()}', 18,
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
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_white.jpg'),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            SizedBox(height: getScreenSize(context).height * 0.1),
            SizedBox(
              height: getScreenSize(context).height * 0.87,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _defaultText("PRUEBA DE HERMETICIDAD", 25, Colors.black,
                      FontWeight.bold),
                  const SizedBox(height: 20),
                  _defaultText(macESP32, 16, Colors.black, FontWeight.w500),
                  const SizedBox(height: 20),
                  _actionButton(!(isInSocket || !checkboxValue), reconectSocket,
                      Colors.green.shade300, "Sincronizar"),
                  const SizedBox(height: 20),
                  isInSocket ? _buildStartTest(context) : _buildSteps(),
                ],
              ),
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
        _defaultText(paso0, 16, Colors.black, FontWeight.w500),
        _cardStep(Icons.cable, paso1),
        _cardStep(Icons.signal_cellular_off, paso2),
        _cardStep(Icons.wifi, paso3),
        _cardStep(Icons.radio_button_checked, paso4),
      ],
    );
  }

  Widget _buildStartTest(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _defaultText(receivedText, 16, Colors.black, FontWeight.w500),
        const SizedBox(height: 10),
        _defaultText(timeText, 16, Colors.black, FontWeight.w500),
        _dataGraph(chartData),
        _rowButtons("Calibrar", "Terminar", () => initCalib(true),
            () => initCalib(false), isInCalibState),
        const SizedBox(height: 20),
        _rowButtons("Iniciar", "Terminar", () => initTest(true),
            () => initTest(false), isInTestState),
        const SizedBox(height: 20),
        _resultButton("Resultados", Colors.blueAccent)
      ],
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
                _popBar(0.05, Icons.close),
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
