import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class FilePage extends StatefulWidget {
  FilePage({super.key});
  final StorageFile storage = StorageFile();
  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  String fileContent = "";
  bool isSincronizeFile = false;
  final fileUrl = 'http://192.168.11.100:81/SD';

  Future<void> showDataFile() async {
    fileContent = await widget.storage.readFileData();
    setState(() {});
  }

  Future<void> sincronizeFile() async {
    widget.storage.writeFileData("Inicio de llenado\n");
    final response = await http.get(Uri.parse(fileUrl));
    widget.storage.writeFileData(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          elevation: 10,
          title: const Text(
            "file",
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: getScreenSize(context).height * .1,
              width: getScreenSize(context).width,
            ),
            SizedBox(
              height: getScreenSize(context).height * .1,
              width: getScreenSize(context).width,
              child: CustomerElevateButton(
                  onPressed: () async {
                    showDialogLoad(context);
                    await sincronizeFile();
                    await showDataFile().then((value) {
                      Navigator.pop(context);
                    });
                    isSincronizeFile = true;
                  },
                  texto: "Mostrar Resultados",
                  colorTexto: Colors.white,
                  colorButton: Colors.green.shade300,
                  height: .05,
                  width: .45),
            ),
            SizedBox(
              height: getScreenSize(context).height * .6,
              width: getScreenSize(context).width,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                fileContent,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    letterSpacing: 4,
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getScreenSize(context).height * .1,
              width: getScreenSize(context).width,
              child: CustomerElevateButton(
                  onPressed: isSincronizeFile
                      ? () {
                          showDialogLoad(context);
                          String fileContFormat = fileContent
                              .replaceAll("Registro de mediciones\n", "")
                              .replaceAll("------Calibracion-----\n", "")
                              .replaceAll("--------Testeo--------\n", "")
                              .replaceAll(" ", "")
                              .replaceAll("][", ",")
                              .replaceAll("]\n", ";")
                              .replaceAll("[", "");
                          developer.log(fileContFormat);
                          postFile(fileContFormat).then((value) {
                            Navigator.pop(context);
                            if (value) {
                              showMessageTOAST(
                                  context, "Archivo enviado", Colors.green);
                            } else {
                              showMessageTOAST(
                                  context,
                                  "Error, Conecte el dispositivo a la red movil e intente de nuevo",
                                  Colors.green);
                            }
                          });
                        }
                      : () {},
                  texto: "Enviar Datos",
                  colorTexto: Colors.white,
                  colorButton:
                      isSincronizeFile ? Colors.green.shade300 : Colors.grey,
                  height: .05,
                  width: .45),
            )
          ],
        ));
  }
}
