import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:hermeticidadapp/Tools/functions.dart';
import 'package:hermeticidadapp/Widgets/elevate_button.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:syncfusion_flutter_charts/charts.dart';

class FilePage extends StatefulWidget {
  FilePage({super.key});
  final StorageFile storage = StorageFile();
  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  String fileContent = "";
  bool isSincronizeFile = false;
  double visibleMinimum = 0;
  double visibleMaximum = 30;
  final fileUrl = 'http://192.168.11.100:81/SD';

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true,
        enablePanning: true,
        zoomMode: ZoomMode.x
        //maximumZoomLevel: 0.3
        );
    super.initState();
  }

  Future<void> showDataFile() async {
    fileContent = await widget.storage.readFileData();
    setState(() {});
  }

  Future<void> sincronizeFile() async {
    widget.storage.writeFileData("Inicio de llenado\n");
    final response = await http.get(Uri.parse(fileUrl));
    widget.storage.writeFileData(response.body);
  }

  void sendFileApi() {
    showDialogLoad(context);
    String fileContFormat = fileContentData
        .replaceAll("Registro de mediciones\n", "")
        .replaceAll("------Calibracion-----\n", "")
        .replaceAll("--------Testeo--------\n", "")
        .replaceAll(" ", "")
        .replaceAll("][", ",")
        .replaceAll("]\n", ";")
        .replaceAll("[", "");
    developer.log(fileContFormat);
    String fileUrl =
        'http://${controllerIp.text}:${controllerPort.text}/api/POSTsubirArchivo';
    postFile(fileUrl, fileContFormat).then((value) {
      Navigator.pop(context);
      if (value) {
        showMessageTOAST(context, "Archivo enviado", Colors.green);
      } else {
        showMessageTOAST(context,
            "Error, Conectese a la red movil e intente de nuevo", Colors.green);
      }
    });
  }

  Widget _extendedGraph() {
    return SfCartesianChart(
      title: ChartTitle(
          text: 'REGISTRO PRUEBA DE HERMETICIDAD',
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      legend: Legend(
        iconBorderWidth: 2,
        offset: const Offset(20, -80),
        isVisible: true,
        position: LegendPosition.bottom,
        //alignment: ChartAlignment.center
      ),
      tooltipBehavior: _tooltipBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      // plotAreaBorderWidth: 2,
      // plotAreaBorderColor: Colors.black,
      primaryXAxis: DateTimeAxis(
          axisLine: const AxisLine(width: 2, color: Colors.black45),
          title: AxisTitle(text: "Segundos(s)"),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.seconds),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 2, color: Colors.black45),
        maximum: pressureCalib * 2,
        minimum: 0,
        labelFormat: '{value}PSI',
        //numberFormat: NumberFormat.compact()
      ),
      series: <ChartSeries>[
        SplineSeries<ChartData, DateTime>(
          legendItemText: "Presión[PSI]",
          dataSource: chartDataStatic,
          xValueMapper: (ChartData data, _) => data.timeP,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.greenAccent.shade400,
          width: 2,
          opacity: 1,
          splineType: SplineType.monotonic,
          //dashArray: const <double>[5, 5],
        ),
        LineSeries<ChartData, DateTime>(
          legendItemText: '+$timeAperture%',
          dataSource: lineToleranceUp,
          xValueMapper: (ChartData lineToleranceUp, _) => lineToleranceUp.timeP,
          yValueMapper: (ChartData lineToleranceUp, _) => lineToleranceUp.value,
          color: Colors.cyan,
          width: 1,
          opacity: 0.4,
          //dashArray: const <double>[10, 10],
        ),
        LineSeries<ChartData, DateTime>(
          legendItemText: "-$timeAperture%",
          dataSource: lineToleranceDown,
          xValueMapper: (ChartData lineToleranceDown, _) =>
              lineToleranceDown.timeP,
          yValueMapper: (ChartData lineToleranceDown, _) =>
              lineToleranceDown.value,
          color: Colors.cyan,
          width: 1,
          opacity: 0.4,
          //dashArray: const <double>[10, 10],
        )
      ],
    );
  }

  Widget _sendDataButton(String text) {
    return CustomerElevateButton(
        onPressed: sendFileApi,
        texto: text,
        colorTexto: Colors.white,
        colorButton: Colors.green.shade300,
        height: .05,
        width: .5);
  }

  Widget _defaultText(String text, double fontSize, Color color,
      double letterSpacing, FontWeight fontWeight) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          letterSpacing: letterSpacing,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight),
    );
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
          title: _defaultText(
              "Measurement", 18, Colors.black45, 2, FontWeight.bold),
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
                height: getScreenSize(context).height * .7,
                width: getScreenSize(context).width,
                child: _extendedGraph()),
            SizedBox(
                height: getScreenSize(context).height * .02,
                child: _defaultText("*Conecte su dispositivo a la red movil",
                    14, Colors.red, 2, FontWeight.bold)),
            SizedBox(
                height: getScreenSize(context).height * .05,
                //width: getScreenSize(context).width,
                child: _sendDataButton("Enviar Datos"))
          ],
        ));
  }
}
