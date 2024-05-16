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
  final int? idEstacion;
  final int? idProgramacion;
  final int? pressionCalib;
  final int? timeAperture;
  final int? initHour;
  final int? initMinute;
  final int? initSecond;
  final int? initMilis;
  final bool? newMessure;

  SendSocket(
      this.action,
      this.idEstacion,
      this.idProgramacion,
      this.pressionCalib,
      this.timeAperture,
      this.initHour,
      this.initMinute,
      this.initSecond,
      this.initMilis,
      this.newMessure);

  SendSocket.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        idEstacion = json['idEstacion'],
        idProgramacion = json['idProg'],
        pressionCalib = json['pressCalib'],
        timeAperture = json['timeAperture'],
        initHour = json['initHour'],
        initMinute = json['initMinute'],
        initSecond = json['initSecond'],
        initMilis = json['initMilis'],
        newMessure = json['newMessure'];

  Map<String, dynamic> toJson() => {
        'action': action,
        'idEstacion': idEstacion,
        'idProg': idProgramacion,
        'pressCalib': pressionCalib,
        'timeAperture': timeAperture,
        'initHour': initHour,
        'initMinute': initMinute,
        'initSecond': initSecond,
        'initMilis': initMilis,
        'newMessure': newMessure,
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

class Request {
  late int idProcesoProgramacion;
  late bool registroInicio;
  late bool registroFoto;
  late bool registroCalibracion;
  late bool registroIncioPrueba;
  late bool registroResultados;
  late bool registroFinal;
  late int idProgramacion;
  late String ordenTrabajo;
  late String nombreEstacion;
  late String tipoPrueba;
  late String fileData;

  Request(
      {required this.idProcesoProgramacion,
      required this.registroInicio,
      required this.registroFoto,
      required this.registroCalibracion,
      required this.registroIncioPrueba,
      required this.registroResultados,
      required this.registroFinal,
      required this.idProgramacion,
      required this.ordenTrabajo,
      required this.nombreEstacion,
      required this.tipoPrueba,
      required this.fileData});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
        idProcesoProgramacion: json['IdProcesoProgramacion'],
        registroInicio: json['RegistroInicio'],
        registroFoto: json['RegistroFoto'],
        registroCalibracion: json['RegistroCalibracion'],
        registroIncioPrueba: json['RegistroInicioPrueba'],
        registroResultados: json['RegistroResultados'],
        registroFinal: json['RegistroFinal'],
        idProgramacion: json['IdProgramacion'],
        ordenTrabajo: json['OT'],
        nombreEstacion: json['Estacion'],
        tipoPrueba: json['TipoPrueba'],
        fileData: '');
  }
  Map<String, dynamic> toJson() => {
        'IdProcesoProgramacion': idProcesoProgramacion,
        'RegistroInicio': registroInicio,
        'RegistroFoto': registroFoto,
        'RegistroCalibracion': registroCalibracion,
        'RegistroInicioPrueba': registroIncioPrueba,
        'RegistroResultados': registroResultados,
        'IdProgramacion': idProgramacion,
        'OT': ordenTrabajo,
        'Estacion': nombreEstacion,
        'TipoPrueba': tipoPrueba,
        'FileData': fileData
      };
}

class Solicitud {
  final int idSolicitud;
  final int idProgramacion;
  final String observaciones;
  final String tipoPrueba;
  final int idLineaIdTanque;
  final int idProceso;
  final bool registroCalibracion;
  final bool registroCierre;
  final bool registroFinal;
  final bool registroFoto;
  final bool registroInicio;
  final bool registroInicioPrueba;
  final bool registroResultados;

  Solicitud({
    required this.idSolicitud,
    required this.idProgramacion,
    required this.observaciones,
    required this.tipoPrueba,
    required this.idLineaIdTanque,
    required this.idProceso,
    required this.registroCalibracion,
    required this.registroCierre,
    required this.registroFinal,
    required this.registroFoto,
    required this.registroInicio,
    required this.registroInicioPrueba,
    required this.registroResultados,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      idSolicitud: json['IdSolicitud'],
      idProgramacion: json['IdProgramacion'],
      observaciones: json['Observaciones'],
      tipoPrueba: json['TipoPrueba'],
      idLineaIdTanque: json['IdLinea_IdTanque'],
      idProceso: json['IdProceso'],
      registroCalibracion: json['RegistroCalibracion'],
      registroCierre: json['RegistroCierre'],
      registroFinal: json['RegistroFinal'],
      registroFoto: json['RegistroFoto'],
      registroInicio: json['RegistroInicio'],
      registroInicioPrueba: json['RegistroInicioPrueba'],
      registroResultados: json['RegistroResultados'],
    );
  }
}

class Programacion {
  final int idProgramacion;
  final int idEstacion;
  final String estacion;
  final String nit;
  final String razonSocial;
  final String correoEstacion;
  final String direccion;
  final int idUsuario;
  final String correoUsuario;
  final String userName;
  final String rol;
  final String ordenDeTrabajo;
  final String fechaProgramacion;
  final List<Solicitud> solicitud;

  Programacion({
    required this.idProgramacion,
    required this.idEstacion,
    required this.estacion,
    required this.nit,
    required this.razonSocial,
    required this.correoEstacion,
    required this.direccion,
    required this.idUsuario,
    required this.correoUsuario,
    required this.userName,
    required this.rol,
    required this.ordenDeTrabajo,
    required this.fechaProgramacion,
    required this.solicitud,
  });

  factory Programacion.fromJson(Map<String, dynamic> json) {
    var solicitudList = json['Solicitud'] as List;
    List<Solicitud> solicitudes =
        solicitudList.map((s) => Solicitud.fromJson(s)).toList();

    return Programacion(
      idProgramacion: json['IdProgramacion'],
      idEstacion: json['IdEstacion'],
      estacion: json['Estacion'],
      nit: json['Nit'],
      razonSocial: json['RazonSocial'],
      correoEstacion: json['CorreoEstacion'],
      direccion: json['Direccion'],
      idUsuario: json['IdUsuario'],
      correoUsuario: json['CorreoUsuario'],
      userName: json['UserName'],
      rol: json['Rol'],
      ordenDeTrabajo: json['OrdenDeTrabajo'],
      fechaProgramacion: json['FechaProgramacion'],
      solicitud: solicitudes,
    );
  }
}
