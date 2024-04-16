import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/cache.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:hermeticidadapp/Widgets/text_field.dart';

class ScreenOverlayConfiguration extends StatefulWidget {
  const ScreenOverlayConfiguration({
    super.key,
  });

  @override
  State<ScreenOverlayConfiguration> createState() =>
      _ScreenOverlayConfigurationState();
}

class _ScreenOverlayConfigurationState
    extends State<ScreenOverlayConfiguration> {
  bool isConfig = false;
  bool isLoading = false;

  @override
  void initState() {
    controllerPasswordConfig.clear();
    super.initState();
  }

  Future<void> btnSaveConfiguration() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> mapConfiguration = {
      'Ip': controllerIp.text,
      'Port': controllerPort.text
    };

    await saveConfiguration(mapConfiguration).then((bool value) {
      ipGlobal = controllerIp.text.trim();
      portGlobal = controllerPort.text.trim();
      showMessageTOAST(
          context,
          value
              ? "Configuración Guardada"
              : "Error  al guardar la configuración",
          Colors.black54);

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: getScreenSize(context).width * 0.8,
          height: !isConfig
              ? getScreenSize(context).height * 0.3
              : getScreenSize(context).height * 0.5,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 6,
                    color: Colors.white70,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 2)
              ]),
          child: !isLoading
              ? !isConfig
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "CONFIGURACIÓN",
                          style: TextStyle(
                              fontFamily: 'MontSerrat',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              fontSize: getScreenSize(context).width * 0.05),
                        ),
                        CustomerTextFormField(
                            label: "Código",
                            textinputtype: TextInputType.number,
                            obscure: true,
                            icondata: Icons.key,
                            texteditingcontroller: controllerPasswordConfig,
                            bsuffixIcon: false,
                            onTapSuffixIcon: () => {},
                            onChange: (value) {
                              print(value);
                              isConfig = value.length == 6 && value == "123456"
                                  ? true
                                  : false;
                              setState(() {});
                            },
                            suffixIcon: Icons.password_outlined,
                            width: 0.6,
                            labelColor: Colors.black87,
                            textColor: Colors.black87),
                        CustomerElevateButton(
                            texto: "Cerrar",
                            colorTexto: Colors.white,
                            colorButton: Colors.red,
                            onPressed: () => Navigator.pop(context),
                            height: 0.06,
                            width: 0.6),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "CONFIGURACIÓN",
                          style: TextStyle(
                              fontFamily: 'MontSerrat',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              fontSize: getScreenSize(context).width * 0.05),
                        ),
                        CustomerTextFormField(
                            label: "IP",
                            textinputtype: TextInputType.number,
                            obscure: false,
                            icondata: Icons.label,
                            texteditingcontroller: controllerIp,
                            bsuffixIcon: false,
                            onTapSuffixIcon: () => {},
                            onChange: (value) {},
                            suffixIcon: Icons.label,
                            width: 0.6,
                            labelColor: Colors.black87,
                            textColor: Colors.black87),
                        CustomerTextFormField(
                            label: "PUERTO",
                            textinputtype: TextInputType.number,
                            obscure: false,
                            icondata: Icons.label,
                            texteditingcontroller: controllerPort,
                            bsuffixIcon: false,
                            onTapSuffixIcon: () => {},
                            onChange: (value) {},
                            suffixIcon: Icons.label,
                            width: 0.6,
                            labelColor: Colors.black87,
                            textColor: Colors.black87),
                        CustomerElevateButton(
                            texto: "Guardar",
                            colorTexto: Colors.white,
                            colorButton: Colors.blue.shade400,
                            onPressed: btnSaveConfiguration,
                            height: 0.06,
                            width: 0.6),
                        CustomerElevateButton(
                            texto: "Cerrar",
                            colorTexto: Colors.white,
                            colorButton: Colors.red,
                            onPressed: () => Navigator.pop(context),
                            height: 0.06,
                            width: 0.6),
                      ],
                    )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
