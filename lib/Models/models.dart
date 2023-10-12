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

  UserSocket(this.presion, this.nDatos, this.mac);

  UserSocket.fromJson(Map<String, dynamic> json)
      : presion = json['mensaje'],
        nDatos = json['nDatos'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
        'presion': presion,
        'nDatos': nDatos,
        'mac': mac,
      };
}

class ChartData {
  final String timeP;
  final double value;

  ChartData(this.timeP, this.value);
}
