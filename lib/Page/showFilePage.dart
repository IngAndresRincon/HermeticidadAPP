import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/elevateButton.dart';
import 'package:http/http.dart' as http;

class FilePage extends StatefulWidget {
  FilePage({super.key});
  final StorageFile storage = StorageFile();
  @override
  State<FilePage> createState() => _filePageState();
}

class _filePageState extends State<FilePage> {
  String fileContent = "";
  bool isSincronizeFile = false;
  final fileUrl = 'http://192.168.11.100:81/SD';

  Future<void> showDataFile() async {
    fileContent = await widget.storage.readFileData();
    // print(fileContent
    //     .replaceAll("][", ",")
    //     .replaceAll("]\n", ";")
    //     .replaceAll("[", ""));
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
            Container(
              height: getScreenSize(context).height * .1,
              width: getScreenSize(context).width,
            ),
            Container(
              height: getScreenSize(context).height * .1,
              width: getScreenSize(context).width,
              child: CustomerElevateButton(
                  onPressed: () async {
                    showDialogLoad(context);
                    await sincronizeFile().then((value) {
                      Navigator.pop(context);
                    });
                    showDialogLoad(context);
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
            Container(
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
            Container(
              height: getScreenSize(context).height * .1,
              width: getScreenSize(context).width,
              child: CustomerElevateButton(
                  onPressed: isSincronizeFile
                      ? () {
                          showDialogLoad(context);
                          String fileContFormat =fileContent
                                  .replaceAll("Registro de mediciones\n", "")
                                  .replaceAll("--------Testeo--------\n", "").replaceAll(" ", "")
                                  .replaceAll("][", ",")
                                  .replaceAll("]\n", ";")
                                  .replaceAll("[", "");
                            postFile(fileContFormat)
                              .then((value) {
                            Navigator.pop(context);
                            if(value){
                              showMessageTOAST(
                                context, "Archivo enviado", Colors.green);
                            } else{
                              showMessageTOAST(
                                context, "Error, Conecte el dispositivo a la red movil e intente de nuevo", Colors.green);
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
