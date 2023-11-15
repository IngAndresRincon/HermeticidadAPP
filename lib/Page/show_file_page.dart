import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

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

  Widget _extendedGraph() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Grafica de registro de mediciones'),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      primaryXAxis: DateTimeAxis(
          title: AxisTitle(text: "Seconds(s)"),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.seconds),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}PSI', numberFormat: NumberFormat.compact()),
      series: <ChartSeries>[
        LineSeries<ChartData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.timeP,
          yValueMapper: (ChartData data, _) => data.value,
        ),
      ],
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
                height: getScreenSize(context).height * .8,
                width: getScreenSize(context).width,
                child: _extendedGraph()),
          ],
        ));
  }
}
