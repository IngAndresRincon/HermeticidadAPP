import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserModel {
  late int id;
  late String nombre;
  late String rol;
  late String guid;
  late String fecha;
  late String ip;
  late bool activo;

  UserModel(
      {required this.id,
      required this.nombre,
      required this.rol,
      required this.guid,
      required this.fecha,
      required this.ip,
      required this.activo});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['Id'],
        nombre: json['Nombre'],
        rol: json['Rol'],
        guid: json['GUID'],
        fecha: json['Fecha'],
        ip: json['Ip'],
        activo: json['Activo']);
  }
}

class UserSocket {
  final String presion;
  final String nDatos;
  final String mac;
  final String state;

  UserSocket(this.presion, this.nDatos, this.mac, this.state);

  UserSocket.fromJson(Map<String, dynamic> json)
      : presion = json['mensaje'],
        nDatos = json['nDatos'],
        mac = json['mac'],
        state = json['estado'];

  Map<String, dynamic> toJson() => {
        'mensaje': presion,
        'nDatos': nDatos,
        'mac': mac,
        'estado': state,
      };
}

class SendSocket {
  final String action;
  final int idEstacion;
  final int idProgramacion;
  final int pressionCalib;
  final int timeAperture;

  SendSocket(
      this.action, this.idEstacion, this.idProgramacion, this.pressionCalib, this.timeAperture);

  SendSocket.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        idEstacion = json['idEstacion'],
        idProgramacion = json['idProg'],
        pressionCalib = json['pressCalib'],
        timeAperture = json['timeAperture'];

  Map<String, dynamic> toJson() => {
        'action': action,
        'idEstacion': idEstacion,
        'idProg': idProgramacion,
        'pressCalib': pressionCalib,
        'timeAperture' : timeAperture,
      };
}

class ChartData {
  final DateTime timeP;
  final double value;

  ChartData(this.timeP, this.value);
}

class CacheData {
  final String ipApi;
  final String portApi;

  CacheData(this.ipApi, this.portApi);

  CacheData.fromJson(Map<String, dynamic> json)
      : ipApi = json['ipApi'],
        portApi = json['portApi'];

  Map<String, dynamic> toJson() => {
        'ipApi': ipApi,
        'portApi': portApi,
      };
}

class StorageFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/measuredData.txt');
  }

  Future<String> readFileData() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString(); // Leer archivo
      return contents;
    } catch (e) {
      return "0"; // Si se encuentra un error se retorna "0"
    }
  }

  Future<File> writeFileData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data); // Escribir archivo
  }

  Future<void> appendTextToFile(String textToAppend) async {
    final file = await _localFile;
    final fileSink = file.openWrite(mode: FileMode.append);
    fileSink.writeln(textToAppend);
  }

  Future<void> binaryWriteFileData(var data) async {
    final file = await _localFile;
    file.writeAsBytes(data);
  }

  Future<void> binaryappendFileData(var data) async {
    final file = await _localFile;
    final fileSink = file.openWrite(mode: FileMode.append);
    fileSink.add(data);
  }
}
