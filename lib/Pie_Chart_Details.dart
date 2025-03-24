import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Data {
  final String name;
  final double percent;
  final Color color;
  Data({required this.name, required this.percent, required this.color});
}

class PieData {
  static List<Data> data = [
    Data(name: 'Food', percent: 40.0, color: Colors.blueAccent),
    Data(name: 'Laundry', percent: 15.0, color: Colors.greenAccent),
    Data(name: 'Stationery', percent: 10.0, color: Colors.redAccent),
    Data(name: 'Miscellaneous', percent: 35.0, color: Colors.orangeAccent),
  ];
}

List<PieChartSectionData> getSections() => PieData.data
    .asMap()
    .map<int, PieChartSectionData>(
      (index, data) {
        final value = PieChartSectionData(
          color: data.color,
          value: data.percent,
          title: '',
          titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        );
        return MapEntry(index, value);
      },
    )
    .values
    .toList();

class IndicatorWidget extends StatefulWidget {
  const IndicatorWidget({super.key});

  @override
  State<IndicatorWidget> createState() => _IndicatorWidgetState();
}

class _IndicatorWidgetState extends State<IndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PieData.data
          .map(
            (data) => Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: buildIndicator(
                color: data.color,
                text: '${data.name}  ${data.percent}%',
              ),
            ),
          )
          .toList(),
    );
  }
}

Widget buildIndicator({
  required Color color,
  required String text,
  bool isSquare = false,
  double size = 16,
  Color textColor = Colors.white,
}) {
  return Row(
    children: <Widget>[
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          color: color,
        ),
      ),
      SizedBox(width: 10),
      Text(
        text,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
      ),
    ],
  );
}
