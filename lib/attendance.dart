import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class AttendanceForm extends StatefulWidget {
  static const id = 'AttendanceForm';
  const AttendanceForm({super.key});

  @override
  State<AttendanceForm> createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  final TextEditingController _subjectController = TextEditingController();
  final Map<String, List<Map<String, String>>> _attendanceMap = {};
  final List<BarChartGroupData> _barGroups = [];
  String? _selectedSubject;

  /// Add a new subject
  void _addSubject() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Subject'),
          content: TextField(
            controller: _subjectController,
            decoration: const InputDecoration(labelText: 'Subject Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final subject = _subjectController.text.trim();
                if (subject.isNotEmpty && !_attendanceMap.containsKey(subject)) {
                  setState(() {
                    _attendanceMap[subject] = [];
                    _updateChart();
                  });
                }
                _subjectController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Delete a subject
  void _deleteSubject() {
    if (_attendanceMap.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subject'),
          content: DropdownButton<String>(
            value: _selectedSubject,
            hint: const Text('Select Subject'),
            onChanged: (String? value) {
              setState(() {
                _selectedSubject = value;
              });
            },
            items: _attendanceMap.keys.map((subject) {
              return DropdownMenuItem<String>(
                value: subject,
                child: Text(subject),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_selectedSubject != null) {
                  setState(() {
                    _attendanceMap.remove(_selectedSubject);
                    _selectedSubject = null;
                    _updateChart();
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// Mark attendance for a subject
  void _addAttendance() {
    if (_attendanceMap.isEmpty) return;

    String? selectedSubject;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark Attendance'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedSubject,
                    hint: const Text('Select Subject'),
                    onChanged: (String? value) {
                      setState(() {
                        selectedSubject = value;
                      });
                    },
                    items: _attendanceMap.keys.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (selectedSubject != null) {
                            _recordAttendance(selectedSubject!, selectedDate, isPresent: true);
                            Navigator.of(context).pop();
                          }
                        },
                        style : ElevatedButton.styleFrom (
                          backgroundColor : Colors.green ,
                          foregroundColor : Colors.white ,
                        ),
                        child: const Text('Present'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedSubject != null) {
                            _recordAttendance(selectedSubject!, selectedDate, isPresent: false);
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, //  Red for "Absent"
                          foregroundColor: Colors.white, //  Text color (White)
                        ),
                        child: const Text('Absent'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _recordAttendance(String subject, DateTime date, {required bool isPresent}) {
    setState(() {
      _attendanceMap[subject]!.add({
        'date': date.toIso8601String(),
        'status': isPresent ? 'Present' : 'Absent',
      });
      _updateChart();

      // 🐞 Debug: Check data stored
      print("📊 Attendance Map Updated: $_attendanceMap");
    });
  }



  /// Show attendance by selected subject
  void _showAttendanceBySubject() {
    if (_attendanceMap.isEmpty) {
      print("⚠️ No subjects available");
      return;
    }

    String? selectedSubject;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attendance by Subject'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedSubject,
                    hint: const Text('Select Subject'),
                    onChanged: (String? value) {
                      setState(() {
                        selectedSubject = value;
                      });
                    },
                    items: _attendanceMap.keys.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Display Subject Name
                  if (selectedSubject != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Subject: $selectedSubject',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                  // Display Attendance Table
                  if (selectedSubject != null && _attendanceMap[selectedSubject] != null)
                    SizedBox(
                      height: 300,
                      child: _attendanceMap[selectedSubject]!.isEmpty
                          ? const Center(child: Text('No attendance records available'))
                          : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: _attendanceMap[selectedSubject]!.map((record) {
                            return DataRow(cells: [
                              DataCell(Text(record['date']!.split('T').first)),
                              DataCell(Text(record['status']!)),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }



  /// Update chart data
  void _updateChart() {
    _barGroups.clear();
    int index = 0;
    _attendanceMap.forEach((subject, records) {
      int presentCount = records.where((record) => record['status'] == 'Present').length;
      double percentage = (records.isNotEmpty) ? (presentCount / records.length) * 100 : 0;
      _barGroups.add(
        BarChartGroupData(
          x: index++,
          barRods: [
            BarChartRodData(
              toY: percentage,
              color: Colors.blue,
              width: 16,
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _addSubject, child: const Text('Add Subject')),
                ElevatedButton(onPressed: _deleteSubject, child: const Text('Delete Subject')),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _addAttendance, child: const Text('Mark Attendance')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _showAttendanceBySubject, child: const Text('Attendance by Subject')),
            const SizedBox(height: 32),
            if (_barGroups.isNotEmpty)
              SizedBox(
                height: 300,
                width: 400, // ✅ Decreased the width of the chart
                child: BarChart(
                  BarChartData(
                    barGroups: _barGroups,
                    maxY: 100,

                    // ✅ Adjust Y-axis to prevent overflow
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30, // Adjust space for Y-axis labels
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}', // Display as percentage
                              style: const TextStyle(fontSize: 12), // Smaller font size
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(_attendanceMap.keys.elementAt(value.toInt()));
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              ),


          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }
}
