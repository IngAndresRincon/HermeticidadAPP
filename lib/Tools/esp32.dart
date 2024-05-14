import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

String estado = 'Desconectado';
String mac = '';
String presion = '0.00';
String tiempo = '[00:00:00]';

double calibValue = 15;

List<Map<String, dynamic>> stepsIcons = [
  {'paso': "Verifique la correcta conexion del medidor.", 'icono': Icons.cable},
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

DateTime dateTimeConvert(String time) {
  DateTime timeConvert;
  final timeArray = time
      .replaceAll("]", "")
      .replaceAll("[", "")
      .replaceAll(" ", "")
      .split(":");
  if (timeArray.length == 3) {
    //saveLastTimeReceived(timeArray, false);
    timeConvert = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(timeArray[0]),
        int.parse(timeArray[1]),
        int.parse(timeArray[2]));
  } else if (timeArray.length == 4) {
    //saveLastTimeReceived(timeArray, true);
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

Future<Map<String, dynamic>> getEsp32() async {
  Map<String, dynamic> dataEsp32 = {};
  try {
    final client = http.Client();
    final response =
        await client.get(Uri.parse('http://192.168.11.100:80/lectura'));
    dataEsp32 = jsonDecode(response.body);

    if (response.statusCode == 200) {
      developer.log(response.body);
    } else {
      developer.log('Error de estado: ${response.statusCode}');
    }
  } on Exception catch (e) {
    estado = "Desconectado";
    developer.log('Error en la peticion Get a la ESP32: $e');
  }
  return dataEsp32;
}

Future<bool> postEsp32(String jsonRequest) async {
  bool status = false;
  Map<String, dynamic> responseEsp32 = {};
  Map<String, dynamic> respuesta = {};

  try {
    final client = http.Client();
    final response = await client
        .post(Uri.parse('http://192.168.11.100:80/control'),
            headers: {"Content-Type": "application/json"}, body: jsonRequest)
        .timeout(const Duration(seconds: 10));
    responseEsp32 = jsonDecode(response.body);
    respuesta = jsonDecode(responseEsp32["respuesta"]);
    estado = respuesta["estado"];

    if (response.statusCode == 200) {
      developer.log(responseEsp32.toString());
      status = true;
    } else {
      developer.log('Error Estado: ${response.statusCode}');
    }
  } on Exception catch (e) {
    estado = "Desconectado";
    developer.log('Error en la peticion POST a la ESP32: $e');
  }
  return status;
}

Future<String> getSDesp32() async {
  String sdData = '';
  try {
    final client = http.Client();
    final response = await client.get(Uri.parse('http://192.168.11.100:80/SD'));
    if (response.statusCode == 200) {
      developer.log(response.body);
      sdData = response.body;
    } else {
      developer.log('Error en estado respuesta: ${response.statusCode}');
    }
  } catch (e) {
    developer.log('Error en peticion get a sd: $e');
  }
  return sdData;
}
