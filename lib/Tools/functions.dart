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
      developer.log(response.body);
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
      developer.log('[postFile] Respuesta: ${response.body}');
    } else {
      // Hubo un error en la solicitud
      status = false;
      developer.log(
          '[postFile] Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    developer.log('[postFile] Error: $e');
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

Future<bool> sendCloseItemTimeLine(int idProceso, int tipoProceso) async {
  bool status;
  final client = http.Client();
  String fileUrl =
      'http://${controllerIp.text}:${controllerPort.text}/api/POSTactualizarProcesoSolicitud';
  try {
    Map<String, dynamic> mapUpdateInfo = {
      'GuidSesion': tokenUsuarioGlobal,
      'IdProcesoSolicitud': idProceso,
      'TipoProceso': tipoProceso,
      'Estado': true
    };
    String jsonUpdateInfo = jsonEncode(mapUpdateInfo);
    var response = await client
        .post(Uri.parse(fileUrl),
            headers: {"Content-Type": "application/json"}, body: jsonUpdateInfo)
        .timeout(const Duration(seconds: 10));
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
    developer.log('Respuesta de la API: ${response.statusCode}');
  } catch (e) {
    developer.log('Error: $e');
    client.close();
    status = false;
  } finally {
    client.close();
  }
  return status;
}

Future<bool> sendForm(String sendUrl, String sendJson) async {
  bool status = false;
  final client = http.Client();
  try {
    var response = await client
        .post(Uri.parse(sendUrl),
            headers: {"Content-Type": "application/json"}, body: sendJson)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      developer.log('Respuesta:${response.body}');
      status = true;
    } else {
      status = false;
      developer.log('Error al enviar el formulario');
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

Future<List<bool>> sendImagesToApi(
    List<File> imageFiles, List<String> nameFiles) async {
  List<bool> status = [];
  final client = http.Client();
  String fileUrl =
      'http://${controllerIp.text}:${controllerPort.text}/api/POSTsubirImagen';
  try {
    for (int i = 0; i < imageFiles.length; i++) {
      String imageDataString = await convertImageToBase64(imageFiles[i]);
      imageDataString = 'data:image/png;base64,$imageDataString';
      String nameImg = nameFiles[i];
      Map<String, dynamic> mapImageinfo = {
        'IdSolicitud': idProgramacion,
        'imagen': imageDataString,
        'Nombre': nameImg
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

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      developer.log('Conexión a Internet disponible');
      return true;
    }
  } on SocketException catch (_) {
    developer.log('Sin conexión a Internet');
  }
  return false;
}

Future<List<dynamic>> getListSchedule() async {
  List<dynamic> listaRespuesta = [];

  try {
    Map<String, dynamic> mapGetSchedule = {
      'IdUsuario': idUsuarioGlobal,
      'GuidSesion': tokenUsuarioGlobal
    };
    String peticionesUrl =
        'http://$ipGlobal:$portGlobal/api/POSTobtenerProgramacionPrueba';
    await getScheduleAPI(peticionesUrl, jsonEncode(mapGetSchedule))
        .then((List<dynamic> value) {
      if (value.isNotEmpty) {
        listaRespuesta = value;
      }
    });
  } catch (e) {
    developer.log(e.toString());
  }

  return listaRespuesta;
}

Future<Map> sendFormAuthorized(String jsonRequest) async {
  Map<String, dynamic> mapRespuesta = {};

  try {
    final client = http.Client();
    var response = await client
        .post(
            Uri.parse(
                "http://$ipGlobal:$portGlobal/api/POSTformularioAutorizacion"),
            headers: {"Content-Type": "application/json"},
            body: jsonRequest)
        .timeout(const Duration(seconds: 10));

    mapRespuesta = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mapRespuesta["Codigo"] = 200;
      // La solicitud se realizó con éxito
    } else {
      // Hubo un error en la solicitud
      mapRespuesta["Codigo"] = response.statusCode;
      developer.log(
          'Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    developer.log('Error: $e');
    mapRespuesta.addAll({"Error": true, "Codigo": 0, "Mensaje": e.toString()});
  }

  return mapRespuesta;
}

Future<Map> validateUser(String jsonRequest) async {
  Map<String, dynamic> mapRespuesta = {};

  try {
    final client = http.Client();
    var response = await client
        .post(Uri.parse("http://$ipGlobal:$portGlobal/api/POSTvalidarIngreso"),
            headers: {"Content-Type": "application/json"}, body: jsonRequest)
        .timeout(const Duration(seconds: 10));

    mapRespuesta = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // La solicitud se realizó con éxito
    } else {
      // Hubo un error en la solicitud
      mapRespuesta.addAll({
        "Error": true,
        "Code": response.statusCode,
        "Message": "Error al procesar solicitud"
      });
      developer.log(
          'Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    developer.log('Error: $e');
    mapRespuesta.addAll({"Error": true, "Code": 0, "Message": e.toString()});
  }

  return mapRespuesta;
}
