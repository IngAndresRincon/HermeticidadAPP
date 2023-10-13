import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Widgets/elevatebutton.dart';

import 'package:web_socket_channel/io.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class TestPage extends StatefulWidget {
  final StorageFile storage = StorageFile();
  TestPage({super.key});
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  //final channel = IOWebSocketChannel.connect('ws://192.168.11.100/ws');
  late WebSocketChannel channel;
  List<ChartData> chartData = [];
  String receivedText = 'Datos Recibidos...';
  String macESP32 = 'Sin Conexion...';
  bool isInTestState = false;
  bool isInCalibState = false;
  bool isInSocket = false;
  bool flagButton = false;
  bool checkboxValue = false;
  String paso0 = "Pasos para realizar la prueba:\n";
  String paso1 = "1.Conecte el dispositivo de medicion correctamente.\n";
  String paso2 = "2.Desconecte su celular de los datos moviles.\n";
  String paso3 =
      "3.Conecte su dispositivo movil a la red wifi que genera el medidor llamada 'ESP_D4A891.'\n";
  String paso4 =
      "4.Oprima el boton 'Sincronizar' para conectarse con el medidor y comenzar la prueba.\n";
  @override
  void dispose() {
    super.dispose();
    if (flagButton) {
      channel.sink
          .close(); // Cierra el canal WebSocket cuando el widget se elimina
    }
  }

  @override
  void initState() {
    widget.storage.writeFileData(
        "Primera linea en el archivo\nSegunda linea del archivo\nTercera linea del archivo");
    super.initState();
  }

  void showDataFile() async {
    await widget.storage.readFileData();
    setState(() {});
  }

  void onDataReceived(dynamic data) async {
    String datosArchivo = "";
    for (ChartData charts in chartData) {
      datosArchivo +=
          charts.timeP + "Medicion: " + charts.value.toString() + '\n';
    }
    widget.storage.writeFileData(datosArchivo);
    setState(() {
      Map<String, dynamic> userMap = jsonDecode(data);
      var user = UserSocket.fromJson(userMap);
      macESP32 = 'Conectado: ' + user.mac;
      macESP32 != 'Sin Conexion...' ? isInSocket = true : isInSocket = false;
      receivedText = 'Presion(PCI): ' + user.presion;

      // Parsea y agrega los datos recibidos a la lista de datos del gráfico
      try {
        final double parsedData;
        if (user.presion != "Proceso Detenido") {
          parsedData = double.parse(user.presion);
          final String timeP = user.nDatos;
          chartData.add(ChartData(timeP, parsedData));
        }
      } catch (e) {
        // Manejar cualquier error de análisis aquí, por ejemplo, si los datos no son válidos
        print('Error al analizar los datos: $e');
      }
    });
  }

  void reconectSocket() {
    //showDialogLoad(context);
    setState(() {
      try {
        flagButton = true;
        channel = IOWebSocketChannel.connect('ws://192.168.11.100/ws');
        channel.stream.listen((data) {
          onDataReceived(data);
        });
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
        showMessageTOAST(context, "Calibracion Iniciada", Colors.red.shade700);
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
          child: CheckboxListTile(
            value: checkboxValue,
            onChanged: (bool? value) {
              setState(() {
                checkboxValue = value!;
              });
            },
            title: const Text('Confirmacion de pasos realizados'),
            subtitle: const Text('He realizado todos los pasos anteriores.'),
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
