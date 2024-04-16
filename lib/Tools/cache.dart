import 'dart:convert';
import 'dart:developer' as developer;
import 'package:hermeticidadapp/Models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveConfiguration(Map mapConfiguration) async {
  bool respuesta = false;

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    CacheData cacheData =
        CacheData(mapConfiguration["Ip"], mapConfiguration["Port"]);
    String cacheJson = jsonEncode(cacheData);
    developer.log('Cache escrita: $cacheJson');
    await prefs.setString('cacheJson', cacheJson).then((value) {
      respuesta = true;
    });
  } catch (e) {
    developer.log("Error al escribir cache");
    respuesta = false;
  }
  return respuesta;
}

Future<CacheData> readConfiguration() async {
  CacheData respuestaConfiguracion = CacheData("", "");

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonConfiguracion = prefs.getString('cacheJson') ?? "";
    if (jsonConfiguracion.isNotEmpty) {
      respuestaConfiguracion =
          CacheData.fromJson(jsonDecode(jsonConfiguracion));
      print(respuestaConfiguracion.ipApi);
    }
  } catch (e) {
    developer.log("Error al leer cache");
  }

  return respuestaConfiguracion;
}
