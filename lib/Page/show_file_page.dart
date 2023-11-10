import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:http/http.dart' as http;

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
                height: getScreenSize(context).height * .5,
                width: getScreenSize(context).width * 0.9,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: getScreenSize(context).height *
                          0.8, 
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          LineSeries<ChartData, String>(
                            dataSource: chartDataSave,
                            xValueMapper: (ChartData data, _) => data.timeP,
                            yValueMapper: (ChartData data, _) => data.value,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}
