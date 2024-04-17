import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join; // Importa la función join
import 'dart:io';
import 'dart:developer' as developer;

class CameraPage extends StatefulWidget {
  final String fileNameCamera;
  const CameraPage({super.key, required this.fileNameCamera});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  late CameraController cameraController;
  bool flagCamera = false;
  bool isloading = false;
  late File _image;
  late ScrollController _scrollController;
  Map<String, File> mapFiles = {};

  @override
  void initState() {
    super.initState();
    inicializarCamara().then((value) => {flagCamera = true});
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    cameraController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> inicializarCamara() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await cameraController.initialize();
    if (mounted) {
      setState(
          () {}); // Actualiza el estado para reflejar el cambio en la vista
    }
  }

  Future<bool> _takePicture() async {
    bool respuesta = false;
    try {
      if (flagCamera) {
        final path = join(
          (await getTemporaryDirectory()).path,
          '${DateTime.now()}.png',
        );
        XFile picture = await cameraController.takePicture();
        File(picture.path).copy(path);
        // La foto ha sido tomada y almacenada en 'path'
        developer.log('Foto tomada y guardada en: $path');

        // Mostrar el efecto de flash al tomar la foto

        _image = File(path);
        mapFiles = {widget.fileNameCamera: _image};
        respuesta = true;
        return respuesta;
      }
    } catch (e) {
      developer.log('Error al tomar la foto: $e');
    }
    return respuesta;
  }

  @override
  Widget build(BuildContext context) {
    if (!flagCamera) {
      return Container(); // O cualquier indicador de carga
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Evidencia Fotográfica",
          style: TextStyle(
              fontFamily: 'MontSerrat',
              fontWeight: FontWeight.w600,
              fontSize: getScreenSize(context).width * 0.04),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: getScreenSize(context).width,
            height: getScreenSize(context).height,
            child: CameraPreview(cameraController),
          ),
          isloading
              ? Align(
                  alignment: Alignment.center,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue.shade200,
                  )),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
                elevation: 10,
                color: Colors.white,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isloading = !isloading;
                    });
                    _takePicture().then((bool value) {
                      if (value) {
                        showMessageTOAST(
                            context, "Imagen Guardada", Colors.black54);
                        Navigator.pop(context, mapFiles);
                      } else {
                        showMessageTOAST(context,
                            "No se pudo guardar la imagen", Colors.black54);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.camera,
                    size: getScreenSize(context).width * 0.1,
                    color: Colors.indigo.shade600,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
