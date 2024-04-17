import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Models/models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class CustomerCartesianChart extends StatelessWidget {
  final double mediumValue;
  final double tolerance;
  late ChartSeriesController chartSeriesController;
  final List<ChartData> chartData;

  CustomerCartesianChart(
      {super.key,
      required this.mediumValue,
      required this.tolerance,
      required this.chartSeriesController,
      required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.all(0),
      legend: Legend(
        iconBorderWidth: 2,
        offset: const Offset(20, -80),
        isVisible: true,
        position: LegendPosition.bottom,
        //alignment: ChartAlignment.center
      ),
      primaryXAxis: DateTimeAxis(
          axisLine: const AxisLine(width: 2, color: Colors.black45),
          title: AxisTitle(text: "Segundos(s)"),
          autoScrollingMode: AutoScrollingMode.end,
          autoScrollingDelta: 30,
          //edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.seconds,
          interval: 5),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 2, color: Colors.black45),
          //title: AxisTitle(text: 'PSI'),
          maximum: mediumValue * 2,
          minimum: 0,
          //labelFormat: '{value}PSI',
          plotBands: <PlotBand>[
            PlotBand(
              isVisible: true,
              start: mediumValue * (1 - 0.01 * tolerance),
              end: mediumValue * (1 + 0.01 * tolerance),
              opacity: 0.5,
              color: Colors.blueGrey.shade100,
              borderWidth: 1,
              dashArray: const <double>[5, 5],
              text: '±$tolerance%',
              horizontalTextAlignment: TextAnchor.end,
              verticalTextAlignment: TextAnchor.end,
              textStyle: const TextStyle(color: Colors.black),
            ),
            PlotBand(
              isVisible: true,
              start: mediumValue,
              end: mediumValue,
              opacity: 0.5,
              borderColor: Colors.cyan,
              borderWidth: 1,
              dashArray: const <double>[8, 8],
            )
          ]),
      series: <ChartSeries>[
        SplineSeries<ChartData, DateTime>(
          onRendererCreated: (ChartSeriesController controller) {
            chartSeriesController = controller;
          },
          legendItemText: "Presión[PSI]",
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.timeP,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.greenAccent.shade400,
          width: 2,
          opacity: 1,
          splineType: SplineType.monotonic,
        ),
      ],
    );
  }
}
