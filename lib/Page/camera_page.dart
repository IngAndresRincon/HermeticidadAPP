import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join; // Importa la función join
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  late CameraController cameraController;
  bool flagCamera = false;
  bool _flash = false;
  final List<File> _capturedImages = [];
  late ScrollController _scrollController;

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

  Future<void> _takePicture() async {
    try {
      if (flagCamera) {
        final path = join(
          (await getTemporaryDirectory()).path,
          '${DateTime.now()}.png',
        );

        XFile picture = await cameraController.takePicture();
        File(picture.path).copy(path);

        // La foto ha sido tomada y almacenada en 'path'
        print('Foto tomada y guardada en: $path');

        // Mostrar el efecto de flash al tomar la foto
        setState(() {
          _flash = true;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _flash = false;
          _capturedImages.add(File(path));
        });
        // Scroll automático al final del ListView
        if (_capturedImages.length > 4) {
          _scrollController.animateTo(
            _scrollController.position.devicePixelRatio,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    } catch (e) {
      print('Error al tomar la foto: $e');
    }
  }

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

  PreferredSizeWidget _appbar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            dispose();
            Navigator.pushNamed(context, 'test');
          },
          icon: const Icon(Icons.arrow_back_ios)),
      elevation: 10,
      title:
          _defaultText(0.03, 'Evidencias', 18, Colors.black45, FontWeight.bold),
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
    );
  }

  Widget _defaultText(double height, String text, double fontSize, Color color,
      FontWeight fontWeight) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            letterSpacing: 4,
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!flagCamera) {
      return Container(); // O cualquier indicador de carga
    }
    return Scaffold(
      appBar: _appbar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CameraPreview(cameraController)),
          _flash
              ? Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Container(),
          Positioned(
            bottom: 36.0,
            child: FloatingActionButton(
              onPressed: _takePicture,
              child: const Icon(Icons.camera),
            ),
          ),
          _capturedImages.isNotEmpty
              ? Positioned(
                  bottom: 100.0,
                  child: SizedBox(
                    width: getScreenSize(context).width * 0.9,
                    height: getScreenSize(context).height * 0.2,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _capturedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          child: Image.file(
                            _capturedImages[index],
                            width: getScreenSize(context).width * 0.2,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
