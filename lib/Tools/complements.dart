import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/encripter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

Size getScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

TextEditingController controllerEmail = TextEditingController();
TextEditingController controllerPassword = TextEditingController();

TextEditingController controllerIp = TextEditingController();
TextEditingController controllerPort = TextEditingController();

TextEditingController controllerNameRegister = TextEditingController();
TextEditingController controllerLastNameRegister = TextEditingController();
TextEditingController controllerEmailRegister = TextEditingController();
TextEditingController controllerPasswordRegister = TextEditingController();
TextEditingController controllerEmailForget = TextEditingController();

TextEditingController controllerPressure = TextEditingController();
TextEditingController controllerTimeAperture = TextEditingController();

Encriptador encriptador = Encriptador();

String nombreUsuarioGlobal = "";
String rolUsuarioGlobal = "";
int idUsuarioGlobal = 0;
String tokenUsuarioGlobal = "";
String fechaIngresoUsuario = "";
int idEstacion = 0;
int idProgramacion = 0;
int pressureCalib = 15;
int timeAperture = 10;
String fileContentData = "";
List<ChartData> chartData = [];
List<ChartData> chartDataStatic = [];
List<ChartData> lineToleranceUp = [];
List<ChartData> lineToleranceDown = [];

List<dynamic> requestList = [];

bool enableCalib = false;

Future<bool?> showMessageTOAST(
    BuildContext context, String mensaje, Color color) {
  return Fluttertoast.showToast(
      msg: mensaje,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16);
}

Future<void> showDialogLoad(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
      );
    },
  );
}

Future<void> readCacheData() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cacheJson = prefs.getString('cacheJson') ?? "";
    if (cacheJson.isNotEmpty) {
      Map<String, dynamic> cacheMap = jsonDecode(cacheJson);
      developer.log('Cache leida: $cacheMap');
      CacheData cacheData = CacheData.fromJson(cacheMap);
      controllerIp.text = cacheData.ipApi;
      controllerPort.text = cacheData.portApi;
    }
  } catch (e) {
    developer.log("Error al leer cache");
  }
}

Future<void> writeCacheData(String ipApi, String portApi) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    CacheData cacheData = CacheData(ipApi, portApi);
    String cacheJson = jsonEncode(cacheData);
    developer.log('Cache escrita: $cacheJson');
    await prefs.setString('cacheJson', cacheJson);
  } catch (e) {
    developer.log("Error al escribir cache");
  }
}
