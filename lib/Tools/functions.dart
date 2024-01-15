import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:http/http.dart' as http;

//late String pingUrl;
//late String postUrl;
//late String fileUrl;
//late String peticionesUrl;

Future<String> postLogin(String postUrl, String jsonDataUser) async {
  final client = http.Client();
  try {
    var response = await client
        .post(Uri.parse(postUrl),
            headers: {"Content-Type": "application/json"}, body: jsonDataUser)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load user');
      return response.statusCode.toString();
    }
  } catch (e) {
    // throw Exception(e);
    client.close();
  } finally {
    client.close();
  }

  return "";
}

Future<bool> postFile(String fileUrl, String fileString) async {
  bool status = false;
  final client = http.Client();
  try {
    final response = await client.post(Uri.parse(fileUrl),
        headers: <String, String>{
          "Content-Type": "text/plain", // Configura el tipo de contenido
        },
        body: fileString);
    if (response.statusCode == 200) {
      // La solicitud se realizó con éxito
      status = true;
      developer.log('Respuesta: ${response.body}');
    } else {
      // Hubo un error en la solicitud
      status = false;
      developer.log(
          'Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    developer.log('Error: $e');
    client.close();
    status = false;
  } finally {
    client.close();
  }
  return status;
}

Future<List<dynamic>> getScheduleAPI(String peticionesUrl, jsonRequest) async {
  List<dynamic> listGetSchedule = [];

  try {
    final client = http.Client();
    var response = await client
        .post(Uri.parse(peticionesUrl),
            headers: {"Content-Type": "application/json"}, body: jsonRequest)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // La solicitud se realizó con éxito
      developer.log('Respuesta: ${response.body}');
      listGetSchedule = jsonDecode(response.body);
      return listGetSchedule;
    } else {
      // Hubo un error en la solicitud
      developer.log(
          'Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    developer.log('Error: $e');
  }

  return listGetSchedule;
}


  Future<String> convertImageToBase64(File imageFile) async {
    try {
      Uint8List byteImage = await imageFile.readAsBytes();
      String base64String = base64Encode(byteImage);
      return base64String;
    } catch (e) {
      developer.log('Error al convertir la imagen a bytes: $e');
      return '';
    }
  }

  Future<List<bool>> sendImagesToApi(List<File> imageFiles) async {
    List<bool> status = [];
    final client = http.Client();
    String fileUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTsubirImagen';
    try {
      for (var imageFile in imageFiles) {
        String imageDataString = await convertImageToBase64(imageFile);
        imageDataString = 'data:image/png;base64,$imageDataString';
        Map<String, dynamic> mapImageinfo = {
          'IdSolicitud': idProgramacion,
          'imagen': imageDataString
        };
        String jsonDataImage = jsonEncode(mapImageinfo);

        //developer.log('Json de imagen: $mapImageinfo');
        var response = await client
            .post(Uri.parse(fileUrl),
                headers: {"Content-Type": "application/json"},
                body: jsonDataImage)
            .timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          // La solicitud se realizó con éxito
          status.add(true);
          developer.log('Respuesta: ${response.body}');
        } else {
          // Hubo un error en la solicitud
          status.add(false);
          developer.log(
              'Error en la solicitud. Código de estado: ${response.statusCode}');
        }
        developer.log('Respuesta de la API: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error: $e');
      client.close();
      status.add(false);
    } finally {
      client.close();
    }
    return status;
  }

