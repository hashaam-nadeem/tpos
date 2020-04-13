import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:transact/utils/utils.dart';

class BarChartSample5 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample5State();
}

class BarChartSample5State extends State<BarChartSample5> {
  static const double barWidth = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, right: 20),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: 20,
              groupsSpace: 10,
              barTouchData: const BarTouchData(
                enabled: true,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle:
                      TextStyle(color: HexColor("#3B444B"), fontSize: 12),
                  margin: 10,
                  rotateAngle: 0,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Mon';
                      case 1:
                        return 'Tue';
                      case 2:
                        return 'Wed';
                      case 3:
                        return 'Thu';
                      case 4:
                        return 'Fri';
                      case 5:
                        return 'Sat';
                      case 6:
                        return 'Sun';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  textStyle:
                      TextStyle(color: HexColor("#3B444B"), fontSize: 12),
                  rotateAngle: 0.0,
                  getTitles: (double value) {
                    if (value == 0) {
                      return '0';
                    }
                    return '${value.toInt()}0';
                  },
                  interval: 5,
                  margin: 8,
                  reservedSize: 30,
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 5 == 0,
                getDrawingHorizontalLine: (value) {
                  if (value == 0) {
                    return const FlLine(
                        color: Color(0xff363753), strokeWidth: 2);
                  }
                  return const FlLine(
                    color: Color(0xff2a2747),
                    strokeWidth: 0.8,
                  );
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: [
                const BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      color: Color(0xff60E87E),
                      y: 6.1,
                      width: barWidth,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                    ),
                  ],
                ),
                const BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      color: Color(0xff60E87E),
                      y: 8,
                      width: barWidth,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                    ),
                  ],
                ),
                const BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      color: Color(0xff60E87E),
                      y: 13,
                      width: barWidth,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                    ),
                  ],
                ),
                const BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(
                      color: Color(0xff60E87E),
                      y: 15.5,
                      width: barWidth,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                    ),
                  ],
                ),
                const BarChartGroupData(
                  x: 4,
                  barRods: [
                    BarChartRodData(
                      color: Color(0xff60E87E),
                      y: 8,
                      width: barWidth,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                    ),
                  ],
                ),
                const BarChartGroupData(
                  x: 5,
                  barRods: [
                    BarChartRodData(
                      color: Color(0xff60E87E),
                      y: 7,
                      width: barWidth,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                    ),
                  ],
                ),
                const BarChartGroupData(
                  x: 6,
                  barRods: [
                    BarChartRodData(
                      color: Color(0xff60E87E),
                      y: 6,
                      width: barWidth,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
