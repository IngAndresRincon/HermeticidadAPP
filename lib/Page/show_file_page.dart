import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
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
  String fileContent = "";
  bool isSincronizeFile = false;
  double visibleMinimum = 0;
  double visibleMaximum = 30;
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

  Widget _extendedGraph() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) {
        // Manejar el evento de desplazamiento horizontal
        if (details.delta.dx > 0 && visibleMinimum > 0) {
          setState(() {
            visibleMinimum -= .2;
            visibleMaximum -= .2;
          });
        } else if (details.delta.dx < 0 &&
            visibleMaximum < chartData.length - 1) {
          setState(() {
            visibleMinimum += .2;
            visibleMaximum += .2;
          });
        }
      },
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          visibleMinimum: visibleMinimum,
          visibleMaximum: visibleMaximum,
        ),
        series: <ChartSeries>[
          LineSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.timeP,
            yValueMapper: (ChartData data, _) => data.value,
          ),
        ],
      ),
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
