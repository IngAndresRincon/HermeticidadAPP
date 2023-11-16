import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';

class ScreenOverlayMessages extends StatefulWidget {
  const ScreenOverlayMessages({super.key});

  @override
  State<ScreenOverlayMessages> createState() => _ScreenOverlayMessagesState();
}

class _ScreenOverlayMessagesState extends State<ScreenOverlayMessages> {
  Widget _closeBar(double height, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(icon)),
      ),
    );
  }

  Widget _defaultText(double height, String text, double fontSize,
      double letterSpacing, FontWeight fontWeight) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Text(
        text,
        style: TextStyle(
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontSize: fontSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Card(
          color: const Color.fromARGB(242, 247, 247, 247),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: getScreenSize(context).width * 0.9,
            height: getScreenSize(context).height * 0.4,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(0.05, "MENSAJES", 18, 2, FontWeight.bold)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenOverlayProfile extends StatefulWidget {
  const ScreenOverlayProfile({super.key});

  @override
  State<ScreenOverlayProfile> createState() => _ScreenOverlayProfileState();
}

class _ScreenOverlayProfileState extends State<ScreenOverlayProfile> {
  Widget _closeBar(double height, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(icon)),
      ),
    );
  }

  Widget _defaultText(double height, String text, double fontSize,
      double letterSpacing, FontWeight fontWeight) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Text(
        text,
        style: TextStyle(
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontSize: fontSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Card(
          color: const Color.fromARGB(242, 247, 247, 247),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: getScreenSize(context).width * 0.9,
            height: getScreenSize(context).height * 0.4,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(0.05, "PERFIL", 18, 2, FontWeight.bold)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenOverlaySettingsHome extends StatefulWidget {
  const ScreenOverlaySettingsHome({super.key});

  @override
  State<ScreenOverlaySettingsHome> createState() =>
      _ScreenOverlaySettingsHomeState();
}

class _ScreenOverlaySettingsHomeState extends State<ScreenOverlaySettingsHome> {
  Widget _closeBar(double height, IconData icon) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(icon)),
      ),
    );
  }

  Widget _defaultText(double height, String text, double fontSize,
      double letterSpacing, FontWeight fontWeight) {
    return SizedBox(
      height: getScreenSize(context).height * height,
      child: Text(
        text,
        style: TextStyle(
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontSize: fontSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Card(
          color: const Color.fromARGB(242, 247, 247, 247),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: getScreenSize(context).width * 0.9,
            height: getScreenSize(context).height * 0.4,
            child: Column(
              children: [
                _closeBar(0.05, Icons.close),
                _defaultText(0.05, "SETTINGS", 18, 2, FontWeight.bold)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
