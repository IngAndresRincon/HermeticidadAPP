import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Size getScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

TextEditingController controllerEmail = TextEditingController();
TextEditingController controllerPassword = TextEditingController();

String nombreUsuarioGlobal = "";
String rolUsuarioGlobal = "";
int idUsuarioGlobal = 0;
String tokenUsuarioGlobal = "";
String fechaIngresoUsuario = "";
String idProgramacion = "Hola";

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
