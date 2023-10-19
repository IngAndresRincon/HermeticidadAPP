import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Widgets/elevatebutton.dart';
import 'package:http/http.dart' as http;

import 'package:web_socket_channel/io.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
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
  late WebSocketChannel channel;
  List<ChartData> chartData = [];
  String receivedText = 'Datos Recibidos...';
  String macESP32 = 'Sin Conexion...';
  String conectMns = '';
  bool isInTestState = false;
  bool isInCalibState = false;
  bool isInSocket = false;
  bool flagButton = false;
  bool checkboxValue = false;
  bool isDisposeCalled = false;
  bool pong = false;
  late Timer pingTimer;
  String paso0 = "Pasos para realizar la prueba:\n";
  String paso1 = "1.Verifique la correcta conexion del medidor.";
  String paso2 = "2.Desconecte su celular de los datos moviles.\n";
  String paso3 =
      "3.Conecte su dispositivo movil a la red wifi que genera el medidor llamada 'Medidor_PSI' y contraseña 'insepetAd'.\n";
  String paso4 =
      "4.Si se conectó a la red correcta el boton 'Sincronizar' se habilitará, oprimalo para conectarse con el medidor y comenzar la prueba.\n";
  @override
  void dispose() {
    super.dispose();
    if (flagButton) {
      channel.sink
          .close(); // Cierra el canal WebSocket cuando el widget se elimina
    }
    isDisposeCalled = true;
  }

  @override
  void initState() {
    // Configura un temporizador para enviar pings periódicamente
    pingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!isDisposeCalled) {
        ping();
      }
    });
    widget.storage.writeFileData(
        "Primera linea en el archivo\nSegunda linea del archivo\nTercera linea del archivo");
    super.initState();
  }

  void showDataFile() async {
    //await widget.storage.readFileData();
    setState(() {
      Navigator.pushNamed(context, 'file');
    });
  }

  void onDataReceived(dynamic data) async {
    setState(() {
      Map<String, dynamic> userMap = jsonDecode(data);
      var user = UserSocket.fromJson(userMap);
      macESP32 = 'Conectado: ' + user.mac;
      //macESP32 != 'Sin Conexion...' ? isInSocket = true : isInSocket = false;
      receivedText = 'Presion(PSI): ' + user.presion;
      // Parsea y agrega los datos recibidos a la lista de datos del gráfico
      try {
        final double parsedData;
        if (chartData.length > 30) {
          chartData.removeAt(0);
        }
        if (user.presion != "Proceso Detenido") {
          parsedData = double.parse(user.presion);
          final String timeP = user.nDatos;
          chartData.add(ChartData(timeP, parsedData));
          String datosArchivo = '|' +
              user.nDatos +
              '|[${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}]|[' +
              user.presion +
              "PSI]|";
          widget.storage.appendTextToFile(datosArchivo);
        }
      } catch (e) {
        // Manejar cualquier error de análisis aquí, por ejemplo, si los datos no son válidos
        print('Error al analizar los datos: $e');
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

  void ping() async {
    if (await isWebSocketAvailable(testUrl)) {
      pong = true;
    } else {
      pong = false;
    }
    setState(() {
      if (pong) {
        //conectMns = macESP32;
        //showMessageTOAST(context, "Conexion Exitosa con medidor", Colors.green);
        checkboxValue = true;
      } else {
        isInSocket = false;
        checkboxValue = false;
        macESP32 = "Sin Conexion...";
        //showMessageTOAST(context, "Conexion fallida con el medidor", Colors.redAccent);
      }
    });
  }

  void reconectSocket() async {
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
      print('Error al conectar con el socket: $e');
    }
    setState(() {
      chartData.clear();
      flagButton = true;
      try {
        if (isInSocket) {
          showMessageTOAST(
              context, "Conexion Exitosa con medidor", Colors.green);
        } else {
          showMessageTOAST(context, "No se pudo conectar con el medidor",
              Colors.red.shade700);
        }
      } catch (e) {
        print('Error al conectar con el socket: $e');
      }
    });
  }

  void initCalib() {
    setState(() {
      isInCalibState = !isInCalibState;
      if (isInCalibState) {
        chartData.clear();
        showMessageTOAST(context, "Calibracion Iniciada", Colors.green);
      } else {
        showMessageTOAST(context, "Calibracion Terminada", Colors.red.shade700);
      }
      channel.sink.add('calib'); // Mensaje enviado al servidor
    });
  }

  void initTest() {
    setState(() {
      isInTestState = !isInTestState;
      if (isInTestState) {
        chartData.clear();
        showMessageTOAST(context, "Prueba Iniciada", Colors.red.shade700);
        widget.storage.writeFileData(
            'Registro de mediciones ${DateTime.now().toLocal()}\n');
      } else {
        showMessageTOAST(context, "Prueba Terminada", Colors.red.shade700);
      }
      channel.sink.add('toggle'); // Mensaje enviado al servidor
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (flagButton) {
                channel.sink.close();
              }
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        elevation: 10,
        title: const Text(
          "Test",
          style: TextStyle(color: Colors.black54, fontSize: 18),
        ),
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
            Container(
              height: getScreenSize(context).height * 0.1,
            ),
            SizedBox(
              height: getScreenSize(context).height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "PRUEBA DE HERMETICIDAD",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 4,
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    macESP32,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        letterSpacing: 4,
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomerElevateButton(
                      onPressed:
                          isInSocket || !checkboxValue ? () {} : reconectSocket,
                      texto: "Sincronizar",
                      colorTexto: Colors.white,
                      colorButton: isInSocket || !checkboxValue
                          ? Colors.grey
                          : Colors.green.shade300,
                      height: .05,
                      width: .7),
                  const SizedBox(
                    height: 20,
                  ),
                  isInSocket ? _buildStartTest() : _buildSteps(),
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
        Text(
          paso0,
          textAlign: TextAlign.center,
          style: const TextStyle(
              letterSpacing: 4,
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.cable),
            title: Text(paso1),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.signal_cellular_off),
            title: Text(paso2),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.wifi),
            title: Text(paso3),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.radio_button_checked),
            title: Text(paso4),
          ),
        ),
      ],
    );
  }

  Widget _buildStartTest() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          receivedText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              letterSpacing: 4,
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 20,
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            LineSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.timeP,
              yValueMapper: (ChartData data, _) => data.value,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomerElevateButton(
                onPressed: initCalib,
                texto: !isInCalibState ? "Calibrar" : "Terminar",
                colorTexto: Colors.white,
                colorButton:
                    !isInCalibState ? Colors.green.shade300 : Colors.redAccent,
                height: .05,
                width: .45),
            CustomerElevateButton(
                onPressed: initTest,
                texto: !isInTestState ? "Iniciar" : "Terminar",
                colorTexto: Colors.white,
                colorButton:
                    !isInTestState ? Colors.green.shade300 : Colors.redAccent,
                height: .05,
                width: .45),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        CustomerElevateButton(
            onPressed: !isInTestState ? showDataFile : () {},
            texto: "Resultados",
            colorTexto: Colors.white,
            colorButton: !isInTestState ? Colors.green.shade300 : Colors.grey,
            height: .05,
            width: .45),
      ],
    );
  }
}
